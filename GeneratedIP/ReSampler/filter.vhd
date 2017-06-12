library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.ReSamplerTypes.all;
use work.CoeffConstants.all;

entity filter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DelayArray;
           Index_in : in  STD_LOGIC_VECTOR (9 downto 0);
			  valid_in : in STD_LOGIC;
           Data_out : out  ArrayOuts;
			  Valid_out : out STD_LOGIC);
end filter;

architecture Behavioral of filter is

component data_delayer is
		Port ( data_in : in  DelayArray;
				 reset : in STD_LOGIC;
			    clk : in  STD_LOGIC;
				 data_out : out  DelayArray);
end component;
	
component Coeff_selector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Index_in : in  STD_LOGIC_VECTOR (9 downto 0);
           Coeff_out : out  CoeffPhase);
end component;	

component adder56x26 is
    Port ( data_in : in  MultArray;
			  reset: in STD_LOGIC;
			  clk : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component out_delayer is
   Port ( data_in : in  Arrayouts;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  Arrayouts);
end component;

component validation is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           valid_in : in  STD_LOGIC;
           valid_out : out  STD_LOGIC);
end component;
	
signal data_array : DelayArray := (others => "00000000");
signal coeffs : CoeffPhase := (others => "000000000000000000");
signal mult_data : multArray := (others => (others => '0'));
signal data_out_s : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin

	DATA_DELAY : data_delayer
	port map (data_in  => Data_in,
				 reset    => reset,
				 clk      => clk,
				 data_out => data_array);
				 
	COEFF_SEL : Coeff_selector
    port map ( clk       => clk, 
				   reset     => reset,
               Index_in  => Index_in,
               Coeff_out => coeffs);
			  
	SUM : adder56x26
    port map ( data_in  => mult_data,
			      reset    => reset,
			      clk      => clk,
               data_out => data_out_s);
			   
	OUT_DELAY : out_delayer
   port map ( data_in  => data_out_s,
              reset    => reset,
			     clk      => clk,
              data_out => data_out);
				  
	VALID : validation
   Port map ( clk => clk,
           reset => reset,
           valid_in => valid_in,
           valid_out => valid_out);
	
	filter: process (clk)
	
	variable data_out_v : multArray;
	variable coeff_tap : CoeffArray;
	variable i : integer := 0;
		
	begin
		if (clk'event and clk='1') then
			data_out_v := (others => "00000000000000000000000000");
			if reset = '1' then
				for i in 0 to TAP - 1 loop	
					data_out_v(i) := (signed(data_array(i)) * signed(coeffs(i)));	
				end loop;
				mult_data <= data_out_v;
			end if;
		end if;
	end process;

end Behavioral;

