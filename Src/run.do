vlib work
vlog FIFO_if.sv FIFO.sv FIFO_shared_pkg.sv FIFO_transaction_pkg.sv FIFO_coverage_pkg.sv  FIFO_scoreboard_pkg.sv FIFO_tb.sv FIFO_monitor.sv FIFO_top.sv  +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave -position insertpoint sim:/FIFO_top/FIFOif/*
add wave -position insertpoint  \
sim:/FIFO_top/FIFOdut/mem \
sim:/FIFO_top/FIFOdut/wr_ptr \
sim:/FIFO_top/FIFOdut/rd_ptr \
sim:/FIFO_top/FIFOdut/count \
sim:/FIFO_shared_pkg::Error_count \
sim:/FIFO_shared_pkg::Correct_count \
sim:/FIFO_shared_pkg::test_finished 
run -all
add wave -position insertpoint  \
sim:/FIFO_top/FIFOmonitor/FIFO_tr_mon \
sim:/FIFO_top/FIFOmonitor/FIFO_sb_mon
restart
run -all
coverage save FIFO_top.ucdb -onexit
coverage exclude -cvgpath {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_wr_ack/<auto[0],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_wr_ack/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_overflow/<auto[0],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_overflow/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_underflow/<auto[1],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_underflow/<auto[0],auto[0],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_full/<auto[1],auto[1],auto[1]>} {/FIFO_coverage_pkg/FIFO_coverage/FIFO_coverage__1/FIFO_coverage/wr_rd_full/<auto[0],auto[1],auto[1]>}
coverage exclude -src FIFO.sv -scope /FIFO_top/FIFOdut -line 53 -code c
coverage exclude -src FIFO.sv -scope /FIFO_top/FIFOdut -line 70 -code c
