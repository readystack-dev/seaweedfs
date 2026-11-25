# SeaweedFS: ReadyStack build kit

The offline build kit for the Docker image `readystack/seaweedfs:4.55-CE-ubuntu24.04-r1`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [4.55-CE-ubuntu24.04-r1](https://github.com/readystack-dev/seaweedfs/releases/tag/4.55-CE-ubuntu24.04-r1)
- Image: [`docker.io/readystack/seaweedfs:4.55-CE-ubuntu24.04-r1`](https://hub.docker.com/r/readystack/seaweedfs/tags), manifest digest `sha256:77407a338231feadb17d0bf6dfe43d9ece008f39e711109567a9d85014f0c5d8`
- Product page: https://readystack.dev/products/seaweedfs
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=seaweedfs

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

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/seaweedfs/recipe. The complete kit is the release download. Each release is a tag here.
