----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:19:01 07/01/2016 
-- Design Name: 
-- Module Name:    step_delayer - Behavioral 
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
use work.ReSamplerTypes.all;

entity step_delayer is
   Port ( step_in1 : in  sum_step1;
			 step_in2 : in  sum_step2;
			 step_in3 : in  sum_step3;
			 step_in4 : in  sum_step4;
			 step_in5 : in  sum_step5;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
			 step_out1 : out sum_step1;
			 step_out2 : out sum_step2;
			 step_out3 : out sum_step3;
			 step_out4 : out sum_step4;
          step_out5 : out sum_step5);
end step_delayer;

architecture Behavioral of step_delayer is

signal content1 : sum_step1 :=(others => "00000000000000000000000000000000");
signal content2 : sum_step2 :=(others => "00000000000000000000000000000000");
signal content3 : sum_step3 :=(others => "00000000000000000000000000000000");
signal content4 : sum_step4 :=(others => "00000000000000000000000000000000");
signal content5 : sum_step5 :=(others => "00000000000000000000000000000000");

begin

	shift: process ( reset, clk)
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				content1 <= (others => "00000000000000000000000000000000");
				content2 <= (others => "00000000000000000000000000000000");
				content3 <= (others => "00000000000000000000000000000000");
				content4 <= (others => "00000000000000000000000000000000");
				content5 <= (others => "00000000000000000000000000000000");
			else
				content1 <= step_in1;
				content2 <= step_in2;
				content3 <= step_in3;
				content4 <= step_in4;
				content5 <= step_in5;
			end if;
		end if;
	end process;

	step_out1 <= content1;
	step_out2 <= content2;
	step_out3 <= content3;
	step_out4 <= content4;
	step_out5 <= content5;

end Behavioral;

