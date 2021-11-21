# Instruct that compilation and assembly should be done using cc65/ca65 and
# specify some required flags (https://cc65.github.io/doc/customizing.html#toc9)
AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O

# Where the intermediate-stage Assembly/object files will be saved
BUILD_DIR = build

# Unknown usage
BIN_PREFIX =

# Define a list of all C and Assemnbly source files, as well as the location to
# save the assembled object files
CXX_SRC = vram.c Q9_6.c
CXX_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(CXX_SRC:.c=.o))

ASM_SRC = crt0.s vectors.s io.s fw_headers.s stop.s arcade_zero_page.s reset.s verify_firmware.s
ASM_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(ASM_SRC:.s=.o))

# List of files in the for_template directory
FOR_TEMPLATE_FILES_IN = $(shell find for_template -type f)
FOR_TEMPLATE_FILES_OUT = $(addprefix template/,$(notdir $(FOR_TEMPLATE_FILES_IN)))

# Path to a template cc65 linker library
SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

# Previx name for all flashable binary files
MACHINE = arcade

.PHONY: all game_template clean

# By default (with no build target argument, i.e. `make`), build the template
# and set it up in a new directory
all: clean game_template

game_template: template/ ${FOR_TEMPLATE_FILES_OUT} template/headers/ template/arcade.lib template/arcade.cfg template/firmware.bin

template/:
	mkdir -p $@

${FOR_TEMPLATE_FILES_OUT}: template/ ${FOR_TEMPLATE_FILES_IN}
	cp -r for_template/. template/

template/headers/: template/ $(shell find headers -type f)
	cp -r headers/ $@

template/lib/: template/ ${CXX_BIN} ${ASM_BIN}
	cp -r ${BUILD_DIR}/o/ $@

template/arcade.lib: template/ ${BUILD_DIR}/arcade.lib
	cp -r ${BUILD_DIR}/arcade.lib $@

template/arcade.cfg: template/ arcade.cfg
	cp -r arcade.cfg $@

template/firmware.bin: template/ ${FOR_TEMPLATE_FILES_OUT} template/headers/ template/lib/ template/arcade.lib template/arcade.cfg
	make -C template/ dump
	cp template/dump/firmware.bin $@
	make -C template/ clean


# Create the arcade machine libraries
${BUILD_DIR}/arcade.lib: ${BUILD_DIR}/
	cp ${SUPERVISION_LIB} $@


# Create build directory structure
${BUILD_DIR}/:
	mkdir -p ${BUILD_DIR}
	mkdir -p ${BUILD_DIR}/s
	mkdir -p ${BUILD_DIR}/o

# Compile .c source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.c $(shell find headers -type f)
	$(CC) -I headers $(CFLAGS) $< -o ${BUILD_DIR}/s/$(notdir $(<:.c=.s))
	$(AS) $(ASFLAGS) ${BUILD_DIR}/s/$(notdir $(<:.c=.s)) -o $@

# Compile .s source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.s
	$(AS) $(ASFLAGS) $^ -o $@

# Purge all built files
clean:
	rm -rf build template
