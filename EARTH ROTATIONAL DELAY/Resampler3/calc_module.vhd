library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;

entity calc_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayItem;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           FIFO_read : out  STD_LOGIC;
           FIFO_write : out  STD_LOGIC;
           Data_out : out  DelayArray;
           Index_out : out  STD_LOGIC_VECTOR (9 downto 0);
           Data_valid : out  STD_LOGIC);
end calc_module;

architecture Behavioral of calc_module is

component counter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           stop : in  STD_LOGIC;
           cont : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component data_buffer is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_read : in  STD_LOGIC;
           Data_in : in  DelayItem;
           Data_out : out DelayArray);
end component;

component index_calculator is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           cont : in  STD_LOGIC_VECTOR (2 downto 0);
           stop : out  STD_LOGIC;
           index : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

signal stop0, stop1 : std_logic := '0';
signal valid : std_logic := '0';
signal d_read : std_logic := '0';
signal index0, index1 : std_logic_vector (9 downto 0) := (others => '0');
signal cont0, cont1 : std_logic_vector (2 downto 0) := "000";

begin

	CONT_PROC : counter
	Port map ( clk => clk,
           reset => reset,
           stop => stop0,
           cont => cont0);
			  
	DATA_PROC : data_buffer
   Port map( clk => clk,
           reset => reset,
           Data_read => d_read,
           Data_in => data_in,
           Data_out => data_out);
	
	INDEX_PROC : index_calculator
   Port map( clk => clk,
           reset => reset,
           ERD => ERD,
           cont => cont0,
           stop => stop0,
           index => index0);
	
	VALID_PROC : process (clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				valid <= '0';
			else
				valid <= '1';
			end if;
		end if;
	end process;
	
	DELAY_PROC : process (clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				stop1 <= '0';
				index1 <= (others => '0');
				cont1 <= (others => '0');
			else
				stop1 <= stop0;
				index1 <= index0;
				cont1 <= cont0;
			end if;
		end if;
	end process;
	
	
	Index_out <= index1;
	Data_valid <= valid;
	
	d_read <= '1' when valid = '1' and (stop0 = '1' or unsigned(WR_CONT) > "000") else '0';
	FIFO_read <= d_read;
	
	FIFO_write <= '1' when valid = '1' and ((stop1 = '0' and cont1 = "000") or WR_CONT = "000") else '0'; 
	
end Behavioral;

