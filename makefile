# directorios
MAIN_DIR = ./main
SRC_DIR = ./source
CMP_DIR = ./components
TB_DIR  = ./testbench

# archivos
MAIN_FILE = control_lectura
TB_FILE = $(MAIN_FILE)_tb
VCD_FILE = $(TB_FILE).ghw

# extensiones
EXT = .vhd


# ghdl config
TIME = 50ms
GHDL_SIM_TIME = --stop-time=$(TIME)
COMPILATION_VERSION = 08	#2008 standard de VHDL
COMPILATION = --std=$(COMPILATION_VERSION)


.DEFAULT_GOAL := make



make: compile execute run

all: compile execute run view

compile:
	ghdl -a $(COMPILATION) $(CMP_DIR)/*.vhd
	ghdl -a $(COMPILATION) $(SRC_DIR)/*.vhd
	ghdl -a $(COMPILATION) $(MAIN_DIR)/*.vhd
	ghdl -a $(COMPILATION) $(TB_DIR)/*.vhd

# order: cmp -> src -> main -> tb	
backup:
	
	
	
execute:
	ghdl -e $(COMPILATION) $(TB_FILE)

run:
	ghdl -r $(COMPILATION) $(TB_FILE) $(GHDL_SIM_TIME) --wave=$(MAIN_FILE)_tb.ghw

view:
	gtkwave $(VCD_FILE)

ghw:
	touch tmp.ghw

#se podria agregar instruccion para entrar a vcd directamente
clean:
	rm *.vcd
	rm work-obj08.cf
