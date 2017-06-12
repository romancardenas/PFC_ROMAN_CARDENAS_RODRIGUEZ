library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;
use work.CoeffConstants.all;

entity Coeff_selector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Index_in : in  STD_LOGIC_VECTOR (9 downto 0);
           Coeff_out : out  CoeffPhase);
end Coeff_selector;

architecture Behavioral of Coeff_selector is

signal coeff_out_s : CoeffPhase := (others => (others => '0'));

begin
	coeff_selector : process (clk)
	variable coeff_tap : CoeffArray;
	variable i : integer := 0; 
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				coeff_out_s <= (others => "000000000000000000");
				coeff_out <= (others => "000000000000000000");
			else
				for i in 0 to TAP-1 loop	
					coeff_tap := coeffs(i);
					coeff_out_s(i)<= coeff_tap(to_integer(unsigned(Index_in)));	
				end loop;
				coeff_out <= coeff_out_s;
			end if;
		end if;
	end process;
end Behavioral;

