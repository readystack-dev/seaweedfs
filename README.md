[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fseaweedfs-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/seaweedfs) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/seaweedfs)](https://hub.docker.com/r/readystack/seaweedfs) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/seaweedfs) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# SeaweedFS: ReadyStack build kit

The offline build kit for the Docker image `readystack/seaweedfs:4.55-CE-ubuntu24.04-r1`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [4.55-CE-ubuntu24.04-r1](https://github.com/readystack-dev/seaweedfs/releases/tag/4.55-CE-ubuntu24.04-r1)
- Image: [`docker.io/readystack/seaweedfs:4.55-CE-ubuntu24.04-r1`](https://hub.docker.com/r/readystack/seaweedfs/tags), manifest digest `sha256:77407a338231feadb17d0bf6dfe43d9ece008f39e711109567a9d85014f0c5d8`
- Product page: https://readystack.dev/products/seaweedfs
- Source and build recipe: https://readystack.dev/products/seaweedfs/recipe
- Build trail: https://readystack.dev/products/seaweedfs/trail/4.55-CE-ubuntu24.04-r1
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=seaweedfs

## The image

Single container, single static Go binary (weed, CGO-free), foreground `weed server -s3`. Master+volume+filer+S3 in one process: the S3 API on :8333 is the one port meant for clients; the filer, master and volume server listen on the container's loopback interface only (see Ports in the handbooks). Object storage — data + metadata under /data. NO SQL DB, NO sidecar (production scales master/volume/filer as separate roles; this image is the single-node S3 endpoint).

## Who uses SeaweedFS and why

Teams who need to store very large numbers of files, for applications, backups or analytics, on their own servers.

SeaweedFS is a simple, highly scalable distributed storage system. One server program offers an object store, a POSIX file system and table storage over the same data, and capacity grows by adding volume servers.

A typical use: A photo-sharing service stores huge numbers of small images that a single file server can no longer handle. SeaweedFS packs them into volumes spread across servers, reads each one with a single disk read, and grows by starting another volume server when space runs low.

From the upstream project's own description: https://github.com/seaweedfs/seaweedfs.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 11 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`seaweedfs`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/seaweedfs.

SeaweedFS is distributed under its upstream licence (Apache-2.0); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [4.55-CE-ubuntu24.04-r1 release](https://github.com/readystack-dev/seaweedfs/releases/tag/4.55-CE-ubuntu24.04-r1): `ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.tar.gz` (651.7 MB), SHA-256 `1b34a976af699c874d698bc5e2a47508faaba19e4e4119dc49935edc8178bd6f`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.rebuild.json.sigstore ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.tar.gz
cd 4.55-CE-ubuntu24.04-r1
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-seaweedfs-4.55-CE-ubuntu24.04-r1.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/seaweedfs/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
