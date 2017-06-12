----------------------------------------------------------------------------------
-- Company: 		Universidad Politécnica de Madrid
-- Engineer: 		Román Cárdenas Rodríguez
-- 
-- Create Date:    23:36:38 02/07/2017 
-- Module Name:    Bank - Behavioral 
-- Project Name: 	 Resampler based on demultiplexed banks of filters
-- Description: 	 This module describes the behaviour of the banks of filters inside of
--						 the resampler.
--
-- Dependencies:   ResamplerTypes and CoeffConstants libraries.
--					    Filters, Adder56x26 and out_delayer Modules
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.0 - Module Implemented
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;
use work.CoeffConstants.all;

entity Bank is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  FilterArray; -- Data input. As many samples as filter banks.
           CoeffIndex : in  STD_LOGIC_VECTOR (9 downto 0); -- Coefficient Index for the different filters.
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end Bank;

architecture Behavioral of Bank is

component Filters is
	Port ( clk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 data_in : in FilterArray;								
			 CoeffIndex : in STD_LOGIC_VECTOR (9 downto 0); 
			 data_out : out multArray);							
end component;

component adder56x26 is
   Port ( clk : in STD_LOGIC;
			 reset: in STD_LOGIC;
			 data_in : in  MultArray;
          data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component out_delayer is
	Port ( clk : in  STD_LOGIC;
			 reset : in STD_LOGIC;
			 data_in : in  STD_LOGIC_VECTOR(31 downto 0);
			 data_out : out  STD_LOGIC_VECTOR(31 downto 0));
	end component;

signal adder_input : MultArray;
signal data_out_s : STD_LOGIC_VECTOR (31 downto 0);

begin

	FILTERING : Filters
		Port map (clk => clk,
			 reset => reset,
			 data_in => data_in,								
			 CoeffIndex => CoeffIndex, 
			 data_out => adder_input);
	
	ADDER : adder56x26
		Port map ( clk => clk,
		    reset => reset,
			 data_in => adder_input,
			 data_out => data_out_s);
	
	OUT_DELAY : out_delayer
	   Port map (clk => clk,
			 reset => reset,
			 data_in  => data_out_s,
			 data_out => data_out);

end Behavioral;

