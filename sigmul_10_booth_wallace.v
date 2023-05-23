`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: Chris Larsen, 2023 
// 
// Create Date: 01/28/2023 02:00:22 PM
// Design Name: 
// Module Name: sigmul_10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Modified Booth's Method combined with 3:2 compression for
//              multiplication of signed integers. This version of the code is
//              specific to the IEEE 754 binary16 data type.  Replaces code
//              found at https://github.com/crlarsen/sigmul_10-2.
//
//              After generating the partial products the code uses 3:2
//              compression (aka a Wallace tree) to avoid the delays caused by
//              carry propagation. When the code finally gets down to only
//              2 integers a fast addition circuit is used to maximize how
//              quickly the carry propagation occurs.
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module compress_32_2(x, y, z, s, c);
  parameter W = 6;
  input signed [W+3:0] x;
  input signed [W+4:3] y;
  input signed [W+9:6] z;
  output signed [W+9:0] s;
  output signed [W+10:4] c;
  
  assign s[2:0] = x[2:0];
  assign s[5:3] = x[5:3] ^ y[5:3];
  assign c[6:4] = x[5:3] & y[5:3];
  
  wire signed [W+9:6] sX, sY;
  assign sX = {{6{x[W+3]}}, x[W+3:6]};
  assign sY = {{5{y[W+4]}}, y[W+4:6]};
  assign s[W+9:6] = sX ^ sY ^ z;
  assign c[W+10:7] = (sX & sY) | (sX & z) | (sY & z);
endmodule

module compress_32_3(x, y, z, s, c);
  parameter W = 6;
  input signed [W+9:0] x;
  input signed [W+10:4] y;
  input signed [W+10:9] z;
  output signed [W+10:0] s;
  output signed [W+11:5] c;
  
  assign s[3:0] = x[3:0];
  assign s[8:4] = x[8:4] ^ y[8:4];
  assign c[9:5] = x[8:4] & y[8:4];
  
  wire signed [W+10:9] sX;
  assign sX = {x[W+9], x[W+9:9]};
  assign s[W+10:9] = sX ^ y[W+10:9] ^ z;
  assign c[W+11:10] = (sX & y[W+10:9]) | (sX & z) | (y[W+10:9] & z);
endmodule

module sigmul_10(a, b, p);
  localparam NSIG = 10;
  localparam NSIG1 = NSIG + 1;            // Actual number of significand bits
  localparam NPBITS = NSIG & 1;           // Number of pad bits to get odd length for bbits
  localparam NBBITS = NSIG1 + 2 + NPBITS; // Number of bbits
  localparam NPPBITS = NSIG1 + 2;         // Number of bits in each partial product
  localparam NPPS = NBBITS >> 1;          // Number of partial products
  input [NSIG:0] a;
  input [NSIG:0] b;
  output [2*NSIG+1:0] p;
    
  wire signed [NPPBITS-1:0] pp[NPPS-1:0];
  wire [NBBITS-1:-1] bbits = {1'b0, b, {1+NPBITS{1'b0}}};
  wire signed [NPPBITS+NSIG-1:0] st[NPPS-1:0]; // Running total of the partial products
  
  wire signed [NPPBITS-1:0] posA = a, pos2A = {a, 1'b0}, negA = -a, neg2A = {negA, 1'b0}, zero = 0;
    
  genvar i;
  generate
    // Generate partial products
    for (i = 0; i < NPPS; i = i + 1)
      begin
        mux8to1 #(NPPBITS) U0(pp[i], bbits[2*i+1:2*i-1], zero, posA, posA, pos2A, neg2A, negA, negA, zero);
      end
  endgenerate
      
  wire signed [NPPBITS+3:0] s1_1;
  wire signed [NPPBITS+4:3] c1_1;
  wire signed [NPPBITS+9:6] s1_2;
  wire signed [NPPBITS+10:9] c1_2;
  
  compress_32_1 #(NPPBITS) U0(pp[0], pp[1], pp[2], s1_1, c1_1);

  compress_32_1 #(NPPBITS) U1(pp[3], pp[4], pp[5], s1_2, c1_2);

  wire signed [NPPBITS+9:0] s2_1;
  wire signed [NPPBITS+10:4] c2_1;

  compress_32_2 #(NPPBITS) U2(s1_1, c1_1, s1_2, s2_1, c2_1);
  
  wire signed [NPPBITS+10:0] s3_1;
  wire signed [NPPBITS+11:5] c3_1;

  compress_32_3 #(NPPBITS) U3(s2_1, c2_1, c1_2, s3_1, c3_1);
    
  assign p[4:0] = s3_1[4:0]; // These bits already have their final value
  wire Cout;
  padder17 U4(s3_1[2*NSIG+1:5], c3_1[2*NSIG+1:5], 1'b0, p[2*NSIG+1:5], Cout);
endmodule
