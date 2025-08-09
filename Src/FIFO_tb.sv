import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_shared_pkg::*;

module FIFO_tb(FIFO_if.tb FIFOif);

FIFO_transaction #(16,8) FIFO_tr =new();

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

logic [FIFO_WIDTH-1:0] data_in,data_out;
logic clk, rst_n, wr_en, rd_en,wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

assign clk = FIFOif.clk;
assign data_out = FIFOif.data_out;
assign wr_ack = FIFOif.wr_ack;
assign overflow = FIFOif.overflow;
assign underflow = FIFOif.underflow;
assign full=FIFOif.full;
assign empty = FIFOif.empty;
assign almostfull = FIFOif.almostfull;
assign almostempty = FIFOif.almostempty;
assign FIFOif.rst_n = rst_n;
assign FIFOif.data_in = data_in;
assign FIFOif.wr_en = wr_en;
assign FIFOif.rd_en = rd_en;

initial begin

    rst_n=0; data_in=0; wr_en=0; rd_en=0;
    @(negedge clk);

    repeat(1000) begin
        assert(FIFO_tr.randomize());
        rst_n = FIFO_tr.rst_n;
        data_in = FIFO_tr.data_in;
        wr_en = FIFO_tr.wr_en;
        rd_en = FIFO_tr.rd_en;
        @(negedge clk);
    end
    test_finished=1; 
end

endmodule
