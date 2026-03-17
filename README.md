# Kubernetes Image Mirror

This repository mirrors selected Kubernetes images from `registry.k8s.io` to GitHub Container Registry.

The mirror exists so environments that cannot reliably pull from the upstream Kubernetes registry can use equivalent images from GHCR instead.

## Mirrored Images

The mirrored image list lives in [`images.txt`](images.txt). Each entry pins a full upstream image reference and is updated independently by Renovate.

Images are rewritten by preserving the path below `registry.k8s.io` and replacing the registry prefix:

```text
registry.k8s.io/<image>:<tag>
-> ghcr.io/luzifer-docker/kube/<image>:<tag>
```

Examples:

- `registry.k8s.io/kube-apiserver:v1.35.2` -> `ghcr.io/luzifer-docker/kube/kube-apiserver:v1.35.2`
- `registry.k8s.io/ingress-nginx/controller:v1.13.4` -> `ghcr.io/luzifer-docker/kube/ingress-nginx/controller:v1.13.4`
- `registry.k8s.io/sig-storage/csi-provisioner:v5.3.0` -> `ghcr.io/luzifer-docker/kube/sig-storage/csi-provisioner:v5.3.0`

## How It Works

The `Makefile` defines:

- the source registry
- the target registry
- the image list file passed to [`ci/mirror.sh`](ci/mirror.sh)

The shell script reads `images.txt`, preserves the upstream path layout below `registry.k8s.io`, and mirrors each pinned image to GHCR.

Running `make mirror` copies all configured images while preserving multi-architecture manifests via `skopeo copy --all`.

The main entrypoint remains:

```bash
make mirror
```

## Automation

GitHub Actions runs the mirror workflow and publishes the configured images to GHCR. Renovate watches [`images.txt`](images.txt) and opens PRs when upstream image tags change.
