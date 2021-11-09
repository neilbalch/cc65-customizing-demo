# Instruct that compilation and assembly should be done using cc65/ca65 and
# specify some required flags (https://cc65.github.io/doc/customizing.html#toc9)
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O

# Where the intermediate-stage Assembly/object files will be saved
BUILD_DIR = build

# List of all C and Assemnbly source files, as well as the location to
# save the assembled object files
CXX_SRC = game.c vram.c verify_firmware.c
CXX_BIN = $(addprefix ${BUILD_DIR}/,$(CXX_SRC:.c=.o))

ASM_SRC = interrupts.s vectors.s fake_io.s headers.s stop.s cc65.s zero_page.s
ASM_BIN = $(addprefix ${BUILD_DIR}/,$(ASM_SRC:.s=.o))

# List of header files
HEADERS = macros.h.s vram.h int.h stop.h zero_page.h

# Path to a template cc65 linker library
SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

# Previx name for all flashable binary files
MACHINE = arcade

# Where the flashable binaries will be saved
MEMORY_DIR = ${BUILD_DIR}/memory
# Where the conjoined memory map will be saved (union of all flashable binaries)
OUTPUT = ${MACHINE}.bin

.PHONY: all clean

# By default (with no build target argument, i.e. `make`), build everything and
# run the py65 simulator
all: clean ${OUTPUT}
	./dump.sh run

# Hack together the three binaries output by ld65 into one unified memory map
# understandable by the py65 simulator
${OUTPUT}: ${MEMORY_DIR}/
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=16383 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_fw.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=28671 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_io.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=32767 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_rom.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=1 seek=65535 status=none
	@echo "Created $@"

# Link the object files to create memory files
${MEMORY_DIR}/: ${BUILD_DIR}/ ${CXX_BIN} ${ASM_BIN} ${HEADERS}
	mkdir ${MEMORY_DIR}
	ld65 -C ${MACHINE}.cfg -m ${BUILD_DIR}/build.map \
	    ${CXX_BIN} \
	    ${ASM_BIN} \
	    ${SUPERVISION_LIB} \
	    -o ${MACHINE}

# Create the build directory
${BUILD_DIR}/:
	mkdir ${BUILD_DIR}/

# Compile .c source files
${BUILD_DIR}/%.o: %.c
	$(CC) $(CFLAGS) $^ -o ${BUILD_DIR}/$(^:.c=.s)
	$(AS) $(ASFLAGS) ${BUILD_DIR}/$(^:.c=.s) -o $@

# Compile .s source files
${BUILD_DIR}/%.o: %.s
	$(AS) $(ASFLAGS) $^ -o $@

# Purge all built files
clean:
	rm -rf ${BUILD_DIR}/ ${OUTPUT} dump/
