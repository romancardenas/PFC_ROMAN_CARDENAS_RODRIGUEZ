----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:05 07/04/2016 
-- Design Name: 
-- Module Name:    coeff_delayer - Behavioral 
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

entity coeff_delayer is
   Port ( data_in : in  CoeffPhase;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  CoeffPhase);
end coeff_delayer;

architecture Behavioral of coeff_delayer is

signal content, content_d : CoeffPhase :=(others => "000000000000000000");

begin

	shift: process (data_in, reset, clk) -- sintesis recomienda data_in dentro
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content <= (others => "000000000000000000");
				content_d <= (others => "000000000000000000");
			else
				content <= data_in;
				content_d <= content;
			end if;
		end if;
	end process;

	data_out <= content_d;

end Behavioral;

