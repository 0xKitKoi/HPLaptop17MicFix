#!/bin/bash

PATCH="$(dirname "$0")/../patches/0001-ASoC-amd-yc-add-HP-8DC5-ACP6x-DMIC-quirk.patch"

echo "Apply inside a Linux kernel source tree."

git apply --check "$PATCH" || exit 1
git apply "$PATCH"

echo "Patch applied successfully."
