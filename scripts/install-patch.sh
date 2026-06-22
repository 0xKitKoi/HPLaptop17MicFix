#!/usr/bin/env bash
set -euo pipefail

echo "=== HP ACP6x DMIC Fix Installer ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATCH_FILE="$REPO_ROOT/patches/0001-ASoC-amd-yc-add-HP-8DC5-ACP6x-DMIC-quirk.patch"

KVER="$(uname -r)"
KBUILD="/lib/modules/$KVER/build"

echo "[1/5] Checking system..."

BOARD="$(sudo dmidecode -s baseboard-product-name 2>/dev/null || true)"
echo "[+] Board detected: $BOARD"

if [[ "$BOARD" != "8DC5" ]]; then
    echo "[!] Unsupported hardware (expected 8DC5)"
    exit 1
fi

echo "[2/5] Checking audio runtime state..."

if arecord -l 2>/dev/null | grep -qi "acp6x"; then
    echo "[+] ACP6x DMIC already present in ALSA"
    echo "[+] Nothing to do"
    exit 0
fi

echo "[!] DMIC not detected in ALSA — patch may be needed"

echo "[3/5] Checking kernel build environment..."

if [[ ! -d "$KBUILD" ]]; then
    echo "[!] Kernel build environment missing:"
    echo "    $KBUILD"
    echo ""
    echo "Install headers:"
    echo "    sudo apt install linux-headers-$KVER"
    exit 1
fi

echo "[+] Kernel build dir: $KBUILD"

echo "[4/5] Locating patch target..."

TARGET_FILE="sound/soc/amd/yc/acp6x-mach.c"

if [[ -f "$KBUILD/$TARGET_FILE" ]]; then
    echo "[+] Found target in kernel headers tree"
else
    echo "[!] Target not found in build tree"
    echo "    This is normal on some Ubuntu header packages"
    echo "    Falling back to runtime detection only"
    echo ""
    echo "If your mic is not working, you need full kernel source rebuild."
    exit 1
fi

cd "$KBUILD"

echo "[5/5] Determining patch state..."

# Check if already applied via runtime behavior
if arecord -l | grep -qi "acp6x"; then
    echo "[+] System already shows ACP6x device"
    echo "[+] Assuming patch already applied"
    exit 0
fi

echo "[*] Patch file: $PATCH_FILE"

if [[ ! -f "$PATCH_FILE" ]]; then
    echo "[!] Missing patch:"
    echo "$PATCH_FILE"
    exit 1
fi

echo "[*] Testing patch apply (dry-run)..."

if patch -p1 --dry-run < "$PATCH_FILE" >/dev/null 2>&1; then
    echo "[+] Patch applies cleanly"
    patch -p1 < "$PATCH_FILE"
else
    echo "[!] Patch does not apply cleanly"
    echo "    Likely reasons:"
    echo "    - already partially applied"
    echo "    - kernel headers mismatch"
    echo ""
    echo "[*] Checking if patch is already effectively applied..."

    if grep -q "8DC5" "$KBUILD/$TARGET_FILE" 2>/dev/null; then
        echo "[!] DMI entry already present"
        echo "[!] Treating as already installed"
        exit 0
    fi

    echo "[!] Cannot safely apply patch"
    exit 1
fi

echo "[*] Updating initramfs..."
sudo update-initramfs -u >/dev/null 2>&1 || true

echo ""
echo "Install complete"
echo "Reboot recommended"
echo ""
echo "Verify after reboot:"
echo "  arecord -l"
echo "  dmesg | grep -i acp"
