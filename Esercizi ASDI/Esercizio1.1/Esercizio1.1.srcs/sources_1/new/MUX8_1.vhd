----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2025 11:20:43
-- Design Name: 
-- Module Name: MUX8_1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX8_1 is
    Port ( i : in STD_LOGIC_VECTOR (7 downto 0);
           s : in STD_LOGIC_VECTOR (2 downto 0);
           y : out STD_LOGIC);
end MUX8_1;

architecture dataflow of MUX8_1 is

-- questa volta voglio provare un approccio più compatto, anche perché
-- dubito che sia intelligente sceivere codice troppo lungo

begin

    y <= i(TO_INTEGER(UNSIGNED(s)));-- converto il valore di selezione (visto che li uso tutti) in un unsigned e poi in intero per direzionare l'ingresso
                                    -- verso l'uscirta

end dataflow;
