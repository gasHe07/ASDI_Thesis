----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2025 11:32:49
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
    generic(word : integer :=8);
    Port ( val : in STD_LOGIC_VECTOR (word - 1 downto 0);
           dout : out STD_LOGIC_VECTOR (word/2 - 1 downto 0));
end machine;

architecture rtl of machine is
constant half : integer := word / 2;
begin
    main : process(val)
    variable a, b : unsigned(half -1 downto 0);
    variable sum : unsigned(half -1  downto 0);
    begin
        -- prelevo i MSB
        a := unsigned(val(word - 1 downto half));
        -- prelevo i LSB
        b := unsigned(val(half -1 downto 0));
        -- effettuo somma 
        sum := a + b;
        
        dout <= std_logic_vector(sum);
        
    end process main;

end rtl;
