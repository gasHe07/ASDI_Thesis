----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 10:41:38
-- Design Name: 
-- Module Name: Node_A - Behavioral
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

entity Node_A is
    Port ( clkA, r, start, ack : in STD_LOGIC;
           req : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (7 downto 0));
end Node_A;

architecture Structural of Node_A is
signal addr, val, to_mul : std_logic_vector(3 downto 0);
signal en, end_op, startc, load : std_logic;
begin

ROM : entity work.rom
    generic map(
        word => 4,
        depth => 4
    )
    port map(
        addr => addr,
        dout => val
    );

COUNTER : entity work.counter_mod_n
    port map(
        clk => clkA,
        r => r,
        en => en,
        count => addr
    );

CTRL : entity work.ctrl_a
    port map(
        clk => clkA,
        r => r,
        start => start,
        ack => ack,
        end_op => end_op,
        startc => startc,
        load => load,
        en => en,
        req => req,
        count => addr
    );

REG: entity work.REG_PIPO_N
    port map(
        clk => clkA,
        r => r,
        load => load,
        din => val,       
        dout => to_mul
    );

BOOTH : entity work.Booth_mol
    port map(
        clock => clkA,
        reset => r,
        start => startc,
        x => to_mul,
        y => val,         
        p => dout,
        end_op => end_op
    );

end Structural;
