----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:07 02/16/2017 
-- Design Name: 
-- Module Name:    In_Delay - Behavioral 
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
use work.ReSamplerTypes.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity In_Delay is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_In : in  DataInArray;
           Data_out : out  DataInArray);
end In_Delay;

architecture Behavioral of In_Delay is

begin

	Delay : process(clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				Data_out <= (others => (others => '0'));
			else
				Data_out <= Data_In;
			end if;
		end if;
	end process;

end Behavioral;