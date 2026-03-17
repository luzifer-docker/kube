SOURCE_REGISTRY := registry.k8s.io
TARGET_REGISTRY := ghcr.io/luzifer-docker/kube
IMAGE_FILE := images.txt

.PHONY: default mirror

default: mirror

mirror:
	./ci/mirror.sh "$(SOURCE_REGISTRY)" "$(TARGET_REGISTRY)" "$(IMAGE_FILE)"
