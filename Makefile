
all: icezero.bin

prog: icezero.bin
	icezprog icezero.bin

reset: icezprog
	icezprog .

icezero.blif: icezero.v
	yosys -p 'synth_ice40 -top top -blif icezero.blif' icezero.v

icezero.asc: icezero.blif icezero.pcf
	arachne-pnr -d 8k -P tq144:4k -p icezero.pcf -o icezero.asc icezero.blif

icezero.bin: icezero.asc
	icetime -d hx8k -c 100 icezero.asc
	icepack icezero.asc icezero.bin

testbench: testbench.v icezero.v
	iverilog -o testbench testbench.v icezero.v  $(shell yosys-config --datdir/ice40/cells_sim.v)

testbench.vcd: testbench
	./testbench

clean:
	rm -f testbench testbench.vcd
	rm -f icezero.blif icezero.asc icezero.bin

.PHONY: all prog reset clean

