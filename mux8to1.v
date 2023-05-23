`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2023 01:01:04 AM
// Design Name: 
// Module Name: mux8to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 8-to-1 Multiplexer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux8to1(o, s, i0, i1, i2, i3, i4, i5, i6, i7);
  parameter W = 2;
  output [W-1:0] o;
  input [2:0] s;
  input [W-1:0] i0, i1, i2, i3, i4, i5, i6, i7;
  
  genvar i;
  generate
    for (i = 0; i < W; i = i + 1)
      begin
        assign o[i] = (~s[2] & ~s[1] & ~s[0] & i0[i]) |
                      (~s[2] & ~s[1] &  s[0] & i1[i]) |
                      (~s[2] &  s[1] & ~s[0] & i2[i]) |
                      (~s[2] &  s[1] &  s[0] & i3[i]) |
                      ( s[2] & ~s[1] & ~s[0] & i4[i]) |
                      ( s[2] & ~s[1] &  s[0] & i5[i]) |
                      ( s[2] &  s[1] & ~s[0] & i6[i]) |
                      ( s[2] &  s[1] &  s[0] & i7[i]);
      end
  endgenerate
endmodule
