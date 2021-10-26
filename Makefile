ASM = ca65 --cpu 65sc02

all: crt0 main rs232_tx interrupt vectors wait
	ld65 -C sbc.cfg -m build/main.map build/interrupt.o build/vectors.o \
				build/wait.o build/rs232_tx.o build/main.o build/sbc.lib -o build/a.out

crt0:
	cp /usr/share/cc65/lib/supervision.lib build/sbc.lib
	ca65 crt0.s -o build/crt0.o
	ar65 a build/sbc.lib build/crt0.o

main:
	cc65 -t none -O --cpu 65sc02 main.c -o build/main.s
	$(ASM) build/main.s -o build/main.o

rs232_tx:
	$(ASM) rs232_tx.s -o build/rs232_tx.o

interrupt:
	$(ASM) interrupt.s -o build/interrupt.o

vectors:
	$(ASM) vectors.s -o build/vectors.o

wait:
	$(ASM) wait.s -o build/wait.o

.PHONY: clean
clean:
	# rm -rf build/*.o build/*.s build/a.out build/main.map
	rm -rf build/*
