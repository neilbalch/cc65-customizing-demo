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

# List of files in the for_template directory to copy over, currently unused
# IN_TEMPLATE = dump.sh game_header.s game_header.txt game.c ${BUILD_DIR}/arcade.lib

# Path to a template cc65 linker library
SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

# Previx name for all flashable binary files
MACHINE = arcade

.PHONY: all clean

# By default (with no build target argument, i.e. `make`), build the template
# and set it up in a new directory
all: clean template

template: ${BUILD_DIR}/arcade.lib
	mkdir $@
	cp -r headers/ $@/headers/
	cp -r ${BUILD_DIR}/o/ $@/lib/
	cp -r ${BUILD_DIR}/arcade.lib $@
	cp -r arcade.cfg $@
	cp -r for_template/. $@


# Create the arcade machine libraries
${BUILD_DIR}/arcade.lib: ${BUILD_DIR}/ ${CXX_BIN} ${ASM_BIN} ${HEADERS}
	cp ${SUPERVISION_LIB} $@
#	ar65 r $@ \
#	    ${ASM_BIN} \
#	    ${CXX_BIN}


# Create build directory structure
${BUILD_DIR}/:
	mkdir -p ${BUILD_DIR}
	mkdir -p ${BUILD_DIR}/s
	mkdir -p ${BUILD_DIR}/o

# Compile .c source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.c
	$(CC) -I headers $(CFLAGS) $^ -o ${BUILD_DIR}/s/$(notdir $(^:.c=.s))
	$(AS) $(ASFLAGS) ${BUILD_DIR}/s/$(notdir $(^:.c=.s)) -o $@

# Compile .s source files
${BUILD_DIR}/o/${BIN_PREFIX}%.o: backend_src/%.s
	$(AS) $(ASFLAGS) $^ -o $@

# Purge all built files
clean:
	rm -rf build template
