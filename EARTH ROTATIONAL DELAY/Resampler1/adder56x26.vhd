----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:12:27 06/30/2016 
-- Design Name: 
-- Module Name:    adder56x26 - Behavioral 
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
use ieee.std_logic_unsigned.all;
use work.ReSamplerTypes.all;
use work.CoeffConstants.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder56x26 is
    Port ( data_in : in  MultArray;
			  reset: in STD_LOGIC;
			  --clk : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end adder56x26 ;

architecture Behavioral of adder56x26 is

	signal data_out_s : STD_LOGIC_VECTOR (31 downto 0);

begin

--adder: process (reset, clk)
adder: process (data_in,reset)

	variable sum_value : signed(31 downto 0);
	variable sum_step_1 : sum_step1;
	variable sum_step_2 : sum_step2;
	variable sum_step_3 : sum_step3;
	variable sum_step_4 : sum_step4;
	variable sum_step_5 : sum_step5;


	begin
	--if rising_edge(clk) then
		if reset = '0' then
			--data_out_s <= (others => '0');
			sum_value :=(others => '0');
		else
			sum_value :=(others => '0');
			sum_step_1 := (others => "00000000000000000000000000000000");
			sum_step_2 := (others => "00000000000000000000000000000000");
			sum_step_3 := (others => "00000000000000000000000000000000");
			sum_step_4 := (others => "00000000000000000000000000000000");
			sum_step_5 := (others => "00000000000000000000000000000000");


			for i in 0 to (28-1) loop --0 to TAP/2-1
				sum_step_1(i) :=  "00000000000000000000000000000000"+ data_in((TAP/2)+i) + data_in(i);
			end loop;
			
			for i in 0 to (14-1) loop
				sum_step_2(i) :=  sum_step_1(14+i) + sum_step_1(i);
			end loop;
			
			for i in 0 to (7-1) loop
				sum_step_3(i) :=  sum_step_2(7+i) + sum_step_2(i);
			end loop;
			
			sum_step_4(3) := sum_step_3(3);
			for i in 0 to (3-1) loop
				sum_step_4(i) :=  sum_step_3(4+i) + sum_step_3(i);
			end loop;
			
			for i in 0 to (2-1) loop
				sum_step_5(i) :=  sum_step_4(2+i) + sum_step_4(i);
			end loop;
			
			sum_value := sum_step_5(0) + sum_step_5(1);			
		end if;
	
		data_out_s <= STD_LOGIC_VECTOR(sum_value);
--	end if;
end process;

data_out <= data_out_s;

end Behavioral;

