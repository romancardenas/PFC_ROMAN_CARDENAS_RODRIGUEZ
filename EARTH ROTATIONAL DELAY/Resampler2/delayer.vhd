----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:09:48 03/23/2016 
-- Design Name: 
-- Module Name:    delayer - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.ReSamplerTypes.all;

entity delayer is
   Port ( data_in : in  DelayItem;
			 enable : in STD_LOGIC;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  DelayArray);
end delayer;

architecture Behavioral of delayer is

signal content : DelayArray :=(others => "00000000");

begin

	shift: process (data_in, reset, clk) -- sintesis recomienda data_in dentro
	begin
		--if reset = '0' then
		--	for i in 0 to TAP-1 loop
		--		content(i) <= (others => '0');
		--	end loop;
 		--	content(0) <= data_in;
		if (clk'event and clk='1') then
			if reset = '0' then
				for i in 0 to TAP-1 loop
					content(i) <= (others => '0');
				end loop;
				content(0) <= data_in;
			elsif enable = '1' then
				content(0) <= data_in;
				for i in 0 to TAP-2 loop  
					content(i+1) <= content(i);	
				end loop;
			end if;
		end if;
	end process;

	data_out <= content;

end Behavioral;

