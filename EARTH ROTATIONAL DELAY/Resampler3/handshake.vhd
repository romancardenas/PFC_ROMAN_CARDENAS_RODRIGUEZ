
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplertypes.all;

entity handshake is
    Port ( clk1 : in  STD_LOGIC; -- Origin clock
           clk2 : in  STD_LOGIC; -- Final clock
           reset : in  STD_LOGIC;
           valid_in : in  STD_LOGIC;
           valid_out : out  STD_LOGIC);
end handshake;

architecture Behavioral of handshake is

signal middle : STD_LOGIC := '0';
signal adapt : handshake_v := (others => '0');

begin

	domain1 : process(clk1)
	begin
		if clk1'event and clk1 = '1' then
			if reset = '0' then
				middle <= '0';
			else
				middle <= valid_in;
			end if;
		end if;
	end process;
	
	domain2 : process (clk2)
	begin
		if clk2'event and clk2 = '1' then
			if reset = '0' then
				adapt <= (others => '0');
			else
				adapt (0) <= middle;
				for i in 1 to (handshake_l-1) loop
					adapt(i) <= adapt(i-1);
				end loop;
			end if;
		end if;
	end process;

	valid_out <= adapt(handshake_l-1);

end Behavioral;

