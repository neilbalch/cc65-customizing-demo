
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O


BUILD_DIR = build

CXX_SRC = game.c vram.c verify_firmware.c
CXX_BIN = $(addprefix ${BUILD_DIR}/,$(CXX_SRC:.c=.o))

ASM_SRC = interrupts.s vectors.s fake_io.s headers.s stop.s cc65.s zero_page.s
ASM_BIN = $(addprefix ${BUILD_DIR}/,$(ASM_SRC:.s=.o))

HEADERS = macros.h.s vram.h int.h stop.h zero_page.h

SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

MACHINE = arcade

MEMORY_DIR = ${BUILD_DIR}/memory

OUTPUT = ${MACHINE}.bin

.PHONY: all clean

all: clean ${OUTPUT}
	./dump.sh run

${OUTPUT}: ${MEMORY_DIR}/
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=16383 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_fw.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=28671 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_io.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=32767 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_rom.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=65535 status=none
	@echo "Created $@"


${MEMORY_DIR}/: ${BUILD_DIR}/ ${CXX_BIN} ${ASM_BIN} ${HEADERS}
	mkdir ${MEMORY_DIR}
	ld65 -C ${MACHINE}.cfg -m ${BUILD_DIR}/build.map \
	    ${CXX_BIN} \
	    ${ASM_BIN} \
	    ${SUPERVISION_LIB} \
	    -o ${MACHINE}

${BUILD_DIR}/:
	mkdir ${BUILD_DIR}/

${BUILD_DIR}/%.o: %.c
	$(CC) $(CFLAGS) $^ -o ${BUILD_DIR}/$(^:.c=.s)
	$(AS) $(ASFLAGS) ${BUILD_DIR}/$(^:.c=.s) -o $@

${BUILD_DIR}/%.o: %.s
	$(AS) $(ASFLAGS) $^ -o $@

clean:
	rm -rf ${BUILD_DIR}/ ${OUTPUT} dump/
