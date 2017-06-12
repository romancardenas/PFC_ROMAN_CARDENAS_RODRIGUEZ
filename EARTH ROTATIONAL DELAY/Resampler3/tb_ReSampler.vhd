-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.ReSamplerTypes.all;
  use work.CoeffConstants.all;
  use work.inputs_test.all;
  use work.Outputs_test.all; 
  
  
  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
    component top1 is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  reset : in STD_LOGIC;
			  clk : in  STD_LOGIC;
			  --valid_in : in STD_LOGIC;
			  ERD : in STD_LOGIC_VECTOR (9 downto 0);
			  valid_out : out STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  fifo_read : out STD_LOGIC);
	end component;
	
	--inputs
			signal data_in : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
			signal reset :  std_logic := '0';	
			signal clk :  std_logic := '0';			
			signal valid_in : STD_LOGIC := '1';
			signal phase_earth : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
			
	--outputs
			signal valid_out : std_logic := '0';
			signal data_out : STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
			signal fifo_read : std_logic := '0';

   --Clock period definitions
			constant clk_period : time :=  1 us;

	--others
			signal i : integer := TAP/2;
			signal j : integer := 0;
			signal u : integer := 0;
			signal x : integer := 0;
			signal correct : std_logic := '0';
			signal compare : OutputArray := (others=>"00000000000000000000000000000000");
	
  BEGIN

  -- Component Instantiation
          Resamplr: top1 PORT MAP(
                data_in => data_in,
					 reset => reset,
					 clk => clk,
					 --valid_in => valid_in,
					 ERD => phase_earth,
				  	 valid_out => valid_out,
					 data_out => data_out,
					 fifo_read => fifo_read
          );

   -- Clock process definitions

	reset <= '0', '1' after 1.2us;

	clk_process :process
   begin
		clk <= '0';
		wait for (clk_period/2);
		clk <= '1';
		wait for (clk_period/2);
   end process;
	
  --  Stimulus
  
	tb_in : PROCESS (reset, clk)
     BEGIN
	   if reset = '0' then
			i <= TAP/2;
		elsif rising_edge(clk) then
	 		--elsif rising_edge(clk) then
--				if reset = '0' then
--					i <= TAP/2;
			--if (i<FO)then
				if (fifo_read = '1') then
					i <= i +1;
				end if;
			--else 
			--	i <= TAP/2;
			--end if;
      end if;

     END PROCESS tb_in;

  data_in <= inputs(i);

	tb_out : PROCESS (reset, clk)
     BEGIN
		if rising_edge(clk) then
			if reset = '0' then
				j <= 0;
				u <= 0;
				x <= 0;
			else
				u <=j;
				j <= j+1;
				if j > 12 then
					x <= x+1;
				end if;
			end if;
			
		end if;

     END PROCESS tb_out;

	tb_compare : PROCESS (reset, clk)
   BEGIN
	   if reset = '0' then
			compare <= (others=>"00000000000000000000000000000000");
		elsif rising_edge(clk) then
			compare(u) <= data_out;
		end if;

     END PROCESS tb_compare;

	correct <= '1' when outputs(x) = compare(x+11)
						else '0';
	
--	correct <= '1' when outputs(u) = data_out
--						else '0';
	

  END;
