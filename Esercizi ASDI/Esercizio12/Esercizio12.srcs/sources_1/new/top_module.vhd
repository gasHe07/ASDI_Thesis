----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 14:31:15
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module is
    Port ( clka, clkb, r, start : in STD_LOGIC);
end top_module;

architecture Structual of top_module is
signal wires : std_logic_vector(7 downto 0);
signal req, ack : std_logic;


begin
    NODO_A : entity work.node_a
        port map(
            clka => clka,
            start => start,
            r => r,
            req => req,
            ack => ack,
            dout => wires
        );
        
    NODO_B : entity work.node_b
        port map(
            clkb => clkb,
            start => start,
            r => r,
            req => req,
            ack => ack,
            din => wires
        );

end Structual;
