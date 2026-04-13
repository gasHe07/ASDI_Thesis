----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025 09:23:27
-- Design Name: 
-- Module Name: MEM - Behavioral
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
-- memoria di solo scrittura
entity MEM is
    generic(
        word   : positive := 8;  -- lunghezza di ciascuna parola
        depth : positive := 4   -- numero di bit dell'indirizzo
    );
    port (
        din : in STD_LOGIC_VECTOR(word - 1 downto 0);
        addr : in  STD_LOGIC_VECTOR(depth - 1 downto 0);
        write : in std_logic;
        clk : in std_logic;
        r : in std_logic
    );
end MEM;

architecture Behavioral of MEM is
    type my_mem is array (0 to 2**depth - 1) of std_logic_vector(word-1 downto 0);
    signal memo : my_mem := (others => (others => '0'));
    

begin

    process(clk,r)
    begin
        if (rising_edge(clk)) then
            if (r = '1') then
                memo <= (others => (others => '0'));
            elsif (write = '1') then
                memo(TO_INTEGER(unsigned(addr))) <= din; -- 
            end if;
        end if;
    end process;


end Behavioral;
