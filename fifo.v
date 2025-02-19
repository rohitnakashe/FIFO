// Code your design here
module FIFO#(parameter DEPTH=16, WIDTH=8)
  (input clk, rst, wr, rd,
   input [WIDTH-1:0] din, output reg [WIDTH-1:0] dout,
            output empty, full);
  
  reg [($clog2(DEPTH)-1):0] wptr = 0, rptr = 0;
  
  reg wrote;
  
  // Memory array to store data
  reg [WIDTH-1:0] mem [DEPTH-1:0];
 
  always @(posedge clk)
    begin
      if (rst == 1'b1)
        begin
          // Reset the pointers and counter when the reset signal is asserted
          wptr <= 0;
          rptr <= 0;
          wrote  <= 0;
        end
      else if (wr && !full)
        begin
          // Write data to the FIFO if it's not full
          mem[wptr] <= din;
          wptr      <= wptr + 1;
          wrote     <= 1;
        end
      else if (rd && !empty)
        begin
          // Read data from the FIFO if it's not empty
          dout <= mem[rptr];
          rptr <= rptr + 1;
          wrote  <=  0;
        end
    end
 
  // Determine if the FIFO is empty or full
  assign empty = ( wptr == rptr) && (~wrote) ? 1'b1 : 1'b0;
  assign full  = ( wptr == rptr) && (wrote) ? 1'b1 : 1'b0;
 
endmodule
 
//////////////////////////////////////
 
// Define an interface for the FIFO
interface fifo_if;
  
  logic clock, rd, wr;         // Clock, read, and write signals
  logic full, empty;           // Flags indicating FIFO status
  logic [7:0] data_in;         // Data input
  logic [7:0] data_out;        // Data output
  logic rst;                   // Reset signal
 
endinterface
