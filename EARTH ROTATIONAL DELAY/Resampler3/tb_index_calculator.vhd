--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;

use work.ResamplerTypes.all;
 
ENTITY tb_index_calculator IS
END tb_index_calculator;
 
ARCHITECTURE behavior OF tb_index_calculator IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT index_calculator
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ERD : IN  std_logic_vector(9 downto 0);
         cont : IN  std_logic_vector(2 downto 0);
         stop : OUT  std_logic;
         index : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal ERD : std_logic_vector(9 downto 0) := (others => '0');
   signal cont : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal stop : std_logic;
   signal index : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: index_calculator PORT MAP (
          clk => clk,
          reset => reset,
          ERD => ERD,
          cont => cont,
          stop => stop,
          index => index
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

      wait;
   end process;
	
	cont_proc : process
	begin
		cont <= "000";
		wait for clk_period;
		cont <= "001";
		wait for clk_period;
	end process;

END;
