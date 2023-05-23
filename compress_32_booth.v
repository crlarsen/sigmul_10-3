`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2023 04:46:23 AM
// Design Name: 
// Module Name: compress_32_booth
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module compress_32_1(x, y, z, s, c);
  parameter W = 6;
  input signed [W-1:0] x;
  input signed [W+1:2] y;
  input signed [W+3:4] z;
  output signed [W+3:0] s;
  output signed [W+4:3] c;
  
  wire [W+3:4] sX, sY;
  assign sX = {{4{x[W-1]}}, x[W-1:4]};
  assign sY = {{2{y[W+1]}}, y[W+1:4]};
  
  assign s[1:0] = x[1:0];
  assign s[3:2] = x[3:2] ^ y[3:2];
  assign c[4:3] = x[3:2] & y[3:2];
  assign s[W+3:4] = sX ^ sY ^ z;
  assign c[W+4:5] = (sX & sY) | (sX & z) | (sY & z);
endmodule
