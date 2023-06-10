`timescale 1ns / 1ps

module lifo (
  input clk,
  input rst,
  input wr_req_i,
  input [15:0] wr_data_i,
  input rd_req_i,
  
  output reg [15:0] rd_data_o,
  output reg [3:0] amount,
  output empty_o,
  output full_o,
  
  output [15:0] rd_data
);

  reg [15:0] mem [0:7];
  reg [2:0] ptr = 3'b000;
  reg empty = 1'b1;
  reg full = 1'b0;

  reg [15:0] mem_next;

  integer i;
  
  assign empty_o = empty;
  assign full_o = full;
  assign rd_data = (rd_req_i && !empty) ? mem[ptr] : 16'b0;

  always @(posedge clk) begin
    if (rst == 0) begin
      for (i = 0; i < 8; i = i + 1)
        mem[i] <= 16'b0;
      
      ptr <= 3'b000;
      empty <= 1'b1;
      full <= 1'b0;
      rd_data_o <= 16'b0;
      amount <= 0;
    end else begin
      if (wr_req_i && !full) begin
        mem[ptr] = wr_data_i;
        ptr = ptr + 1;
        
        empty = 1'b0;
        if (ptr == 8) full = 1'b1;
        amount = amount + 1;
      end
      
      else if (rd_req_i && !empty) begin
        rd_data_o = mem[ptr];
        ptr = ptr - 1;
        
        full = 1'b0;
        if (ptr == 0) empty = 1'b1;
        amount = amount - 1;
      end
    end
  end
endmodule