AS = ca65
ASFLAGS = --cpu 65sc02
CC = cc65
# Instruct cc65 to not make any assumptions about the target system (-t none)
# and specify the cc65 toolset processor 65SC02 (supports 65C02 extensions
# without bit manipulation instructions)
CFLAGS = -t none -O --cpu 65sc02

# Specify the sbc.cfg linker config file (-C) and create a memory map file (-m)
all: crt0.o main.o rs232_tx.o interrupt.o vectors.o wait.o
	ld65 -C sbc.cfg -m build/main.map build/interrupt.o build/vectors.o \
				build/wait.o build/rs232_tx.o build/main.o build/sbc.lib -o build/a.out

# Adopt the cc65's stock "supervision.lib" (for the Watara Supervision) as the
# basis for a runtime library without console I/O, mouse, joystick, or other
# stock perhipherals that many 6502-based computers are connected to.
# Then, modify its startup code with the new version by compiling and archiving.
crt0.o:
	cp /usr/share/cc65/lib/supervision.lib build/sbc.lib
	$(AS) crt0.s -o build/crt0.o
	ar65 a build/sbc.lib build/crt0.o

main.o:
	$(CC) $(CFLAGS) main.c -o build/main.s
	$(AS) $(ASFLAGS) build/main.s -o build/main.o

# Have every other/normal assembly *.s file be assembled by an implicit rule
# (https://rebelsky.cs.grinnell.edu/musings/cnix-make-implicit-rules)
%.o: %.s
	$(AS) $(ASFLAGS) $^ -o build/$@

.PHONY: clean
clean:
	# rm -rf build/*.o build/*.s build/a.out build/main.map
	rm -rf build/*
