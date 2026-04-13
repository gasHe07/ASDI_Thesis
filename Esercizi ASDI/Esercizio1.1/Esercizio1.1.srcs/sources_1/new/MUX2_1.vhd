----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2025 11:03:23
-- Design Name: 
-- Module Name: MUX2_1 - Behavioral
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

entity MUX2_1 is
    Port ( i : in STD_LOGIC_VECTOR (1 downto 0);
           s : in STD_LOGIC;
           y : out STD_LOGIC);
end MUX2_1;

architecture Behavioral of MUX2_1 is

begin

    process(i,s)
    begin
        if s = '0' then
            y <= i(0);
        else
            y <= i(1);
        end if;
    end process;
end Behavioral;
