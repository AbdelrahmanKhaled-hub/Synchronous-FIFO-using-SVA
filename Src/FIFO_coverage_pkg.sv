package FIFO_coverage_pkg;

import FIFO_transaction_pkg::*;
import FIFO_shared_pkg::*;


class FIFO_coverage #(int FIFO_WIDTH = 16 , int FIFO_DEPTH = 8);
FIFO_transaction #(16,8) F_cvg_txn = new();
covergroup FIFO_coverage ;
    
    data_out_cp: coverpoint F_cvg_txn.data_out {
        bins data_out_bin = {[0:$]};
        option.weight=0;
        }

    wr_rd_data_out: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,data_out_cp;
    wr_rd_wr_ack: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.wr_ack;
    wr_rd_overflow: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.overflow;
    wr_rd_underflow: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.underflow;
    wr_rd_full: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.full;
    wr_rd_empty: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.empty;
    wr_rd_almostfull: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.almostfull;
    wr_rd_almostempty: cross F_cvg_txn.wr_en,F_cvg_txn.rd_en,F_cvg_txn.almostempty;
    //option.auto_bin_max=0;

endgroup

function new();
    FIFO_coverage = new();
endfunction

function sample_data(FIFO_transaction #(16,8) F_txn);
    F_cvg_txn = F_txn;
    FIFO_coverage.sample();
endfunction
endclass    
endpackage
