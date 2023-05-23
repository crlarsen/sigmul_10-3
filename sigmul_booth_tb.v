`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Copyright: Chris Larsen, 2023 
// 
// Create Date: 01/25/2023 09:51:21 AM
// Design Name: 
// Module Name: sigmul_booth_tb
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


module sigmul_booth_tb;
`define BINARY16 1
  // {NEXP, NSIG} = {5, 10} | {8, 23} | {11, 52} | {15, 112}
`ifdef BINARY16
  parameter NEXP =   5;
  parameter NSIG =  10;
`elsif BINARY32
  parameter NEXP =   8;
  parameter NSIG =  23;
`elsif BINARY64
  parameter NEXP =  11;
  parameter NSIG =  52;
`elsif BINARY128
  parameter NEXP =  15;
  parameter NSIG = 112;
`else
  No valid IEEE type
`endif
  localparam N = NSIG + 1;
  reg [NSIG:0] a;
  reg [NSIG:0] b;
  wire [2*NSIG+1:0] p;

  integer i, j;

  initial
  begin
    for (i = (1 << NSIG); i < (1 << N); i = i + 1)
      begin
        for (j = (1 << NSIG); j < (1 << N); j = j + 1)
          begin
            a = i; b = j;
            
            #100 if (a * b != p)
              begin
                $display("%d * %d = %d; got %d", a, b, (a*b), p);
                $stop;
              end
          end
      end

    $display($time);
    $display("No errors found!");
    $stop;
  end

  if (NSIG == 10)
    sigmul_10 inst10(a, b, p);
  else if (NSIG == 23)
    sigmul_23 inst23(a, b, p);
  else
    sigmul #(NSIG) instany(a, b, p);

endmodule
