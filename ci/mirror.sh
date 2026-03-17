#!/usr/bin/env bash

set -euo pipefail

source_registry="${1:?missing source registry}"
target_registry="${2:?missing target registry}"
image_file="${3:?missing image file}"

if [[ ! -f "${image_file}" ]]; then
  echo "image list not found: ${image_file}" >&2
  exit 1
fi

mirror_image() {
  local image_ref="$1"
  local image_name="${image_ref%:*}"
  local image_tag="${image_ref##*:}"
  local target_name="${image_name#${source_registry}/}"

  skopeo copy --all \
    "docker://${image_name}:${image_tag}" \
    "docker://${target_registry}/${target_name}:${image_tag}"
}

while IFS= read -r image_ref; do
  [[ -z "${image_ref}" || "${image_ref}" == \#* ]] && continue
  mirror_image "${image_ref}"
done < "${image_file}"
