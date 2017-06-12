--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:51 02/21/2017
-- Design Name:   
-- Module Name:   D:/Resampler-MUX/tb_filters.vhd
-- Project Name:  Resampler-MUX
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Filters
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ReSamplerTypes.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_filters IS
END tb_filters;
 
ARCHITECTURE behavior OF tb_filters IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Filters
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         data_in : IN  FilterArray;
         CoeffIndex : IN  std_logic_vector(9 downto 0);
         data_out : OUT  multArray
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_in : FilterArray := (others => "00000000");
   signal CoeffIndex : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal data_out : multArray;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Filters PORT MAP (
          clk => clk,
          reset => reset,
          data_in => data_in,
          CoeffIndex => CoeffIndex,
          data_out => data_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '1';

      wait for clk_period*10;

      -- insert stimulus here 
--		Data_in(0) <= "11111111"; 
--		Data_in(1) <= "11111110";
--		Data_in(2) <= "11111100";
--		Data_in(3) <= "11111000";
--		Data_in(4) <= "11110000";
--		Data_in(5) <= "11100000";
--		Data_in(6) <= "10000001";
		Data_in(7) <= "10101111";
		wait for clk_period;
		--CoeffIndex <= "1111111111";
		wait for clk_period;
		Data_in(0) <= "00000000";
		Data_in(1) <= "00000000";
		wait for clk_period;
		--CoeffIndex <= "0000001111";
		wait for clk_period;
		Data_in(7) <= "00010000";
		Data_in(5) <= "10000000";
      wait;
   end process;

END;
