PROJ = blinky
PIN_DEF = icezero.pcf

DEVICE = hx8k
PACKAGE = tq144:4k

all: $(PROJ).bin

%.blif: %.v
	yosys -p 'synth_ice40 -top top -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^ -P $(PACKAGE)

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%.prog: %.bin
	icezprog  $<

clean:
	rm -f *.blif *.asc *.rpt *.bin

.PHONY: all %.prog clean
