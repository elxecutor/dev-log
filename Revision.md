# Revision V2.0

## update 18.10.2022

### correct typos:
* `Hack/CPU.v`: Replace `loadM` with `writeM`
* update diagramms

### update tools to python3.10:
* `tools/Assembler/assembler.pyc`: update tools to python 3.10
* `tools/Jack/JackCompiler.pyc`: update tools to python 3.10
* `tools/Jack/VMTranslator.pyc`: update tools to python 3.10

### update Jack-OS:
* `Jack/UART.jack`: replace `init()` with `init(int addr)`

### wierd behaviour of iCE40HX8K-EVB:

* `Hack/RAM.v`: replace `always @(negedge clk)` to `always @(posedge clk)`
* `Hack/DFF.v`: replace `always @(negedge clk)` to `always @(posedge clk)`
* `Hack/Clock.v`: 25MHz?

### iceprog: programmer.ino
* set default to `bridge` (led green on).

### consistency:
* `Hack/Reset.v`:

### boot from spi
* 04_Hack-FLASH
