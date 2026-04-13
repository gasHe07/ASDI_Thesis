----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2025 17:00:52
-- Design Name: 
-- Module Name: memory - Behavioral
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

entity memory is
    generic(n : integer := 8;
            depth : integer := 3
    );
    Port ( clk : in STD_LOGIC;
           addr: in std_logic_vector(depth - 1 downto 0); 
           r : in STD_LOGIC;
           read : in STD_LOGIC;
           w : in STD_LOGIC; -- write
           din : in std_logic_vector(7 downto 0);
           dout : out std_logic_vector(7 downto 0));
end memory;

architecture Behavioral of memory is

type mem is array (0 to n-1) of std_logic_vector(7 downto 0);
signal memo : mem := (others => (others => '0'));

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(r = '1') then
                memo <= (others => (others => '0'));
            elsif (w = '1') then
                memo(to_integer(UNSIGNED(addr))) <= din;
            elsif (read = '1') then
                dout <= memo(to_integer(UNSIGNED(addr)));
            end if;
        end if;
    end process;


end Behavioral;
