library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.ReSamplerTypes.all;
use work.CoeffConstants.all;

entity Resampler is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset: in STD_LOGIC;
			  clk : in  STD_LOGIC;
			  valid_in : in STD_LOGIC;
			  earth_phase: in STD_LOGIC_VECTOR (9 downto 0);
			  ERD_up, ERD_down : in std_logic;
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
				 clk : in STD_LOGIC;
				 data_out : out DelayArray);
	end component;
	
	component selector is
		Port ( data_in : in  DelayArray;
				 s_ph : in STD_LOGIC_VECTOR (1 downto 0);
				 data_out : out  SelectedArray);
	end component;
	
	component selector_delayer is
   Port ( sel_in : in STD_LOGIC_VECTOR (1 downto 0);
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          sel_out : out  STD_LOGIC_VECTOR (1 downto 0));
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
					clk : in STD_LOGIC;
					data_out : out  STD_LOGIC_VECTOR (31 downto 0));
	end component ;
	
	component valid_delayer is
   Port ( data_in : in  STD_LOGIC;
          reset : in STD_LOGIC;
			 clk : in  STD_LOGIC;
          data_out : out  STD_LOGIC);
	end component;
	
	component earth_rotation is
    Port ( clk : in std_logic;
			  phase_in : in  std_logic_vector(9 downto 0);
			  phase_earth : in std_logic_vector(9 downto 0);
			  phase_read : in std_logic;
			  ERD_up : in std_logic;
			  ERD_down : in std_logic;
			  FIFO_read : out std_logic;
           phase_out : out  std_logic_vector(9 downto 0);
			  selector : out std_logic_vector (1 downto 0));
	end component;
	
	signal phase : unsigned (41 downto 0) := (others => '0');
	signal phase_selected, phase_corrected : std_logic_vector(9 downto 0) := (others => '0');
	signal data_history, data_history_d : DelayArray;
	signal data_selected : SelectedArray;
	signal valid_count : integer range 0 to TAP := 0;
	signal fifo_read_s, fifo_read_f : STD_LOGIC := '0';
	signal adder_input, mult_data : MultArray := (others => "00000000000000000000000000");
	signal data_out_s : STD_LOGIC_VECTOR (31 downto 0);
	signal sample_sel, sample_sel_d : STD_LOGIC_VECTOR (1 downto 0);
	signal coeff_selected : CoeffPhase :=(others => "000000000000000000");
	signal coeff_selected_d :CoeffPhase :=(others => "000000000000000000");
	signal valid_out_s : std_logic;
	
begin

	DELAY: delayer
	port map (data_in  => data_in,
				 enable => fifo_read_f,
				 reset => reset,
				 clk      => clk,
				 data_out => data_history);
				 
	DATA_DELAY: input_delayer
	port map (data_in  => data_history,
				 reset => reset,
				 clk      => clk,
				 data_out => data_history_d);
	
	SELECTION: Selector
	port map (data_in => data_history_d,
				 s_ph => sample_sel_d,
				 data_out => data_selected);
	SELECTOR_DELAY: Selector_delayer
	Port map ( sel_in => sample_sel,
          reset => reset,
			 clk => clk,
          sel_out => sample_sel_d);
	
	EARTH: earth_rotation
    Port map ( clk => clk,
					phase_in => phase_selected,
					phase_earth => earth_phase,
					phase_read => fifo_read_s,
					ERD_up => ERD_up,
					ERD_down => ERD_down,
					FIFO_read => fifo_read_f,
					phase_out => phase_corrected,
					selector => sample_sel);
	
	OUT_DELAY : out_delayer
	port map (data_in  => data_out_s,
				 reset => reset,
				 clk      => clk,
				 data_out => data_out);
	
	COEFF_DELAY : coeff_delayer
	port map (data_in => coeff_selected,
				 reset => reset,
				 clk=> clk,
				 data_out => coeff_selected_d);
				 
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

	filter: process (clk)
	
	variable data_out_v : multArray;
	variable coeff_tap : CoeffArray;
	variable i : integer := 0;
		
	begin
		if (clk'event and clk='1') then
			data_out_v := (others => "00000000000000000000000000");
			for i in 0 to TAP - 1 loop	
				data_out_v(i) := (signed(data_selected(i)) * signed(coeff_selected_d(i)));	
			end loop;
			mult_data <= data_out_v;
		end if;
	end process;
	
	coeff_selector : process (clk)
	variable coeff_tap : CoeffArray;
	variable i : integer := 0;
	
	begin
		if clk'event and clk = '0' then
			if reset = '0' then
				coeff_selected <= (others => "000000000000000000");
			else
				for i in 0 to TAP-1 loop	
					coeff_tap := coeffs(i);
					coeff_selected(i)<= coeff_tap(to_integer(unsigned(phase_corrected)));	
				end loop;
			end if;
		end if;
	end process;

	ph_update: process (clk)
	
	variable vphase : unsigned(41 downto 0) := (others=>'0');
	variable i : integer := 0;
	begin
		if (clk'event and clk='1') then	
			if reset = '0' then
				phase <=(others=>'0');
			else
				vphase := phase + FOE;
				phase <= vphase;
				phase_selected <= std_logic_vector(vphase(41 downto 32));
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

	
		fifo_read <= fifo_read_f;

	
end Behavioral;