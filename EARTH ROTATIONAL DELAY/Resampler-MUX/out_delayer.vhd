----------------------------------------------------------------------------------
-- Company: 		Universidad Politécnica de Madrid
-- Engineer: 		Miguel Ferre Vázquez
-- 
-- Create Date:    18:08:11 07/06/2016 
-- Module Name:    out_delayer - Behavioral 
-- Project Name:   SKA Resampler
-- Description: This module endows synchronism to the output of the Filtering Process
--
-- Dependencies: ResamplerTypes library
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.0 - Module implemented
-- Revision 1.01 - Code debugged by Román Cárdenas Rodríguez
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ReSamplerTypes.all;

entity out_delayer is
   Port ( clk : in  STD_LOGIC;
			 reset : in STD_LOGIC;
			 data_in : in  STD_LOGIC_VECTOR(31 downto 0);
          data_out : out  STD_LOGIC_VECTOR(31 downto 0));
end out_delayer;

architecture Behavioral of out_delayer is

signal content : STD_LOGIC_VECTOR(31 downto 0) :=(others => '0');

begin

	shift: process (clk) 
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content <= (others => '0');
			else
				content <= data_in;
			end if;
		end if;
	end process;

	data_out <= content;

end Behavioral;

