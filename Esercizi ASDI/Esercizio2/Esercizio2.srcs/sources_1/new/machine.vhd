----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2025 10:21:59
-- Design Name: 
-- Module Name: machine - rtl
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

entity machine is
    Port ( val : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (2 downto 0));
end machine;

architecture rtl of machine is

begin
    process(val)
        variable a, b   : unsigned(1 downto 0);
        variable sum    : unsigned(2 downto 0);
    begin
        -- I 2 MSB
        a := unsigned(val(3 downto 2)); 
        -- I 2 LSB
        b := unsigned(val(1 downto 0)); 
        
        -- somma con estensione per evitare overflow (estensione viene fatta con & con vect)
        sum := ('0' & a) + ('0' & b);  
        
        -- assegno all'uscita
        dout <= std_logic_vector(sum);
    end process;
end rtl;