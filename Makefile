AS = ca65
ASFLAGS = --cpu 65c02

CC = cc65
CFLAGS = --cpu 65c02 -t none -O

BUILD_DIR = build

BIN_PREFIX =

CXX_SRC = vram.c verify_firmware.c
CXX_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(CXX_SRC:.c=.o))

ASM_SRC = crt0.s vectors.s io.s fw_headers.s stop.s arcade_zero_page.s
ASM_BIN = $(addprefix ${BUILD_DIR}/o/${BIN_PREFIX},$(ASM_SRC:.s=.o))

IN_TEMPLATE = dump.sh game_header.s game_header.txt game.c ${BUILD_DIR}/arcade.lib

SUPERVISION_LIB = /usr/share/cc65/lib/supervision.lib

MACHINE = arcade

.PHONY: all clean

all: clean template

template: ${BUILD_DIR}/arcade.lib
	mkdir $@
	cp -r headers/ $@/headers/
	cp -r ${BUILD_DIR}/o/ $@/lib/
	cp -r ${BUILD_DIR}/arcade.lib $@
	cp -r arcade.cfg $@
	cp -r for_template/. $@


${BUILD_DIR}/arcade.lib: ${BUILD_DIR}/ ${CXX_BIN} ${ASM_BIN} ${HEADERS}
	cp ${SUPERVISION_LIB} $@
#	ar65 r $@ \
#	    ${ASM_BIN} \
#	    ${CXX_BIN}


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


clean:
	rm -rf build template
