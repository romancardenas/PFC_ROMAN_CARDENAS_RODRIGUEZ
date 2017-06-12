----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:14:58 02/05/2017 
-- Design Name: 
-- Module Name:    Selector_delay - Behavioral 
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

entity selector_delayer is
   Port ( sel_in : in STD_LOGIC_VECTOR (1 downto 0);
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          sel_out : out  STD_LOGIC_VECTOR (1 downto 0));
end selector_delayer;

architecture Behavioral of Selector_delayer is

signal content, content_d : std_logic_vector (1 downto 0) := "00";

begin
	shift: process (clk) 
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content <= (others => '0');
				content_d <= (others => '0');
			else
				content <= sel_in;
				content_d <= content;
			end if;
		end if;
	end process;

	sel_out <= content_d;

end Behavioral;

