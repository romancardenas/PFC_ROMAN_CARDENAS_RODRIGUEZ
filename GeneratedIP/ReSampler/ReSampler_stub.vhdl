-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
-- Date        : Sun May 28 17:29:02 2017
-- Host        : DESKTOP-CS038BS running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/FinalReSampler/FinalReSampler.srcs/sources_1/ip/ReSampler/ReSampler_stub.vhdl
-- Design      : ReSampler
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k70tfbv676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ReSampler is
  Port ( 
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    Data_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    valid_in : in STD_LOGIC;
    ERD : in STD_LOGIC_VECTOR ( 9 downto 0 );
    FOE : in STD_LOGIC_VECTOR ( 41 downto 0 );
    WR_CONT : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Data_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    FIFO_read : out STD_LOGIC;
    Valid_out : out STD_LOGIC
  );

end ReSampler;

architecture stub of ReSampler is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,reset,Data_in[7:0],valid_in,ERD[9:0],FOE[41:0],WR_CONT[2:0],Data_out[31:0],FIFO_read,Valid_out";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "top1,Vivado 2017.1";
begin
end;
