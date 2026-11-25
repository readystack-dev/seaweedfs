# GENERATED L-009 hermetic build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases from BASE_IMAGE_DIGESTS.lock; vendored Go tree + debs from Dockerfile.vendor.
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_weed
COPY vendored/seaweedfs-src/ /src/
WORKDIR /src/
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOWORK=off GOFLAGS="-mod=vendor -buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795577259
RUN go build -trimpath -ldflags='-s -w -extldflags -static -X github.com/seaweedfs/seaweedfs/weed/util/version.COMMIT=4.55' -o /weed ./weed && /weed version && \
    { readelf -lW /weed | sed -n 's/.*Requesting program interpreter: \(.*\)]$/\1/p'; readelf -dW /weed | sed -n 's/.*Shared library: \[\(.*\)\]$/\1/p'; } > /weed.needs
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.26.11-bookworm@sha256:dc40a13b61304647ed7e5d581d246b86413dfc29d63c6d018310feb93cd98fc0 AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795577259
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rootfs
ARG SOURCE_DATE_EPOCH=1795577259
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'seaweedfs:x:999:999::/data:/bin/sh\n' >> /rootfs/etc/passwd && printf 'seaweedfs:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/data /rootfs/etc/seaweedfs && chown -R 999:999 /rootfs/data /rootfs/etc/seaweedfs
COPY --from=build_weed /weed /rootfs/usr/bin/weed
COPY --from=build_weed /weed.needs /tmp/needs/weed
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY readystack-entrypoint.sh /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN chmod 755 /rootfs/usr/bin/weed /rootfs/usr/local/bin/rs-probe && \
    chown 999:999 /rootfs/usr/local/bin/readystack-entrypoint.sh && \
    chmod 0755 /rootfs/usr/local/bin/readystack-entrypoint.sh
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1795577259
COPY --from=rootfs /rootfs/ /
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LABEL org.opencontainers.image.title="SeaweedFS"
LABEL org.opencontainers.image.version="4.55-CE-ubuntu24.04-r1"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/seaweedfs/seaweedfs"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL readystack.product="seaweedfs"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-go"
LABEL readystack.open_source_note="Apache-2.0 self-hosted S3 storage; a live successor after MinIO CE upstream was archived (Feb 2026)"
LABEL org.opencontainers.image.revision="a98c9e27185cf1003eca095761a39973c60734db"
HEALTHCHECK --interval=5s --timeout=40s --start-period=15s \
  CMD /usr/local/bin/rs-probe http://127.0.0.1:8333/healthz || exit 1
USER seaweedfs
EXPOSE 8333
ENTRYPOINT ["/usr/local/bin/readystack-entrypoint.sh"]
CMD ["server", "-s3", "-ip=127.0.0.1", "-ip.bind=127.0.0.1", "-s3.ip.bind=0.0.0.0", "-s3.port.iceberg=0", "-s3.port.lance=0", "-filer.disableHttp"]
