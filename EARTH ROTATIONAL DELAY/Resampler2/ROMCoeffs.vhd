----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:08:28 04/04/2016 
-- Design Name: 
-- Module Name:    ROMCoeffs - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.ReSamplerTypes.all;

entity ROMCoeffs is
    Port ( tap : in  integer range 0 to L-1;
           coeffs : out  STD_LOGIC);
end ROMCoeffs;

architecture Behavioral of ROMCoeffs is

begin


end Behavioral;

