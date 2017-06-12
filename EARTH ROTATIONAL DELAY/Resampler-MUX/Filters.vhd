library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;
use work.CoeffConstants.all;

entity Filters is
	Port( clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			data_in : in FilterArray;
			CoeffIndex : in STD_LOGIC_VECTOR(9 downto 0);
			data_out : out multArray);
end Filters;

architecture Behavioral of Filters is

signal historic : HistoryArray := (others => (others => "00000000"));

-- Preguntar acerca de la utilidad de esta señal
-- signal data_out_s : multArray := (others => "00000000000000000000000000");

begin

	refresh : process (clk)
	variable i : integer := 0;
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				historic <= (others => (others => "00000000"));
			else
				historic(0) <= data_in;
				for i in 1 to nRaws - 1 loop
					historic(i) <= historic(i -1);
				end loop;
			end if;
		end if;
	end process;
	
	filter : process (clk)
	variable data_out_v : multArray;
	variable coeff_tap : CoeffArray;
	variable i, j : integer := 0;
	begin
		if clk'event and clk = '1' then
			data_out_v := (others => "00000000000000000000000000");
			for j in 0 to nRaws - 1 loop
				for i in 0 to nBanks - 1 loop
					coeff_tap := coeffs(i + j*8);
					data_out_v(i + j*8) := (signed(historic(j)(i)) * signed(coeff_tap(to_integer(unsigned(CoeffIndex)))));
				end loop;
			end loop;
			-- data_out_s <= data_out_v;
			data_out <= data_out_v;
		end if;
	end process;
	
	-- data_out <= data_out_s;
end Behavioral;