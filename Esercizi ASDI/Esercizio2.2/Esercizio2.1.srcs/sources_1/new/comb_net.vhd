----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2025 11:49:04
-- Design Name: 
-- Module Name: comb_net - structural
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

entity comb_net is
    generic(
        word   : positive := 8;  -- lunghezza di ciascuna parola salvata in memoria 
        deepth : positive := 4   -- profondità della ROM (numero di bit dell'indirizzo)
    );
    Port ( addr : in STD_LOGIC_VECTOR (deepth - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (word/2 - 1 downto 0));
end comb_net;

architecture structural of comb_net is
    signal u : std_logic_vector(word - 1 downto 0);
    
    component rom 
        port(
            addr : in std_logic_vector(deepth - 1 downto 0);
            dout : out std_logic_vector(word - 1 downto 0)
            );
    end component;
    
    component machine
        port(
            val : in std_logic_vector(word - 1 downto 0);
            dout : out std_logic_vector(word/2 - 1 downto 0) 
            );
    end component;

begin

    R0M : rom port map(
        addr => addr,
        dout => u
        );
        
    M4chine: machine port map(
        val => u,
        dout => dout
        );

end structural;
