#!/bin/sh
# ReadyStack SeaweedFS entrypoint.
#
# By default `weed server -s3` accepts anonymous, unsigned S3 reads and writes on :8333, its
# master (:9333), volume (:8080) and filer (:8888) APIs carry no authentication of their own,
# and the S3 gateway's gRPC port (:18333, which always binds to the same address as :8333)
# lets any caller replace S3 identities and policies unless a filer signing key is configured
# (audits 2026-09-30 and 2026-10-04). This wrapper only changes behaviour for the `server`
# subcommand -- the one this image ships as its default command:
#   - refuses to start `weed server` without S3 credentials, unless ALLOW_ANONYMOUS_S3=yes
#     (an SEAWEEDFS_S3_CONFIG file with no identity that has an access key counts as none);
#   - generates a random jwt.filer_signing.key on every start (exported to weed as
#     WEED_JWT_FILER_SIGNING_KEY, and written to /etc/seaweedfs/security.toml so that
#     `docker exec <container> weed shell` picks up the same key), so every call to the S3
#     gateway's gRPC services and the filer's IAM gRPC service needs an admin token signed
#     with it. An operator-supplied WEED_JWT_FILER_SIGNING_KEY is used as given instead;
#   - defaults -volume.max=0 (volume slots sized from free disk space, as upstream's own
#     image does) and WEED_MASTER_VOLUME_GROWTH_COPY_1=1 (each new bucket claims one volume
#     at a time, as upstream's single-node `weed mini` does), so one or two buckets cannot
#     use up every volume slot; both stay overridable (a later -volume.max flag, or your own
#     WEED_MASTER_VOLUME_GROWTH_COPY_1);
#   - forces -dir=/data and -master.volumeSizeLimitMB=1024, which nothing given after the
#     image name can override;
#   - every OTHER flag -- including the -ip/-ip.bind/-s3.ip.bind/-s3.port.iceberg/
#     -s3.port.lance/-filer.disableHttp hardening this image ships as its default CMD -- is a
#     plain pass-through: arguments given after the image name (`docker run IMAGE <args>`)
#     replace the default CMD entirely, and are placed BEFORE the forced -dir/
#     -master.volumeSizeLimitMB, so a later occurrence of any other flag always wins.
# A subcommand other than `server` (e.g. `weed version`) is passed straight to `weed` with no
# credential check, no generated key and no added flags.
set -e

[ "${1:-}" = "weed" ] && shift

if [ "${1:-}" != "server" ]; then
  exec weed "$@"
fi

cred_mode=""
if [ -n "${SEAWEEDFS_S3_CONFIG:-}" ]; then
  if [ ! -r "${SEAWEEDFS_S3_CONFIG}" ]; then
    echo "readystack: SEAWEEDFS_S3_CONFIG=${SEAWEEDFS_S3_CONFIG} is not a readable file." >&2
    exit 1
  fi
  if ! grep -Eq '"(accessKey|access_key)"[[:space:]]*:[[:space:]]*"[^"[:space:]]' "${SEAWEEDFS_S3_CONFIG}"; then
    if [ "${ALLOW_ANONYMOUS_S3:-}" = "yes" ]; then
      echo "readystack: ALLOW_ANONYMOUS_S3=yes -- SEAWEEDFS_S3_CONFIG=${SEAWEEDFS_S3_CONFIG} defines no identity with an access key; starting anyway." >&2
    else
      echo "readystack: refusing to start -- SEAWEEDFS_S3_CONFIG=${SEAWEEDFS_S3_CONFIG} defines no identity with an access key (no non-empty \"accessKey\"), so it sets up no S3 credentials. Add an identity with credentials to it, or set ALLOW_ANONYMOUS_S3=yes." >&2
      exit 1
    fi
  fi
  cred_mode="config"
elif [ -n "${SEAWEEDFS_S3_ACCESS_KEY:-}" ] || [ -n "${SEAWEEDFS_S3_SECRET_KEY:-}" ]; then
  if [ -z "${SEAWEEDFS_S3_ACCESS_KEY:-}" ] || [ -z "${SEAWEEDFS_S3_SECRET_KEY:-}" ]; then
    echo "readystack: set BOTH SEAWEEDFS_S3_ACCESS_KEY and SEAWEEDFS_S3_SECRET_KEY (only one was given)." >&2
    exit 1
  fi
  export AWS_ACCESS_KEY_ID="${SEAWEEDFS_S3_ACCESS_KEY}"
  export AWS_SECRET_ACCESS_KEY="${SEAWEEDFS_S3_SECRET_KEY}"
  cred_mode="keys"
elif [ "${ALLOW_ANONYMOUS_S3:-}" = "yes" ]; then
  echo "readystack: ALLOW_ANONYMOUS_S3=yes -- starting with NO S3 credentials configured. The S3 gateway will accept anonymous, unsigned reads and writes from anyone who can reach it." >&2
  cred_mode="anon"
else
  echo "readystack: refusing to start -- set SEAWEEDFS_S3_ACCESS_KEY and SEAWEEDFS_S3_SECRET_KEY (or mount a config file and set SEAWEEDFS_S3_CONFIG), or set ALLOW_ANONYMOUS_S3=yes to allow anonymous, unsigned S3 access." >&2
  exit 1
fi

if [ -z "${WEED_JWT_FILER_SIGNING_KEY:-}" ]; then
  WEED_JWT_FILER_SIGNING_KEY="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  if [ ${#WEED_JWT_FILER_SIGNING_KEY} -ne 64 ]; then
    echo "readystack: could not generate a random signing key from /dev/urandom." >&2
    exit 1
  fi
  export WEED_JWT_FILER_SIGNING_KEY
  sec=/etc/seaweedfs/security.toml
  if [ ! -e "$sec" ] || grep -q '^# readystack-entrypoint generated' "$sec" 2>/dev/null; then
    if ! ( umask 077 && printf '%s\n' \
        '# readystack-entrypoint generated: random per-start key, rewritten on every container start.' \
        '[jwt.filer_signing]' "key = \"${WEED_JWT_FILER_SIGNING_KEY}\"" > "$sec" ) 2>/dev/null; then
      echo "readystack: note -- could not write $sec; the server still uses the generated key, but \`weed shell\` S3 IAM commands run with docker exec will not have it." >&2
    fi
  else
    echo "readystack: note -- $sec was supplied by you and was left unchanged; the server uses a generated key (set WEED_JWT_FILER_SIGNING_KEY to use your own)." >&2
  fi
fi

if [ -z "${WEED_MASTER_VOLUME_GROWTH_COPY_1:-}" ]; then
  export WEED_MASTER_VOLUME_GROWTH_COPY_1=1
fi

shift
if [ "$cred_mode" = "config" ]; then
  exec weed server -volume.max=0 "$@" -s3.config="${SEAWEEDFS_S3_CONFIG}" -dir=/data -master.volumeSizeLimitMB=1024
fi
exec weed server -volume.max=0 "$@" -dir=/data -master.volumeSizeLimitMB=1024
