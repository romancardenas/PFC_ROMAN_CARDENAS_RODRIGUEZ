library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplerTypes.ALL;

entity validation is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           valid_in : in  STD_LOGIC;
           valid_out : out  STD_LOGIC);
end validation;

architecture Behavioral of validation is

signal valArray : validation_v := (others => '0');

begin
	refresh : process(clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				valArray <= (others => '0');
			else
				valArray(0) <= valid_in;
				for i in 1 to 11 loop
					valArray (i) <= valArray (i - 1);
				end loop;
			end if;
		end if;
	end process;
	valid_out <= valArray(11);
end Behavioral;

