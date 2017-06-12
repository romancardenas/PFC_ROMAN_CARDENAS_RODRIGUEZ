library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ReSamplerTypes.all;

entity earth_rotation is
    Port ( clk : in std_logic;
			  phase_in : in  std_logic_vector(9 downto 0);
			  phase_earth : in std_logic_vector(9 downto 0);
			  phase_read : in std_logic;
			  ERD_up : in std_logic;
			  ERD_down : in std_logic;
			  FIFO_read : out std_logic;
           phase_out : out  std_logic_vector(9 downto 0);
			  selector : out std_logic_vector (1 downto 0));
end earth_rotation; 

architecture Behavioral of earth_rotation is

signal phase_earth_signed : signed(10 downto 0):= (others => '0');
signal phase_in_unsigned : unsigned(10 downto 0) := (others => '0');
signal phase_out_signed : signed(10 downto 0):= (others => '0');
signal selector_aux, sel : std_logic_vector (1 downto 0);
signal ERD_read, ERD_back : std_logic := '0';
signal FIFO_read_prev : std_logic;
signal FIFO_read_s : std_logic;

begin

	phase_in_unsigned <= resize(unsigned(phase_in), 11);
	phase_earth_signed <= resize(signed(phase_earth), 11);
	phase_out_signed <= to_signed(to_integer(phase_in_unsigned) + to_integer(phase_earth_signed), 11);
	
--	Overflow_set : process(ERD_up, ERD_read, phase_read, ERD_down, FIFO_read_prev, ERD_back)
--	begin
--		if ERD_up = '1' then
--			ERD_read <= '1';
--		elsif ERD_read = '1' and phase_read = '0' then
--			ERD_read <= '0';
--		end if;
--		if ERD_down = '1' then 
--			ERD_back <= '1';
--		elsif FIFO_read_prev = '1' and ERD_back = '1' then 
--			ERD_back <= '0';
--		end if;
--	end process;
	Overflow_set : process(clk)
	begin
		if clk'event and clk = '1' then
			phase_out <= std_logic_vector(phase_out_signed(9 downto 0));
			if ERD_up = '1' then
				ERD_read <= '1';
			elsif ERD_read = '1' and phase_read = '0' then
				ERD_read <= '0';
			end if;
			if ERD_down = '1' then 
				ERD_back <= '1';
			elsif FIFO_read_prev = '1' and ERD_back = '1' then 
				ERD_back <= '0';
			end if;
		end if;
	end process;
	
	FIFO_read_prev <= Phase_read or ERD_read;
	
	selector_aux <= std_logic_vector(phase_out_signed(10 downto 9));
--	selection : process (selector_aux, ERD_back, ERD_read, FIFO_read_s)
--	begin
--		sel <= "00";
--		if FIFO_read_s = '0' or(selector_aux = "10" and ERD_back = '0') or (selector_aux /= "11" and ERD_read = '1') then
--			sel <= "10";
--		elsif (selector_aux = "11" and ERD_read = '0') or (selector_aux /= "11" and ERD_back = '1') then
--			sel <= "11";
--		end if;
--	end process;
	selection : process (clk)
	begin
		if clk'event and clk = '1' then
		sel <= "00";
		if FIFO_read_s = '0' or(selector_aux = "10" and ERD_back = '0') or (selector_aux /= "11" and ERD_read = '1') then
			sel <= "10";
		elsif (selector_aux = "11" and ERD_read = '0') or (selector_aux /= "11" and ERD_back = '1') then
			sel <= "11";
		end if;
		end if;
	end process;

	selector <= sel;
	
	FIFO_read_s <= FIFO_read_prev and not(ERD_back);
	FIFO_read <= FIFO_read_s;
		
end Behavioral;