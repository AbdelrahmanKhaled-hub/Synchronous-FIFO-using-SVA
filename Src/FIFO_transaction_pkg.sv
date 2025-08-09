package FIFO_transaction_pkg;

import FIFO_shared_pkg::*;

class FIFO_transaction #(int FIFO_WIDTH = 16 , int FIFO_DEPTH = 8);

logic [FIFO_WIDTH-1:0] data_out;
logic clk,wr_ack, overflow,full, empty, almostfull, almostempty, underflow;
rand logic rst_n, wr_en, rd_en;
rand logic [FIFO_WIDTH-1:0] data_in;
int RD_EN_ON_DIST,WR_EN_ON_DIST;

function new(int rd_percent = 30,int wr_percent = 70);
    RD_EN_ON_DIST=rd_percent;
    WR_EN_ON_DIST=wr_percent;        
endfunction

constraint reset{rst_n dist {0:=5,1:=95};}
constraint write_enable{wr_en dist{0:=(100-WR_EN_ON_DIST),1:=WR_EN_ON_DIST};}
constraint read_enable{rd_en dist{0:=(100-RD_EN_ON_DIST),1:=RD_EN_ON_DIST};}


endclass 
    
endpackage
