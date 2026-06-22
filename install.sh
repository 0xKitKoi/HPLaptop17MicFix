#!/bin/bash
set -e

KVER=$(uname -r)
KSRC=$(uname -r | cut -d- -f1)

WORKDIR=$(mktemp -d)

cd "$WORKDIR"

tar -xf /usr/src/linux-source-${KSRC}.tar.bz2 \
    --wildcards "*/sound/soc/amd/yc/*" \
    --strip-components=1

patch -p0 < ~/HPLaptop17MicFix/hp-mic-fix.patch

cd sound/soc/amd/yc

make -C /lib/modules/${KVER}/build M=$(pwd) modules
