module FIFO_top();
bit clk;

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end

FIFO_if FIFOif(clk);
FIFO FIFOdut(FIFOif);
FIFO_tb FIFOtest(FIFOif);
FIFO_monitor FIFOmonitor(FIFOif);

endmodule
