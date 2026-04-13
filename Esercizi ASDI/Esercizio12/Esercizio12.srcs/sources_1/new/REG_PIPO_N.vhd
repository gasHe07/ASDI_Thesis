----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 10:26:55
-- Design Name: 
-- Module Name: REG_PIPO_N - Behavioral
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

entity REG_PIPO_N is
    generic (n : positive range 2 to 32 := 4);
    Port ( clk, r, load : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (n - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (n - 1 downto 0));
end REG_PIPO_N;

architecture Behavioral of REG_PIPO_N is

begin
process(clk, r) 
begin
    if r = '1' then
        dout <= (others => '0');
    elsif rising_edge(clk) then
            if load = '1' then
                dout <= din;
            end if;
    end if;

end process;

end Behavioral;
