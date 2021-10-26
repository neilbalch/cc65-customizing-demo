AS = ca65
ASFLAGS = --cpu 65sc02
CC = cc65
CFLAGS = -t none -O --cpu 65sc02

all: crt0.o main.o rs232_tx.o interrupt.o vectors.o wait.o
	ld65 -C sbc.cfg -m build/main.map build/interrupt.o build/vectors.o \
				build/wait.o build/rs232_tx.o build/main.o build/sbc.lib -o build/a.out

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
