NAME = boot

all: asm install

asm:
	../../tools/Assembler/assembler.pyc $(NAME).asm
install:
	cp $(NAME).hack ../00_HACK/ROM.hack
clean:
	rm -f *.hack *~

.PHONY: all clean
