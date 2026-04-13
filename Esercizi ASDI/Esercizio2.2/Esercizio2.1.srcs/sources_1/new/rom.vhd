----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2025 18:55:37
-- Design Name: 
-- Module Name: rom - rtl
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
use IEEE.NUMERIC_STD.ALL;

entity rom is
    generic(
        word   : positive := 8;  -- lunghezza di ciascuna parola
        deepth : positive := 4   -- numero di bit dell'indirizzo
    );
    port (
        addr : in  STD_LOGIC_VECTOR(deepth - 1 downto 0);
        dout : out STD_LOGIC_VECTOR(word - 1 downto 0)
    );
end rom; 

architecture rtl of rom is

    -- tipo array ROM
    type rom_d_w is array(0 to 2**deepth - 1) of std_logic_vector(word - 1 downto 0);

    -- funzione per inizializzare la ROM
    function init_rom return rom_d_w is
        variable temp : rom_d_w;
    begin
        for i in 0 to 2**deepth - 1 loop
            temp(i) := std_logic_vector(to_unsigned(i, word));
        end loop;
        return temp;
    end function;
    
    -- costante ROM inizializzata
    constant myrom : rom_d_w := init_rom;

begin
    -- assegnazione combinatoria diretta
    dout <= myrom(to_integer(unsigned(addr)));

end rtl;

