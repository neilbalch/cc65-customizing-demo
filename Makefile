AS = ca65
ASFLAGS = --cpu 65sc02
CC = cc65
# Instruct cc65 to not make any assumptions about the target system (-t none)
# and specify the cc65 toolset processor 65SC02 (supports 65C02 extensions
# without bit manipulation instructions)
CFLAGS = -t none -O --cpu 65sc02 -I ./include
# https://stackoverflow.com/a/231418/3339274
VPATH = src asm

# Specify the sbc.cfg linker config file (-C) and create a memory map file (-m)
all: crt0.o main.o game_code.o rs232_tx.o interrupt.o vectors.o wait.o
	ld65 -C arcade.cfg -m build/main.map build/interrupt.o build/vectors.o \
				build/wait.o build/rs232_tx.o build/game_code.o build/main.o \
				build/sbc.lib -o build/6502

# Create the build directory... if it doesn't already exist. (since this is the
# first target to run)
# Adopt the cc65's stock "supervision.lib" (for the Watara Supervision) as the
# basis for a runtime library without console I/O, mouse, joystick, or other
# stock perhipherals that many 6502-based computers are connected to.
# Then, modify its startup code with the new version by compiling and archiving.
crt0.o:
	mkdir -p build/src
	cp /usr/share/cc65/lib/supervision.lib build/sbc.lib
	$(AS) asm/crt0.s -o build/crt0.o
	ar65 a build/sbc.lib build/crt0.o

# Have every C *.c file be compiled and assembled by an implicit rule
# (https://rebelsky.cs.grinnell.edu/musings/cnix-make-implicit-rules)
%.o: %.c
	$(CC) $(CFLAGS) $^ -o build/$^.s
	$(AS) $(ASFLAGS) build/$^.s -o build/$@

# Have every assembly *.s file be assembled by an implicit rule
# (https://rebelsky.cs.grinnell.edu/musings/cnix-make-implicit-rules)
%.o: %.s
	$(AS) $(ASFLAGS) $^ -o build/$@

.PHONY: clean
clean:
	# rm -rf build/*.o build/*.s build/a.out build/main.map
	rm -rf build/*
