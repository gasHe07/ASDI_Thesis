----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 10:31:33
-- Design Name: 
-- Module Name: counter_mod_n - Behavioral
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

entity counter_mod_n is
    generic( n : positive range 4 to 64 := 16;
            width : positive range 2 to 6 :=4);
    Port ( clk, r, en : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (width - 1  downto 0));
end counter_mod_n;

architecture Behavioral of counter_mod_n is
signal append : unsigned (width - 1  downto 0) := (others => '0');

begin
count <= std_logic_vector(append);
process(clk, r)
begin
    if r = '1' then
        append <= (others => '0');
    elsif rising_edge(clk) then
        if TO_INTEGER(append) < n - 1 then
            append <= append + 1;
        else append <= (others => '0'); 
        end if;
         
    end if;
end process;

end Behavioral;
