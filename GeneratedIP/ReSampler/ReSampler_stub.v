// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
// Date        : Sun May 28 17:29:02 2017
// Host        : DESKTOP-CS038BS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/FinalReSampler/FinalReSampler.srcs/sources_1/ip/ReSampler/ReSampler_stub.v
// Design      : ReSampler
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "top1,Vivado 2017.1" *)
module ReSampler(clk, reset, Data_in, valid_in, ERD, FOE, WR_CONT, 
  Data_out, FIFO_read, Valid_out)
/* synthesis syn_black_box black_box_pad_pin="clk,reset,Data_in[7:0],valid_in,ERD[9:0],FOE[41:0],WR_CONT[2:0],Data_out[31:0],FIFO_read,Valid_out" */;
  input clk;
  input reset;
  input [7:0]Data_in;
  input valid_in;
  input [9:0]ERD;
  input [41:0]FOE;
  input [2:0]WR_CONT;
  output [31:0]Data_out;
  output FIFO_read;
  output Valid_out;
endmodule
