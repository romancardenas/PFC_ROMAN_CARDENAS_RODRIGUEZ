library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplerTypes.all;

entity top2 is
    Port ( clk1 : in  STD_LOGIC;
	        clk2 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayItem;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           Data_out : out  Arrayouts;
           FIFO_read : out  STD_LOGIC;
           Valid_out : out  STD_LOGIC);
end top2;

architecture Behavioral of top2 is

component calc_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayItem;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           FIFO_read : out  STD_LOGIC;
           FIFO_write : out  STD_LOGIC;
           Data_out : out  DelayArray;
           Index_out : out  STD_LOGIC_VECTOR (9 downto 0);
           Data_valid : out  STD_LOGIC);
end component;

component filter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayArray;
           Index_in : in  STD_LOGIC_VECTOR (9 downto 0);
			  valid_in : in STD_LOGIC;
           Data_out : out  ArrayOuts;
			  Valid_out : out STD_LOGIC);
end component;

component dual_FIFO is
  Port (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(458 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(458 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
end component;

signal data_i0, data_i1 : DelayArray;
signal index_i0, index_i1 : std_logic_vector (9 downto 0);
signal valid_i0, valid_i1 : std_logic;
signal data0, data1 : std_logic_vector (458 downto 0);
signal read0, read1 : std_logic;
signal write0 : std_logic;

begin

	MOD1 : calc_module
   Port map (clk => clk1,
           reset => reset,
           Data_in => Data_in,
           ERD => ERD,
           FIFO_read => FIFO_read,
           FIFO_write => write0,
           Data_out => data_i0,
           Index_out => index_i0,
           Data_valid => valid_i0);
			  
	MOD2 : filter 
   Port map ( clk => clk2,
           reset => reset,
           Data_in => data_i1,
           Index_in => index_i1,
			  valid_in => valid_i1,
           Data_out => Data_out,
			  Valid_out => Valid_out);

   MOD4 : dual_FIFO
   Port map ( rst => reset,
			  wr_clk => clk1,
           rd_clk => clk2,
           din => data0,
           wr_en => write0,
           rd_en => valid_i1,
           dout => data1,
           full => open,
           empty => open);
			  
	PREP0 : process (data_i0, index_i0)
	begin
		for i in 0 to TAP -1 loop
			for j in 0 to 7 loop
				data0 (j + 8 * i) <= data_i0(i)(j);
			end loop;
		end loop;
		for k in 0 to 9 loop
			data0 (k + 8 * TAP) <= index_i0(k);
		end loop;
		data0 (458) <= valid_i0;
	end process;
	
	PREP1 : process (data1)
	begin
		for i in 0 to TAP -1 loop
			for j in 0 to 7 loop
				data_i1(i)(j) <= data1(j + 8 * i);
			end loop;
		end loop;
		for k in 0 to 9 loop
			index_i1(k) <= data1(k + 8 * TAP);
		end loop;
		valid_i1 <= data1(458);
	end process;

end Behavioral;
