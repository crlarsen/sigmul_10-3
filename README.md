# Third Optimization of 11-Bit Integer Multiply Circuit

## Description

Accelerate circuit performance by:
- Using Modified Booth's Method to reduce starting number of partial products from 11 to 6.
- Performing 3:2 compression in parallel, when possible.
- Using 17-bit Prefix Adder module rather than Carry Look Ahead adder or Ripple Carry Adder modules.

The code is explained in the video series [Building an FPU in Verilog](https://www.youtube.com/watch?v=sIhwGU_xXc0).
See the video *Building an FPU in Verilog: Floating Point Division, Part 7*.

## Manifest

|   Filename   |                        Description                        |
|--------------|-----------------------------------------------------------|
| README.md | This file. |
| compress32_booth.v | Utility modules which can also be used with the 32-, 64-, and 128-bit IEEE 754 binary floating point formats. |
| mux8to1.v | 8-to-1 MUX code for selecting partial product |
| padder17.v | 17-bit Prefix adder module. |
| PijGij.v | Utility modules needed by prefix adder. |
| sigmul_10_booth_wallace.v | Significand multiply module specific to the IEEE 754 binary16 data format. |
| sigmul_booth_tb.v | Testbench code for multiply module. |

## Copyright

:copyright: Chris Larsen, 2019-2023
