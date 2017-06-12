----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:48:51 07/07/2016 
-- Design Name: 
-- Module Name:    input_delayer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ReSamplerTypes.all;

entity input_delayer is
   Port ( data_in : in DelayArray;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  DelayArray);
end input_delayer;

architecture Behavioral of input_delayer is

signal content : DelayArray :=(others => "00000000");
signal content_bis : DelayArray :=(others => "00000000");
begin

	shift: process (data_in, reset, clk) 
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content <= (others => "00000000");
			else
				content_bis <= content;
				content <= data_in;
			end if;
		end if;
	end process;

	data_out <= content_bis;

end Behavioral;

