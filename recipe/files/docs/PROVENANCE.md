# Provenance — SeaweedFS (`4.55-CE-ubuntu24.04-r1`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/seaweedfs/seaweedfs
- Revision built: `4.55` (commit `a98c9e27185cf1003eca095761a39973c60734db`)
- Source tree: `75b8121e89576c88cc9a39cb681f656b567968282b0182a0e48e4628bb1d0e2a` over 4882 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-go`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795577259` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/seaweedfs:4.55-CE-ubuntu24.04-r1` — index digest `sha256:1d2164cd299954a89410c059b22e7828e0f57f8a704a317a4348f3c27d4f1450` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:77407a338231feadb17d0bf6dfe43d9ece008f39e711109567a9d85014f0c5d8` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/seaweedfs:4.55-CE-ubuntu24.04-r1`

## Pinned inputs, and why

- 33 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 3, image digests 2, dependency versions readystack sets 7, pins in the kit's dockerfiles 12, readystack's build engine 5, dependencies upstream chose 2).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.trail.json`, published beside this archive and signed with the release key (`ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.trail.json.sigstore`), and readable at https://readystack.dev/products/seaweedfs/trail/4.55-CE-ubuntu24.04-r1.

