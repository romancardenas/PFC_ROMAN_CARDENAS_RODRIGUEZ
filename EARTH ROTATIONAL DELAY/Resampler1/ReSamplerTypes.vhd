--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package ReSamplerTypes is

-- Declare constants
	
	constant TAP : integer := 56;
	constant L : integer := 1024;
	
	constant FO : integer := 1712; --origin
	constant FR : integer := 2000; --resampled
	
	constant FOE : UNSIGNED(41 downto 0) := "110110110010001011010000111001010110000001"; --876.5440 (0.10.32)
	
	constant FDIFF : STD_LOGIC_VECTOR (39 downto 0) := "1001001101110100101111000110101001111111"; -- 147,456 (0.8.32)
	
	constant INPUT_SIZE : integer := FO;
	constant OUTPUT_SIZE : integer := FR;

	constant TEST_PERIODS : integer := 1;

-- Declare types

	SUBTYPE DelayItem IS std_logic_vector (7 downto 0);
	TYPE DelayArray IS ARRAY (0 to TAP + 1) OF DelayItem; -- For FIFO output
	TYPE SelectedArray IS ARRAY (0 to TAP - 1) of DelayItem; -- For Selector output
	TYPE InputArray IS ARRAY (0 to INPUT_SIZE*TEST_PERIODS) OF DelayItem;

	SUBTYPE Coeff IS std_logic_vector (17 downto 0);
	-- Array with possible values for a coefficient (depending on the phase)
	TYPE CoeffArray IS ARRAY (0 to L-1) OF Coeff;
	TYPE CoeffMatrix IS ARRAY (0 to TAP-1) OF CoeffArray;
	TYPE CoeffPhase IS ARRAY (0 to TAP-1) OF Coeff;
	
	SUBTYPE Arrayouts IS std_logic_vector (31 downto 0);
	TYPE OutputArray IS ARRAY (0 to OUTPUT_SIZE*TEST_PERIODS) OF ArrayOuts;
	
	SUBTYPE MultItem is signed(25 downto 0);
	TYPE MultArray is ARRAY (0 to TAP-1) of MultItem;
	
	SUBTYPE sumItem is signed(31 downto 0);
--	TYPE sumArray is ARRAY (0 to TAP-1) of sumItem;
   TYPE sum_step1 is array (0 to TAP/2-1) of sumItem;
	TYPE sum_step2 is array (0 to 14-1) of sumItem;
	TYPE sum_step3 is array (0 to 7-1) of sumItem;
	TYPE sum_step4 is array (0 to 4-1) of sumItem;
	TYPE sum_step5 is array (0 to 2-1) of sumItem;
	
 
end ReSamplerTypes;


package body ReSamplerTypes is
end ReSamplerTypes;
