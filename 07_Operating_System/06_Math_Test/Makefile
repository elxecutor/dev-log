all: jack vm asm bin sim

jack:
	../../tools/JackCompiler/JackCompiler.pyc ./
vm:
	../../tools/VMTranslator/VMTranslator.pyc ./
asm:
	../../tools/Assembler/assembler.pyc out.asm
bin:
	../../tools/AsciiToBin.py out.hack
sim:
	cp out.hack ../00_HACK/ROM.hack
upload:
	iceprogduino -o 64k -w out.bin
clean:
	rm -f *.vm *.asm *.hack *.bin *~

.PHONY: all clean
