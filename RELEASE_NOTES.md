# SeaweedFS 4.55 — ReadyStack release `4.55-CE-ubuntu24.04-r1`

Generated 2026-11-25 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/seaweedfs:4.55-CE-ubuntu24.04-r1` (linux/amd64). Index digest `sha256:1d2164cd299954a89410c059b22e7828e0f57f8a704a317a4348f3c27d4f1450` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:77407a338231feadb17d0bf6dfe43d9ece008f39e711109567a9d85014f0c5d8` [`TARGET_DIGEST.txt`].
- **Upstream:** SeaweedFS 4.55 built from source at `4.55` of https://github.com/seaweedfs/seaweedfs — upstream notes: https://github.com/seaweedfs/seaweedfs/releases/tag/4.55 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `seaweedfs`.
- **Build:** `source-rebuild-go`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `4.54-CE-ubuntu24.04-r2`.

## What changed in this release

- Upstream version 4.54 → 4.55.
- Minimum dependency versions ReadyStack enforces on top of upstream (raised only where upstream's own version was lower); shipped versions from the SBOM [`docs/sbom/SBOM.json`]:
  - `google.golang.org/grpc` at least `v1.83.2`: not raised, upstream already pins `v1.86.0-dev.0.20261027044109-d619b5d02089` (shipped: `v1.86.0-dev.0.20261027044109-d619b5d02089`)
  - `golang.org/x/image` at least `v0.45.0`: not raised, upstream already pins `v0.46.0` (shipped: `v0.46.0`)
  - `golang.org/x/net` at least `v0.62.0`: not raised, upstream already pins `v0.62.0` (shipped: `v0.62.0`)
  - `github.com/klauspost/compress` at least `v1.18.7`: not raised, upstream already pins `v1.20.3` (shipped: `v1.20.3`)
  - `github.com/go-jose/go-jose/v4` at least `v4.1.6`: not raised, upstream already pins `v4.1.6` (shipped: `v4.1.6`)
  - `github.com/apache/thrift` raised from upstream's `v0.24.0` to at least `v0.25.0` (shipped: `v0.25.0`)
- This release moves SeaweedFS from 4.54 to 4.55, a newer release of upstream's 4.x line. Upstream's release notes list what changed: https://github.com/seaweedfs/seaweedfs/releases/tag/4.55

## Security status at release (measured 2026-11-25)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `seaweedfs` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/seaweedfs:4.55-CE-ubuntu24.04-r1` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:77407a338231feadb17d0bf6dfe43d9ece008f39e711109567a9d85014f0c5d8`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 2 of 2 use cases passed (2 authored) against the running image [`docs/validation/test-results.json`].
- The cases are `GET /status` (200), `GET /healthz` (200); the suite checks nothing else.

## Known issues

- **low** (ReadyStack package): Docker Hub README: The problem named by the open Known issue still stands: the text describes upstream capabilities (POSIX file system, table storage, growing by adding volume servers) that this image disables or… [`RSD-seaweedfs-a2395c1c61`]

## Defects fixed

- 27 problems found before release and fixed before it shipped (27 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/seaweedfs:4.55-CE-ubuntu24.04-r1
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

