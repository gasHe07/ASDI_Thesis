----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 13:20:42
-- Design Name: 
-- Module Name: comparator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    Port ( a, b : in STD_LOGIC_VECTOR(7 downto 0);
           res : out STD_LOGIC_VECTOR (1 downto 0));
end comparator;

architecture Behavioral of comparator is

begin
    process(a, b)
    begin
        if TO_INTEGER(unsigned(a)) = TO_INTEGER(unsigned(b))then
            res <= "11";
        elsif TO_INTEGER(unsigned(a)) < TO_INTEGER(unsigned(b))then
            res <= "10";
        elsif TO_INTEGER(unsigned(a)) > TO_INTEGER(unsigned(b))then
            res <= "01";
        else res <= "00";
        end if;
 
    end process;

end Behavioral;
