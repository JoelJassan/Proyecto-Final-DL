# directorios
MAIN_DIR = ./main
SRC_DIR = ./source
CMP_DIR = ./components
TB_DIR  = ./testbench

# archivos
MAIN_FILE = tx_uart
TB_FILE = $(MAIN_FILE)_tb
VCD_FILE = $(TB_FILE).vcd

# extensiones
EXT = .vhd


# ghdl config
TIME = 2ms
GHDL_SIM_TIME = --stop-time=$(TIME)
COMPILATION_VERSION = 08	#2008 standard de VHDL
COMPILATION = --std=$(COMPILATION_VERSION)


.DEFAULT_GOAL := make



make: compile execute run

all: compile execute run view

compile:
	ghdl -a $(COMPILATION) $(CMP_DIR)/*.vhd
	ghdl -a $(COMPILATION) $(SRC_DIR)/*.vhd
	
	ghdl -a $(COMPILATION) $(TB_DIR)/*.vhd

# order: cmp -> src -> main -> tb	
backup:
	ghdl -a $(COMPILATION) $(MAIN_DIR)/*.vhd
	
	
execute:
	ghdl -e $(COMPILATION) $(TB_FILE)

run:
	ghdl -r $(COMPILATION) $(TB_FILE) $(GHDL_SIM_TIME) --vcd=$(MAIN_FILE)_tb.vcd

view:
	gtkwave $(VCD_FILE)

vcd:
	touch tmp.vcd

clean: 
	rm *.vcd
	rm work-obj08.cf
