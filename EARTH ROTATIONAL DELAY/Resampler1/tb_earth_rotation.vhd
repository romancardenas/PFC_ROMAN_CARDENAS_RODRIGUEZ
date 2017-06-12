library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ReSamplerTypes.all;

ENTITY tb_Earth_Rotation is -- entity declaration
end tb_Earth_Rotation;

ARCHITECTURE tb of tb_Earth_Rotation is

--components
COMPONENT earth_rotation is
    Port ( clk : in std_logic;
			  phase_in : in  std_logic_vector(9 downto 0);
			  phase_earth : in std_logic_vector(9 downto 0);
			  phase_read : in std_logic;
			  ERD_up : in std_logic;
			  ERD_down : in std_logic;
			  FIFO_read : out std_logic;
           phase_out : out  std_logic_vector(9 downto 0);
			  selector : out std_logic_vector (1 downto 0));
end COMPONENT;

--inputs
signal T_phase_in, T_phase_earth : std_logic_vector (9 downto 0) := (others => '0');
signal T_clk : std_logic := '0';
signal T_phase_read, T_ERD_up, T_ERD_down : std_logic := '0';

--outputs
signal T_phase_out : std_logic_vector (9 downto 0);
signal T_selector : std_logic_vector (1 downto 0);
signal T_FIFO_read : std_logic := '0';

--clock period definitions
constant clk_period : time := 1 us;

BEGIN
	earth : earth_rotation PORT MAP(
				clk => T_clk,
				phase_in => T_phase_in,
				phase_earth => T_phase_earth,
				phase_read => T_phase_read,
				ERD_up => T_ERD_up,
				ERD_down => T_ERD_down,
				FIFO_read => T_FIFO_read,
				phase_out => T_phase_out,
				selector => T_selector);
	
	-- Clock process definitions
	
	clk_process : process
	begin
		T_clk <= '0';
		wait for (clk_period / 2);
		T_clk <= '1';
		wait for (clk_period / 2);
	end process;
	
	-- Stimulus process
	
	phase_process : process
	begin
		T_phase_in <= "1101101100"; --876 (No hay desbordamiento)
		T_phase_read <= '0';
		wait for 1 us;
		T_phase_in <= "1011010000"; --720 (Hay desbordamiento)
		T_phase_read <= '1';
		wait for 1 us;
		T_phase_in <= "1000111000"; --568 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0110100000"; --416 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0100001000"; --264 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0001110100"; --116 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "1111011100"; --988 (No hay desbordamiento)
		T_phase_read <= '0';
		
		wait for 1 us;
		T_phase_in <= "1101000100"; --836 (Hay desbordamiento)
		T_phase_read <= '1';
		wait for 1 us;
		T_phase_in <= "1010101100"; --684 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "1000010100"; --532 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0101111100"; --380 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0011100100"; --228 (Hay desbordamiento)
		wait for 1 us;
		T_phase_in <= "0001001100"; --76 (Hay desbordamiento)
		wait for 1 us;
	end process;
	
	earth_process : process
	begin
		T_phase_earth <= "0111111101"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "0111111110"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "0111111111"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "1000000000"; -- (Hay desbordamiento positivo)
		T_ERD_up <= '1';
		wait for 1 us;
		T_phase_earth <= "1000000001"; -- (No hay desbordamiento)
		T_ERD_up <= '0';
		wait for 1 us;
		T_phase_earth <= "1000000010"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "1000000011"; -- (No hay desbordamiento, se debe recompensar)
		
		wait for 1 us;
		T_phase_earth <= "1000000010"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "1000000001"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "1000000000"; -- (No hay desbordamiento)
		wait for 1 us;
		T_phase_earth <= "0111111111"; -- (Hay desbordamiento negativo)
		T_ERD_down <= '1';
		wait for 1 us;
		T_phase_earth <= "0111111110"; -- (No hay desbordamiento, se debe recompensar)
		T_ERD_down <= '0';
		wait for 1 us;
		T_phase_earth <= "0111111101"; -- (No hay desbordamiento)
		wait for 1 us;
	end process;
end tb;