library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;

entity counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           cont : out  STD_LOGIC_VECTOR (2 downto 0));
end counter;

architecture Behavioral of counter is

signal counter : unsigned (2 downto 0) := "000";

begin

process (clk)
begin
	if clk'event and clk = '1' then
		if reset = '0' then
			counter <= "000";
		elsif WR_CONT > "000" then
			if counter = "000" then
				counter <= WR_CONT - "001";
			elsif stop = '0' then
				counter <= counter - "001";
			end if;
		end if;
	end if;
end process;

cont <= std_logic_vector(counter);

end Behavioral;

