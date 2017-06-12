library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplerTypes.all;

entity data_buffer is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_read : in  STD_LOGIC;
           Data_in : in  DelayItem;
           Data_out : out DelayArray);
end data_buffer;

architecture Behavioral of data_buffer is

signal story : BufferArray := (others => "00000000");

begin

	process (clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				story <= (others => "00000000");
			elsif Data_read = '1' then
				story(0) <= Data_in;
				for i in 1 to TAP - 2 loop
					story(i) <= story(i - 1);
				end loop;
			end if;
		end if;
	end process;
	
	process (data_in, story)
	begin
		Data_out(0) <= Data_in;
		for i in 1 to TAP -1 loop
			Data_out(i) <= story(i - 1);
		end loop;
	end process;

end Behavioral;

