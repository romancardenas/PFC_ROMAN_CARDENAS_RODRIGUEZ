library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.ReSamplerTypes.all;

entity top1 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayItem;
           ERD : in  STD_LOGIC_VECTOR (9 downto 0);
           Data_out : out  Arrayouts;
           FIFO_read : out  STD_LOGIC;
           Valid_out : out  STD_LOGIC);
end top1;

architecture Behavioral of top1 is

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

signal data_i : DelayArray;
signal index_i : std_logic_vector (9 downto 0);
signal valid_i : std_logic;

begin

	MOD1 : calc_module
   Port map (clk => clk,
           reset => reset,
           Data_in => Data_in,
           ERD => ERD,
           FIFO_read => FIFO_read,
           FIFO_write => valid_i,
           Data_out => data_i,
           Index_out => index_i,
           Data_valid => open);
			  
	MOD2 : filter 
   Port map ( clk => clk,
           reset => reset,
           Data_in => data_i,
           Index_in => index_i,
			  valid_in => valid_i,
           Data_out => Data_out,
			  Valid_out => Valid_out);
			  
end Behavioral;

