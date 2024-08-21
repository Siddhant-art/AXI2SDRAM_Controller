##To compile file
vsim -voptargs=+acc -L design -coverage tb_top.tb_top -logfile run.log +UVM_TESTNAME=AXI_Burst_Read_after_Write_Test



##run the file till 10ms
run        10000 ns

##coverage report file generation 
coverage report -html -htmldir covhtmlreport -source -details -assert -directive -cvg -code bcefst -threshL 50 -threshH 90

##exit(stop) the simulation
exit
