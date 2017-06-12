LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_calc_module IS
END tb_calc_module;
 
ARCHITECTURE behavior OF tb_calc_module IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT calc_module
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         Data_in : IN  std_logic_vector(7 downto 0);
         ERD : IN  std_logic_vector(9 downto 0);
         FIFO_read : OUT  std_logic;
         FIFO_write : OUT  std_logic;
         Data_out : OUT  std_logic_vector(0 to 55);
         Index_out : OUT  std_logic_vector(9 downto 0);
         Data_valid : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal Data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal ERD : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal FIFO_read : std_logic;
   signal FIFO_write : std_logic;
   signal Data_out : std_logic_vector(0 to 55);
   signal Index_out : std_logic_vector(9 downto 0);
   signal Data_valid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: calc_module PORT MAP (
          clk => clk,
          reset => reset,
          Data_in => Data_in,
          ERD => ERD,
          FIFO_read => FIFO_read,
          FIFO_write => FIFO_write,
          Data_out => Data_out,
          Index_out => Index_out,
          Data_valid => Data_valid
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
