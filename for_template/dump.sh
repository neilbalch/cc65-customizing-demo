#!/usr/bin/env bash

objective=

if [ "$1" = "run" ]; then # Simulate then give the outputed memory as bin files
    objective=run
elif [ "$1" = "dump" ]; then # Split the binary into usable bin files
    objective=dump
else
    >&2 echo "[Argument Error]: Valid argument not given."
    exit 1
fi

ASSEMBLY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DUMP_DIR=dump
PY65=py65mon

mkdir -p ${DUMP_DIR}

# Ensure py65ucsbieee is installed
${PY65} -h > /dev/null 2>&1 || {
    echo "[ERROR]: Could not run \$${PY65}.
Please install it from ${ASSEMBLY_SRC_DIR}/tools/py65/py65ucsbieee.";
    exit 1
}

# Make sure that dump folder is ${ASSEMBLY_SRC_DIR}/dump
cd `dirname "${BASH_SOURCE[0]}"`

# Dump Vectors
${PY65} --mpu 65C02 --load ${DUMP_DIR}/arcade.bin <<EOF
save ${DUMP_DIR}/rom.bin       8000 ffff
save ${DUMP_DIR}/firmware.bin  4000 6fff
save ${DUMP_DIR}/vectors.bin   fffa ffff
quit
EOF

# Stop if objective was completed
if [ "$objective" = "dump" ]; then
    exit 0
fi

# Get Addreses for Interrupt/Reset Vectors
vectors="${DUMP_DIR}/vectors.bin"
nmi=`   xxd -p -l 1 -seek 1 ${vectors}``xxd -p -l 1 -seek 0 ${vectors}`
reset=` xxd -p -l 1 -seek 3 ${vectors}``xxd -p -l 1 -seek 2 ${vectors}`
irq=`   xxd -p -l 1 -seek 5 ${vectors}``xxd -p -l 1 -seek 4 ${vectors}`
echo "nmi   : ${nmi}"
echo "reset : ${reset}"
echo "irq   : ${irq}"

# Run py65mon
${PY65} --mpu 65C02 --load ${DUMP_DIR}/arcade.bin --goto ${reset} <<EOF
save ${DUMP_DIR}/zero.bin      0000 00ff
save ${DUMP_DIR}/vram.bin      3700 3fff
save ${DUMP_DIR}/ram.bin       0000 3fff
save ${DUMP_DIR}/final.bin     0000 ffff
quit
EOF
