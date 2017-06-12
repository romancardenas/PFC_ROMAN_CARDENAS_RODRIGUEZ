library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity index_calculator is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           cont : in  STD_LOGIC_VECTOR (2 downto 0);
			  FOE : in STD_LOGIC_VECTOR (41 downto 0);
			  WR_CONT : in STD_LOGIC_VECTOR (2 downto 0);
           stop : out  STD_LOGIC;
           index : out  STD_LOGIC_VECTOR (9 downto 0));
end index_calculator;

architecture Behavioral of index_calculator is

signal index_h : std_logic_vector (42 downto 0) := (others => '0');
signal ERD_d : std_logic_vector (9 downto 0) := (others => '0');

begin

	ERD_r : process(clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				ERD_d <= (others => '0');
			else
				ERD_d <= ERD;
			end if;
		end if;
	end process;
	
	INDEX_r : process (clk)
	begin
		if clk'event and clk = '1' then
			if reset = '0' then
				index_h <= (others => '0');
			elsif (cont = "000" and index_h(42) = '0') or WR_CONT = "000" then
				index_h <= std_logic_vector(unsigned('0' & index_h(41 downto 0)) + unsigned('0' & FOE) + unsigned(std_logic_vector(to_signed(to_Integer(signed(ERD)) - to_Integer(signed(ERD_d)), 11) & "00000000000000000000000000000000")));
			else
				index_h <= std_logic_vector(unsigned('0' & index_h(41 downto 0)) + unsigned(std_logic_vector(to_signed(to_Integer(signed(ERD)) - to_Integer(signed(ERD_d)), 11) & "00000000000000000000000000000000")));
			end if;
		end if;
	end process;
	
	stop <= index_h(42);
	index <= index_h(41 downto 32);
end Behavioral;

