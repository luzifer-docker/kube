KUBERNETES_VERSION := v1.35.1
SOURCE_REGISTRY := registry.k8s.io
TARGET_REGISTRY := ghcr.io/luzifer-docker/kube
IMAGES := kube-apiserver kube-controller-manager kube-proxy kube-scheduler

.PHONY: default mirror FORCE

default: mirror

mirror: $(addprefix mirror-,$(IMAGES))

mirror-%: FORCE
	skopeo copy --all \
		docker://$(SOURCE_REGISTRY)/$*:$(KUBERNETES_VERSION) \
		docker://$(TARGET_REGISTRY)/$*:$(KUBERNETES_VERSION)

FORCE:
