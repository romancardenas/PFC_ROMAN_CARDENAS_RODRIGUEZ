----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:54:44 02/09/2017 
-- Design Name: 
-- Module Name:    Phase - Behavioral 
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

use work.ResamplerTypes.all; 

entity Phase is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  phase_earth : in STD_LOGIC_VECTOR(9 downto 0);
           CoeffIndex : out  PSA;
           fifo_read : out  STD_LOGIC_VECTOR(2 downto 0));
end Phase;

architecture Behavioral of Phase is

signal phase : std_logic_vector (41 downto 0) := (others => '0');
signal earthprev : std_logic_vector (9 downto 0) := (others => '0');

begin

	ph_update: process (clk)
		variable vphase : unsigned(44 downto 0) := (others=>'0');
		begin
		if (clk'event and clk='1') then	
			if reset = '0' then
				phase <= (others => '0');
				fifo_read <= (others => '0');
			else
				vphase := unsigned(phase) + (FOE & "000");
				vphase := unsigned(to_unsigned(to_Integer(vphase(44 downto 32)) + to_Integer(signed(phase_earth)) - to_Integer(signed(earthprev)),13) & vphase(31 downto 0)); -- Temas de signos
				phase <= std_logic_vector(vphase(41 downto 0));
				fifo_read <= std_logic_vector(vphase(44 downto 42));
				earthprev <= phase_earth; 
			end if;
		end if;
	end process;
	
	ph_distribute : process (clk)
		variable phases : PSA := (others => (others => '0'));
		variable i : integer := 0;
		begin
		if clk'event and clk = '1' then
			if reset = '0' then
				CoeffIndex <= (others => (others => '0'));
			else
				phases(0) := "000" & phase;
				for i in 1 to nBanks -1 loop
					phases(i) := std_logic_vector(to_Unsigned((to_integer(unsigned(phases(0))) + (i * to_integer(FOE))), 45));
				end loop;
				CoeffIndex <= phases;
			end if;
		end if;
	end process; 
	
	
	
end Behavioral;
 
