package FIFO_scoreboard_pkg;

import FIFO_transaction_pkg::*;
import FIFO_shared_pkg::*; 

class FIFO_scoreboard #(int FIFO_WIDTH = 16 , int FIFO_DEPTH = 8);

//FIFO queue
logic [FIFO_WIDTH-1:0] FIFO_queue [$];  

int count=0;
logic [FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref, overflow_ref,underflow_ref,full_ref, empty_ref, almostfull_ref, almostempty_ref;

function void check_data(FIFO_transaction #(16,8) FIFO_check);
    reference_model(FIFO_check);

    if((FIFO_check.data_out!=data_out_ref) || (FIFO_check.wr_ack!=wr_ack_ref) || (FIFO_check.overflow!=overflow_ref) || (FIFO_check.underflow!=underflow_ref) || 
    (FIFO_check.full!=full_ref) || (FIFO_check.empty!=empty_ref) || (FIFO_check.almostfull!=almostfull_ref) || (FIFO_check.almostempty!= almostempty_ref)) begin
        Error_count++;
        $display("Error in Checking values");
    end
    else 
        Correct_count++;
endfunction

function void reference_model(FIFO_transaction #(16,8) FIFO_ref);
    
    /////////////////////////////////Reset Signal///////////////////////////////
    if(!FIFO_ref.rst_n) begin
        FIFO_queue.delete();
        count=0; wr_ack_ref=0; overflow_ref=0; underflow_ref=0; full_ref=0; empty_ref=1; almostfull_ref=0; almostempty_ref=0; 
    end
    else begin

    ////////////////////////////////Reading and Writing/////////////////////////////// 
        //write only
        if(FIFO_ref.rd_en && FIFO_ref.wr_en && count==0) begin
            underflow_ref=1;                                                              
            FIFO_queue.push_front(FIFO_ref.data_in);
            wr_ack_ref=1;
            overflow_ref=0;    
            almostempty_ref=1;
            almostfull_ref=0;
            empty_ref=0;
            full_ref=0;

        count++;
        end
        //Read only
        else if(FIFO_ref.rd_en && FIFO_ref.wr_en && count==8) begin                                 
            overflow_ref=1;
            data_out_ref=FIFO_queue.pop_back();
            wr_ack_ref=0;
            underflow_ref=0;
            almostempty_ref=0;
            almostfull_ref=1;
            empty_ref=0;
            full_ref=0;
        
        count--;
        end
        //Write and Read Together
        else begin    
            if(FIFO_ref.wr_en && count < FIFO_DEPTH) begin
                FIFO_queue.push_front(FIFO_ref.data_in);
                count++;
            end
            if(FIFO_ref.rd_en && (count != 0)) begin
                data_out_ref=FIFO_queue.pop_back();
                count--;
            end

    //All Control signals
    ///////////////////////////////Over and Under flow Signals///////////////////////////////
        //Overflow signal
        if(FIFO_ref.wr_en && full_ref)  overflow_ref=1;
        else    overflow_ref=0;
        //Underflow signal
        if(FIFO_ref.rd_en && empty_ref)  underflow_ref=1;
        else    underflow_ref=0;
    /////////////////////////////////Write acknowledge Signal///////////////////////////////
        if((FIFO_ref.rd_en && FIFO_ref.wr_en && empty_ref)||(FIFO_ref.wr_en && count <= FIFO_DEPTH && overflow_ref==0)) wr_ack_ref=1;
        else wr_ack_ref=0;
    ///////////////////////////////full and empty  Signals///////////////////////////////
        //Full signal
        if(count == FIFO_DEPTH)  full_ref=1;
        else    full_ref =0;
        //Empty signal
        if(count == 0)  empty_ref=1;
        else    empty_ref=0;
    ///////////////////////////////Almost empty and full Signals///////////////////////////////
        //Almost empty signal
        if(count == 1)    almostempty_ref=1;
        else    almostempty_ref=0;
        //Almost full signal
        if(count==(FIFO_DEPTH-1)) almostfull_ref=1;
        else    almostfull_ref=0;

        end
    end
endfunction
endclass
endpackage
