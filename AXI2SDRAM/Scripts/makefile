##makefile

compile:
	vlog -work design -vopt -sv  -stats=none ../Design/sdram_sim_model/mt48lc16m16a2.v
	vlog -work design -vopt -sv  +cover=sbceft1 -stats=none ../Design/AXI2SDRAM_Wrapper/AXI2SDRAM_Top.sv
	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/TB/tb_top.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Interface.sv		
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Packet.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Sequence.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Sequencer.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Driver.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Monitor.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/AXI/AXI_Agent.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Interface.sv		
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Packet.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Sequence.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Sequencer.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Driver.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Monitor.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/SDRAM/SDRAM_Agent.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/TB/AXI_SDRAM_Scoreboard.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/TB/AXI_SDRAM_Coverage.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/TB/AXI2SDRAM_Environment.sv
# 	vlog -work tb_top -vopt -sv  +cover=sbceft1 -stats=none ../DV/TB/AXI_SDRAM_Test.sv

	

simulate:
	vsim -c -do run.do -logfile run.log

covreport:
	firefox ./covhtmlreport/index.html &

waveform:
	gtkwave waveform.vcd

wave1form:
	gtkwave.exe waveform.vcd

clean:
	rm -r design tb_top
	reset

remove: 
	rmdir /s /q design
	rmdir /s /q tb_top


all:
	make clean
	make compile
	make simulate
	make covreport
	make waveform

run_win:
	make remove
	make compile
	make simulate
	make wave1form
