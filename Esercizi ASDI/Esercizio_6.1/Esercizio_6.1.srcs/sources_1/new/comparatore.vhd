----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025 09:58:22
-- Design Name: 
-- Module Name: comparatore - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparatore is
    generic (word   : positive := 8);
    Port ( str1 : in STD_LOGIC_VECTOR (word - 1 downto 0);
           str2 : in STD_LOGIC_VECTOR (word - 1 downto 0);
           clk : in STD_LOGIC;
           eq : out STD_LOGIC);
end comparatore;

architecture Behavioral of comparatore is
    
begin
    process(clk, str1, str2)
    begin
        if(rising_edge(clk)) then
            if(str1 = str2) then
                eq <= '1';
            else eq <= '0';
            end if;
        end if;
    end process;


end Behavioral;
