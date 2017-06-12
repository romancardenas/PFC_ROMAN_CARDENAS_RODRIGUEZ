----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:23:31 02/07/2017 
-- Design Name: 
-- Module Name:    Resampler - Behavioral 
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

use work.resamplerTypes.ALL;

entity Resampler is
	Port (clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			phase_earth : in STD_LOGIC_VECTOR (9 downto 0);
			Data_in : in DataInArray;
			fifo_read : out STD_LOGIC_VECTOR (2 downto 0);
			Data_out : out OutArray); --TODO Definir este tipo de salida correctamente
end Resampler; 

architecture Behavioral of Resampler is

component Phase is
	Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  phase_earth : in STD_LOGIC_VECTOR(9 downto 0);
           CoeffIndex : out  PSA;
           fifo_read : out  STD_LOGIC_VECTOR(2 downto 0));
end component;

component In_Delay is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  DataInArray;
           data_out : out  DataInArray);
end component;

Component Selector is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Data_in : in  DataInArray;
           Coeff_in : in  PSA;
           Data_out : out  BanksArray;
           Coeff_out : out  CoeffBank);
end component;

Component Bank is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data_in : in  FilterArray;
           CoeffIndex : in  STD_LOGIC_VECTOR (9 downto 0);
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal CoeffIndex : PSA;
signal Delayed_Data : DataInArray;
signal Selected_data : BanksArray;
signal selected_coeff : CoeffBank;

begin

PHASE_CALC : Phase
	Port map ( clk => clk,
           reset => reset,
			  phase_earth => phase_earth,
           CoeffIndex => CoeffIndex,
           fifo_read => fifo_read);
		
IN_DELAYER : In_Delay
	Port map (clk => clk,
           reset => reset,
           data_in => Data_In,
           data_out => Delayed_Data);

SEL : Selector
	Port map (clk => clk,
           reset => reset,
           Data_in => Delayed_Data,
           Coeff_in => COeffIndex,
           Data_out => selected_data,
           Coeff_out => selected_coeff);
			  
B0 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(0),
           CoeffIndex => selected_coeff(0),
           data_out => Data_out(0));

B1 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(1),
           CoeffIndex => selected_coeff(1),
           data_out => Data_out(1));
		
B2 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(2),
           CoeffIndex => selected_coeff(2),
           data_out => Data_out(2));
			  
B3 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(3),
           CoeffIndex => selected_coeff(3),
           data_out => Data_out(3));
			  
B4 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(4),
           CoeffIndex => selected_coeff(4),
           data_out => Data_out(4));
			  
B5 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(5),
           CoeffIndex => selected_coeff(5),
           data_out => Data_out(5));
			  
B6 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(6),
           CoeffIndex => selected_coeff(6),
           data_out => Data_out(6));
			  
B7 : Bank
	Port map (clk => clk,
           reset => reset,
           data_in => Selected_Data(7),
           CoeffIndex => selected_coeff(7),
           data_out => Data_out(7));


end Behavioral;