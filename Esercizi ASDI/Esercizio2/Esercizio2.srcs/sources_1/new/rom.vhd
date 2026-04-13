----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2025 09:35:50
-- Design Name: 
-- Module Name: rom_16_4 - rtl
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom is
    
    Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (3 downto 0));
end rom;

architecture rtl of rom is
type MEMORY_16_4 is array (0 to 15) of std_logic_vector(3 downto 0);

--questa funzione sarà usata per popolare la ROM
function init_rom return Memory_16_4 is 
    variable temp : memory_16_4;
    begin
        for i in 0 to 15 loop
            temp(i):= std_logic_vector(TO_UNSIGNED(i,4));
            end loop;
        return temp;
    end function; 
    
    constant rom_16_4 : memory_16_4 := init_rom;

begin

    main: process(addr)
    begin
        dout <= rom_16_4(TO_INTEGER(unsigned(addr))); -- converto l'indirizzo in intero senza segno e in dout metto il valore in bit
    end process main;

end rtl;
