import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_shared_pkg::*;

module FIFO_monitor(FIFO_if.MONITOR FIFOif);

FIFO_transaction FIFO_tr_mon = new();
FIFO_coverage FIFO_cv_mon = new();
FIFO_scoreboard FIFO_sb_mon = new();

initial begin

    forever begin

        @(negedge FIFOif.clk);

        FIFO_tr_mon.clk = FIFOif.clk;
        FIFO_tr_mon.rst_n = FIFOif.rst_n;
        FIFO_tr_mon.data_in = FIFOif.data_in;
        FIFO_tr_mon.wr_en = FIFOif.wr_en;
        FIFO_tr_mon.rd_en = FIFOif.rd_en;
        FIFO_tr_mon.data_out = FIFOif.data_out;
        FIFO_tr_mon.wr_ack = FIFOif.wr_ack;
        FIFO_tr_mon.overflow = FIFOif.overflow;
        FIFO_tr_mon.underflow = FIFOif.underflow;
        FIFO_tr_mon.full = FIFOif.full;
        FIFO_tr_mon.empty = FIFOif.empty;
        FIFO_tr_mon.almostfull = FIFOif.almostfull;
        FIFO_tr_mon.almostempty = FIFOif.almostempty;

    fork
        begin
            FIFO_cv_mon.sample_data(FIFO_tr_mon);
        end
        begin
            FIFO_sb_mon.check_data(FIFO_tr_mon);
        end
    join

    if(test_finished==1) begin
        $display("Error_count=%0d,Correct_count=%0d",Error_count,Correct_count);
        $stop;
    end
    end
end
endmodule
