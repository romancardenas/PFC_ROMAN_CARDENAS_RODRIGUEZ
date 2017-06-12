library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.ReSamplerTypes.all;

entity out_delayer is
   Port ( data_in : in  STD_LOGIC_VECTOR(31 downto 0);
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  STD_LOGIC_VECTOR(31 downto 0));
end out_delayer;

architecture Behavioral of out_delayer is

signal content : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin

	shift: process (clk)
	begin
		if (clk'event and clk = '1') then
			if reset = '0' then
				content <= (others => '0');
			else
				content <= data_in;
			end if;
		end if;
	end process;

	data_out <= content;

end Behavioral;

