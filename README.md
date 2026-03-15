# Kubernetes Image Mirror

This repository mirrors selected Kubernetes control plane images from `registry.k8s.io` to GitHub Container Registry.

The mirror exists so environments that cannot reliably pull from the upstream Kubernetes registry can use equivalent images from GHCR instead.

## Mirrored Images

For each Kubernetes version pinned in the `Makefile`, the following images are copied:

- `kube-apiserver`
- `kube-controller-manager`
- `kube-proxy`
- `kube-scheduler`

Images are published to:

- `ghcr.io/luzifer-docker/kube/kube-apiserver:<version>`
- `ghcr.io/luzifer-docker/kube/kube-controller-manager:<version>`
- `ghcr.io/luzifer-docker/kube/kube-proxy:<version>`
- `ghcr.io/luzifer-docker/kube/kube-scheduler:<version>`

## How It Works

The `Makefile` defines:

- the Kubernetes version to mirror
- the source registry
- the target registry
- the list of mirrored images

Running `make mirror` copies all configured images while preserving multi-architecture manifests via `skopeo copy --all`.

Individual images can also be mirrored with:

```bash
make mirror-kube-apiserver
```

## Automation

GitHub Actions runs the mirror workflow and publishes the configured images to GHCR.
