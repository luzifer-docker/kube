#!/usr/bin/env bash

set -euo pipefail

source_registry="${1:?missing source registry}"
target_registry="${2:?missing target registry}"
image_file="${3:?missing image file}"
skopeo_cmd="${SKOPEO_BIN:-skopeo}"

if [[ ! -f "${image_file}" ]]; then
  echo "image list not found: ${image_file}" >&2
  exit 1
fi

mirror_image() {
  local image_ref="$1"
  local image_name="${image_ref%:*}"
  local image_tag="${image_ref##*:}"
  local target_name="${image_name#${source_registry}/}"
  local target_ref="docker://${target_registry}/${target_name}:${image_tag}"
  local source_ref="docker://${image_name}:${image_tag}"
  local inspect_output

  if inspect_output="$("${skopeo_cmd}" inspect "${target_ref}" 2>&1)"; then
    echo "Skipping ${target_ref}: already present"
    return 0
  fi

  if [[ "${inspect_output}" != *"manifest unknown"* ]] && [[ "${inspect_output}" != *"name unknown"* ]]; then
    echo "Failed to inspect ${target_ref}" >&2
    echo "${inspect_output}" >&2
    exit 1
  fi

  echo "Mirroring ${source_ref} -> ${target_ref}"
  "${skopeo_cmd}" copy --all "${source_ref}" "${target_ref}"
}

while IFS= read -r image_ref; do
  [[ -z "${image_ref}" || "${image_ref}" == \#* ]] && continue
  mirror_image "${image_ref}"
done < "${image_file}"
