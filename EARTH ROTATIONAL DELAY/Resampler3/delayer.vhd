library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplerTypes.all;

entity data_delayer is
   Port ( data_in : in  DelayArray;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  DelayArray);
end data_delayer;

architecture Behavioral of data_delayer is

signal content1, content2 : DelayArray :=(others => "00000000");

begin

	shift: process (clk)
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				for i in 0 to TAP-1 loop
					content1(i) <= (others => '0');
					content2(i) <= (others => '0');
				end loop;
			else
				for i in 0 to TAP-1 loop  
					content1(i) <= data_in(i);
				   content2(i) <= content1(i);
				end loop;
			end if;
		end if;
	end process;

	data_out <= content2;

end Behavioral;


