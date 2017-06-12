----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:14 02/13/2017 
-- Design Name: 
-- Module Name:    Selector - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.reSamplerTypes.all;

entity Selector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DataInArray;
           Coeff_in : in  PSA;
           Data_out : out  BanksArray;
           Coeff_out : out  CoeffBank);
end Selector;

architecture Behavioral of Selector is

begin

data_sel : process(clk)
variable i, j : integer := 0;
variable aux : integer := 0;
variable v_data_out : BanksArray;
variable v_coeff_out : CoeffBank;
begin
	if clk'event and clk = '1' then
		if reset = '0' then
			v_data_out := (others => (others => (others => '0')));
			v_coeff_out := (others => (others => '0'));
		else 
			for i in 0 to nBanks - 1 loop
				aux := to_integer(unsigned(Coeff_in(i)(44 downto 42)));
				v_coeff_out(i) := Coeff_in(i)(41 downto 32);
				for j in 0 to nBanks - 1 loop
					v_data_out(i)(j) := Data_in(nBanks - 1 - aux + j); -- Recordar la estructura de seleccion
				end loop;
			end loop;
			data_out <= v_data_out;
			coeff_out <= v_coeff_out;
		end if;
	end if;
end process;

end Behavioral;

