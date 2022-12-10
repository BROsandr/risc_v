RTL = ../rtl/*

TB_MODULE = tb_io

TB  = ../sim/$(TB_MODULE).sv 

VLOG_OPTS = -vopt -sv -stats=none
VSIM_OPTS = -vopt -voptargs=+acc

USER_OPTS=
ifdef RUN_SCRIPT
USER_OPTS+=-do $(RUN_SCRIPT)
endif
ifndef GUI
USER_OPTS+=-c
endif

all: compile sim

compile:
		vlog -lint -work work $(VLOG_OPTS) $(RTL)
		vlog -lint -work work $(VLOG_OPTS) $(TB)

# run simulator in GUI mode 
sim:
		vsim $(VSIM_OPTS) work.$(TB_MODULE) $(USER_OPTS)

clean:
		rm -rf work 
		rm transcript
