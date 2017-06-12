library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ReSamplerTypes.ALL;

entity delayer is
   Port ( data_in : in  DelayItem;
			 enable : in STD_LOGIC;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  DelayArray);
end delayer;

architecture Behavioral of delayer is

signal content : DelayArray := (others => "00000000");

begin

	shift: process (clk)
	begin
		if (clk'event and clk = '1') then
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

