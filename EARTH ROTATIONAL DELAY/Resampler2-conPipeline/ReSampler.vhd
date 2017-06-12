----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:55:30 04/04/2016 
-- Design Name: 
-- Module Name:    ReSampler - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use work.ReSamplerTypes.all;
use work.CoeffConstants.all;


entity ReSampler is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset: in STD_LOGIC;
			  clk : in  STD_LOGIC;
			  valid_in : in STD_LOGIC;
			  phase_earth : in STD_LOGIC_VECTOR (9 downto 0);
			  valid_out : out STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  fifo_read : out STD_LOGIC);
end ReSampler;

architecture Behavioral of ReSampler is

	component delayer is
		Port ( data_in : in  DelayItem;
				 enable : in STD_LOGIC;
				 reset : in STD_LOGIC;
				 clk : in  STD_LOGIC;
				 data_out : out DelayArray);
	end component;
	
	component input_delayer is
   Port ( data_in : in DelayArray;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  DelayArray);
	end component;

	
	component out_delayer is
   Port ( data_in : in  STD_LOGIC_VECTOR(31 downto 0);
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  STD_LOGIC_VECTOR(31 downto 0));
	end component;


	component coeff_delayer is
		Port ( data_in : in  CoeffPhase;
				 reset : in STD_LOGIC;
				 clk : in  STD_LOGIC;
				 data_out : out  CoeffPhase);
	end component;
	
	
	component Mult_delayer is
   Port ( data_in : in  MultArray;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  MultArray);
	end component;
	
	
	component adder56x26 is
	    Port (  data_in : in  MultArray;
					reset: in STD_LOGIC;
					clk : in  STD_LOGIC;
					data_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component ;
	
	component valid_delayer is
   Port ( data_in : in  STD_LOGIC;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  STD_LOGIC);
	end component;
	
	signal phase : std_logic_vector (41 downto 0) :=(others=>'0');
	signal phase_selected : std_logic_vector(9 downto 0) := (others=>'0');
	signal coeff_selected : CoeffPhase :=(others => "000000000000000000");
	signal coeff_selected_d :CoeffPhase :=(others => "000000000000000000");
	signal data_history : DelayArray;
	signal data_history_d : DelayArray;
	signal valid_count : integer range 0 to TAP := 0;
	signal fifo_read_s : STD_LOGIC := '0';
	signal mult_data : MultArray := (others=>"00000000000000000000000000");
	signal adder_input : MultArray := (others=>"00000000000000000000000000");
	signal data_out_s : STD_LOGIC_VECTOR (31 downto 0);
	signal valid_out_s : STD_LOGIC := '0';
	signal valid_out_d : STD_LOGIC := '0';
	
	signal earthprev : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	
	
begin

	DELAY: delayer
	port map (data_in  => data_in,
				 enable => fifo_read_s,
				 reset => reset,
				 clk      => clk,
				 data_out => data_history);
	
	DATA_DELAY: input_delayer
	port map (data_in  => data_history,
				 reset => reset,
				 clk      => clk,
				 data_out => data_history_d);
				 
	COEFF_DELAY : coeff_delayer
	port map (data_in => coeff_selected,
				 reset => reset,
				 clk=> clk,
				 data_out => coeff_selected_d);

	OUT_DELAY : out_delayer 
	port map (data_in => data_out_s,
				 reset => reset,
				 clk=> clk,
				 data_out => data_out);
				 
	MULT_DELAY : mult_delayer
	port map (data_in => mult_data,
				 reset => reset,
				 clk=> clk,
				 data_out => adder_input);
	
	ADDER : adder56x26
	port map (data_in => adder_input,
				 reset => reset,
				 clk => clk,
				 data_out => data_out_s);
				 
	VALID_DELAY : valid_delayer
	port map (data_in => valid_out_s,
				 reset => reset,
				 clk => clk,
				 data_out => valid_out);
				 
--	filter: process (reset, clk)
--		variable data_out_v : multArray;
--		variable coeff_tap : CoeffArray;
--		variable i : integer := 0;
--		
--	begin
--		if (clk'event and clk='1') then
--			if reset = '0' then
--				data_out <= (others => '0');
--			else
--				data_out_v := (others => "00000000000000000000000000");
--				for i in 0 to TAP-1 loop	
--					coeff_tap := coeffs(i);
--					data_out_v(i) :=(signed(data_history(i)) * signed(coeff_tap(to_integer(unsigned(phase_selected)))));	
--				end loop;
--				mult_data <= data_out_v;
--				--adder_input <= data_out_v;
--			end if;
--			data_out<=data_out_s;
--		end if;
--	end process;

	filter: process ( clk)
		variable data_out_v : multArray;
		variable coeff_tap : CoeffArray;
		variable i : integer := 0;
		
	begin
		if (clk'event and clk='1') then
--			if reset = '0' then
--				data_out <= (others => '0');
--			else
				data_out_v := (others => "00000000000000000000000000");
				for i in 0 to TAP-1 loop	
					--coeff_tap := coeffs(i);
					data_out_v(i) :=(signed(data_history_d(i)) * signed(coeff_selected_d(i)));	
				end loop;
				mult_data <= data_out_v;
				--adder_input <= data_out_v;
--			end if;
			--data_out<=data_out_s;
		end if;
	end process;
--	data_out<=data_out_s;
	
		coef_selector: process (reset, clk)
		variable coeff_tap : CoeffArray;
		variable i : integer := 0;	
	begin
		if (clk'event and clk='1') then
			if reset = '0' then
				coeff_selected <=(others => "000000000000000000");
			else		
				for i in 0 to TAP-1 loop	
					coeff_tap := coeffs(i);
					coeff_selected(i)<= coeff_tap(to_integer(unsigned(phase_selected)));	
				end loop;
			end if;
		end if;
	end process;
	
	

	ph_update: process (reset, clk)
		variable vphase : unsigned(41 downto 0) := (others=>'0');
		variable i : integer := 0;
		begin
		if (clk'event and clk='1') then	
			if reset = '0' then
				phase <=(others=>'0');
			else
			vphase := unsigned(phase) + unsigned(to_unsigned(to_Integer(FOE(41 downto 32)) + to_Integer(signed(phase_earth)) - to_Integer(signed(earthprev)),10) & FOE(31 downto 0)); -- Temas de signos
			phase <= std_logic_vector(vphase);
			
			earthprev <= phase_earth;
			phase_selected <= std_logic_vector(vphase(41 downto 32));
		--	phase_selected <= vphase(29 downto 20);
			end if;
		end if;
	end process;
	
	valid: process (reset, clk)
	begin
		if reset = '0' then
			valid_out_s <= '0';
			valid_count <= 0;		
		elsif (clk'event and clk='1') then
			if (valid_in = '1') then
				if (valid_count = TAP-1) then
					valid_out_s <= '1';
				else
					valid_out_s <= '0';
					valid_count <= valid_count + 1;
				end if;
			else
				valid_out_s <= '0';
				valid_count <= 0;
			end if;
		end if;		
	end process;
	
	fifo_read_s <= '1' when reset = '0'  else
						'0' when unsigned(phase) < unsigned(FDIFF) else
				      '1';

	fifo_read <= fifo_read_s;

	
end Behavioral;

