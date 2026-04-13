----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 14:12:55
-- Design Name: 
-- Module Name: Node_B - Behavioral
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

entity Node_B is
    Port ( clkb, r, start, req : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (7 downto 0);
           ack : out STD_LOGIC);
end Node_B;

architecture Structural of Node_B is
signal x : STD_LOGIC_VECTOR (7 downto 0) := "00110101"; -- stringa stock
signal to_cmp : STD_LOGIC_VECTOR (7 downto 0);
signal res : std_logic_vector(1 downto 0);
signal addr : std_logic_vector(2 downto 0);
signal load, write, en : std_logic;
begin
    CTRL : entity work.ctrl_b
        port map(
            clk => clkb,
            r => r,
            start => start,
            req => req,
            ack => ack,
            res => res,
            load => load,
            write => write,
            en => en,
            count => addr
        );
        
    COUNTER : entity work.counter_mod_n
        generic map(
            n => 8,
            width => 3
        )
        port map(
            clk => clkb,
            r => r,
            en => en,
            count => addr
        );
        
     REG: entity work.REG_PIPO_N
     generic map (n => 8)
    port map(
        clk => clkb,
        r => r,
        load => load,
        din => din,       
        dout => to_cmp
    );
    
    COMPARATOR : entity work.comparator
        port map(
            a => to_cmp,
            b => x,
            res => res
        );
        
     MEMORY : entity work.memory
        port map(
            clk => clkb,
            addr => addr,
            r => r,
            read => '0',
            w => write,
            din => to_cmp,
            dout => open
        );
        
        

end Structural;
