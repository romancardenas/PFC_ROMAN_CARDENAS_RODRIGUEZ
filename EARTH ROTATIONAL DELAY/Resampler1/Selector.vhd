library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ReSamplerTypes.all;

entity selector is
    Port ( data_in : in  DelayArray;
			  s_ph : in STD_LOGIC_VECTOR (1 downto 0);
           data_out : out  SelectedArray);
end selector;

architecture Behavioral of selector is

signal data_out_s : SelectedArray;

begin
	sel: process (data_in,s_ph)

	begin
		for i in 0 to (TAP - 1) loop
			case s_ph is
			when "10" => -- For phase >= 1024
				data_out_s(i) <= data_in(i);
			when "11" => -- For phase < 0
				data_out_s(i) <= data_in(i + 2);
			when others => 
				data_out_s(i) <= data_in(i + 1);
			end case;
		end loop;

	end process;

	data_out <= data_out_s;

end Behavioral;