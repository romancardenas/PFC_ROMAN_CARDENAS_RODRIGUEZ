----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:58:01 07/01/2016 
-- Design Name: 
-- Module Name:    Mult_delayer - Behavioral 
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

entity Mult_delayer is
   Port ( data_in : in  MultArray;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  MultArray);
end Mult_delayer;

architecture Behavioral of Mult_delayer is

signal content : MultArray :=(others => "00000000000000000000000000");

begin

	shift: process (data_in, reset, clk) -- sintesis recomienda data_in dentro
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content <= (others => "00000000000000000000000000");
			else
				content <= data_in;
			end if;
		end if;
	end process;

	data_out <= content;

end Behavioral;

