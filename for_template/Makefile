# Instruct that compilation and assembly should be done using cc65/ca65 and
# specify some required flags (https://cc65.github.io/doc/customizing.html#toc9)
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O

# Where the intermediate-stage Assembly/object files will be saved
BUILD_DIR = build

# Define a list of all C and Assemnbly source files, as well as the location to
# save the assembled object files
CXX_SRC = game.c
CXX_BIN = $(addprefix ${BUILD_DIR}/,$(CXX_SRC:.c=.o))

ASM_SRC = game_header.s
ASM_BIN = $(addprefix ${BUILD_DIR}/,$(ASM_SRC:.s=.o))

LIB_FILES = $(shell find lib/*)

# Previx name for all flashable binary files
MACHINE = arcade

# Where the flashable binaries will be saved
MEMORY_DIR = ${BUILD_DIR}/memory

DUMP_DIR = dump

# Where the conjoined memory map will be saved (union of all flashable binaries)
OUTPUT = ${DUMP_DIR}/${MACHINE}.bin

.PHONY: all clean

# By default (with no build target argument, i.e. `make`), build everything and
# run the py65 simulator
all: clean dump

# Split the unified memory map into constituent memory sections
dump: ${OUTPUT}
	./dump.sh dump

# Run the simulator
run: ${OUTPUT}
	./dump.sh run

# Hack together the three binaries output by ld65 into one unified memory map
# understandable by the py65 simulator
${OUTPUT}: ${MEMORY_DIR}/ ${DUMP_DIR}/
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=16384 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_fw.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=28672 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_io.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=32768 status=none
	@cat ${MEMORY_DIR}/${MACHINE}_rom.bin >> $@
	@dd if=/dev/zero of=$@ bs=1 count=0 seek=65536 status=none
	@echo "Created $@"

# Build the three different binaries (ROM, FPGA ROM, IO area)
${MEMORY_DIR}/: ${BUILD_DIR}/ ${CXX_BIN} ${ASM_BIN} ${HEADERS}
	mkdir -p ${MEMORY_DIR}
	ld65 -C ${MACHINE}.cfg -m ${BUILD_DIR}/build.map \
	    ${ASM_BIN} \
	    ${CXX_BIN} \
	    ${LIB_FILES} \
	    arcade.lib \
	    -o ${MACHINE}

# Create the build directory
${BUILD_DIR}/:
	mkdir ${BUILD_DIR}/

${DUMP_DIR}/:
	mkdir ${DUMP_DIR}

# Override the default/implicit *.c compilation rule to use the cc65/ca65 syntax
${BUILD_DIR}/%.o: %.c
	$(CC) -I headers $(CFLAGS) $^ -o ${BUILD_DIR}/$(^:.c=.s)
	$(AS) $(ASFLAGS) ${BUILD_DIR}/$(^:.c=.s) -o $@

# Override the default/implicit *.s assembly rule to use the ca65 syntax
${BUILD_DIR}/%.o: %.s
	$(AS) $(ASFLAGS) $^ -o $@

# Purge all built files
clean:
	rm -rf ${BUILD_DIR}/ ${OUTPUT} dump/
