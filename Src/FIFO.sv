////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFOif);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

logic [FIFO_WIDTH-1:0] data_in,data_out;
logic clk, rst_n, wr_en, rd_en,wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

assign clk = FIFOif.clk;
assign rst_n = FIFOif.rst_n;
assign data_in = FIFOif.data_in;
assign wr_en = FIFOif.wr_en;
assign rd_en = FIFOif.rd_en;
assign FIFOif.data_out=data_out;
assign FIFOif.wr_ack=wr_ack;
assign FIFOif.overflow=overflow;
assign FIFOif.full=full;
assign FIFOif.empty=empty;
assign FIFOif.almostfull=almostfull;
assign FIFOif.almostempty=almostempty;
assign FIFOif.underflow=underflow;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);                          

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

initial $readmemb("FIFO_init.dat", mem);                                //Initializing the FIFO to be empty

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;                                            

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		underflow <= 0;                                                 //Reseting the Underflow                                                 
		overflow <= 0;													//Reseting the Overflow
		wr_ack <=0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0;													//Adding condition that if writing then overflow is zero
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)                                 
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0;                                            //Adding condition that if reading then Underflow is zero
	end
	else begin                                           	       //Adding the underflow statements to be sequential and not combinational
		if (empty & rd_en)                                 
			underflow <= 1;
		else
			underflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if (({{wr_en, rd_en} == 2'b11}) && full)             //Added conition when FIFO is full and wr and rd enables are high system reads only
			count <= count - 1;
		else if (({{wr_en, rd_en} == 2'b11}) && empty)           //Added conition when FIFO is empty and wr and rd enables are high system writes only
			count <= count + 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;                            
assign empty = (count == 0)? 1 : 0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0;             //AlmostFull is when count equal to FIFO_DEPTH-1 Not FIFO_DEPTH-2 as count is incremented on ptr by 1
assign almostempty = (count == 1)? 1 : 0;

////////////////////////////////Assertions///////////////////////////////
property reset_p;
	@(posedge clk) !rst_n |-> (count==0 && !overflow && !underflow && !full && empty && !almostfull && !almostempty && !wr_ack); 
endproperty

property overflow_p;
	@(posedge clk) disable iff (!rst_n) (wr_en && count==8) |=> (overflow && !wr_ack);
endproperty

property underflow_p;
	@(posedge clk) disable iff (!rst_n) (rd_en && count==0) |=> (underflow);
endproperty

property wr_ack_p;
	@(posedge clk) disable iff (!rst_n) (count!=8 && wr_en) |=> wr_ack; 
endproperty

property full_p;
	@(posedge clk) disable iff (!rst_n) (count==8) |-> full;
endproperty

property empty_p;
	@(posedge clk) disable iff (!rst_n) (count==0) |-> empty;
endproperty

property almostfull_p;
	@(posedge clk) disable iff (!rst_n) (count==7) |-> almostfull;
endproperty

property almostempty_p;
	@(posedge clk) disable iff (!rst_n) (count==1) |-> almostempty;
endproperty

reset_assertion: assert property(reset_p);
overflow_assertion: assert property(overflow_p);
underflow_assertion: assert property(underflow_p);
wr_ack_assertion: assert property(wr_ack_p);
full_assertion: assert property(full_p);
empty_assertion: assert property(empty_p);
almostfull_assertion: assert property(almostfull_p);
almostempty_assertion: assert property(almostempty_p);

reset_coverage: cover property(reset_p);
overflow_coverage: cover property(overflow_p);
underflow_coverage: cover property(underflow_p);
wr_ack_coverage: cover property(wr_ack_p);
full_coverage: cover property(full_p);
empty_coverage: cover property(empty_p);
almostfull_coverage: cover property(almostfull_p);
almostempty_coverage: cover property(almostempty_p);


endmodule
