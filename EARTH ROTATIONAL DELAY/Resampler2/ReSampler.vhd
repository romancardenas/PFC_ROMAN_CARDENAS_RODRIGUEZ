
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
	
	component out_delayer is
		Port ( data_in : in  STD_LOGIC_VECTOR(31 downto 0);
				 reset : in STD_LOGIC;
				 clk : in  STD_LOGIC;
				 data_out : out  STD_LOGIC_VECTOR(31 downto 0));
	end component;
	
	component adder56x26 is
	    Port (  data_in : in  MultArray;
					reset: in STD_LOGIC;
					--clk : in  STD_LOGIC;
					data_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component ;
	
	signal phase : std_logic_vector (41 downto 0) :=(others=>'0');
	signal phase_selected : std_logic_vector(9 downto 0) := (others=>'0');
	signal data_history : DelayArray;
	signal valid_count : integer range 0 to TAP := 0;
	signal fifo_read_s : STD_LOGIC := '0';
	signal adder_input : MultArray := (others=>"00000000000000000000000000");
	signal data_out_s : STD_LOGIC_VECTOR (31 downto 0);
	signal earthprev : std_logic_vector (9 downto 0) := (others => '0');
	
begin

	DELAY: delayer
	port map (data_in  => data_in,
				 enable => fifo_read_s,
				 reset => reset,
				 clk      => clk,
				 data_out => data_history);
	
	OUT_DELAY : out_delayer
	port map (data_in  => data_out_s,
				 reset => reset,
				 clk      => clk,
				 data_out => data_out);
				 
	ADDER : adder56x26
	port map (data_in => adder_input,
				 reset => reset,
				 --clk => clk,
				 data_out => data_out_s);

	filter: process (reset, clk)
		variable data_out_v : multArray;
		variable coeff_tap : CoeffArray;
		variable i : integer := 0;
		
	begin
		if (clk'event and clk='1') then
			--if reset = '0' then
				--data_out <= (others => '0');
			--else
				data_out_v := (others => "00000000000000000000000000");
				for i in 0 to TAP-1 loop	
					coeff_tap := coeffs(i);
					data_out_v(i) :=(signed(data_history(i)) * signed(coeff_tap(to_integer(unsigned(phase_selected)))));	
				end loop;
				adder_input <= data_out_v;
			--end if;	
		end if;
	end process;
	
	--data_out<=data_out_s;

 	

	ph_update: process (reset, clk)
		variable vphase : unsigned(41 downto 0) := (others=>'0');
		variable i : integer := 0;
		begin
		if (clk'event and clk='1') then	
			if reset = '0' then
				phase <=(others=>'0');
			else
				-- Cambia la forma de aumentar la fase
				vphase := unsigned(phase) + unsigned(to_unsigned(to_Integer(FOE(41 downto 32)) + to_Integer(signed(phase_earth)) - to_Integer(signed(earthprev)),10) & FOE(31 downto 0)); -- Temas de signos
				phase <= std_logic_vector(vphase);
				
				-- Se actualiza el registro de la fase terrestre
				earthprev <= phase_earth;
				phase_selected <= std_logic_vector(vphase(41 downto 32)) ;
			end if;
		end if;
	end process;
	
	valid: process (reset, clk)
	begin
		if reset = '0' then
			valid_out <= '0';
			valid_count <= 0;		
		elsif (clk'event and clk='1') then
			if (valid_in = '1') then
				if (valid_count = TAP-1) then
					valid_out <= '1';
				else
					valid_out <= '0';
					valid_count <= valid_count + 1;
				end if;
			else
				valid_out <= '0';
				valid_count <= 0;
			end if;
		end if;		
	end process;
	
	fifo_read_s <= '1' when reset = '0'  else
						'0' when phase < "00" & FDIFF else
				      '1';

	fifo_read <= fifo_read_s;

	
end Behavioral;

