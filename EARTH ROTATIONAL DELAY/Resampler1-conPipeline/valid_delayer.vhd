----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:34:07 07/08/2016 
-- Design Name: 
-- Module Name:    valid_delayer - Behavioral 
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

entity valid_delayer is
   Port ( data_in : in  STD_LOGIC;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  STD_LOGIC);
end valid_delayer;

architecture Behavioral of valid_delayer is

signal content1 : STD_LOGIC:='0';
signal content2 : STD_LOGIC:='0';
signal content3 : STD_LOGIC:='0';
signal content4 : STD_LOGIC:='0';
signal content5 : STD_LOGIC:='0';
signal content6 : STD_LOGIC:='0';
signal content7 : STD_LOGIC:='0';
signal content8 : STD_LOGIC:='0';
signal content9 : STD_LOGIC:='0';

begin

	shift: process (data_in, reset, clk) 
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content1 <= '0';
			else
				content9 <=content8;
				content8 <=content7;
				content7 <=content6;
				content6 <=content5;
				content5 <=content4;
				content4 <=content3;
				content3 <=content2;
				content2 <=content1;
				content1 <= data_in;
			end if;
		end if;
	end process;

	data_out <= content9;

end Behavioral;

