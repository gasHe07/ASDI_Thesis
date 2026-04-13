----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2025 11:33:35
-- Design Name: 
-- Module Name: MUX32_1 - structural
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

entity MUX32_1 is
    Port ( i : in STD_LOGIC_VECTOR (31 downto 0);
           s : in STD_LOGIC_VECTOR (4 downto 0);
           y : out STD_LOGIC);
end MUX32_1;

architecture structural of MUX32_1 is

    -- segnali di primo livello (mux8:1 -> mux2:1)
    signal u0, u1, u2, u3 : std_logic;
    -- segnali di secondi livello (mux2:1 -> mux2:1)
    signal v0, v1 : std_logic;
    
    -- MUX 2:1
    component MUX2_1
        port(
            i : in std_logic_vector(1 downto 0);
            s : in std_logic;
            y : out std_logic
        );
    end component;
     
    -- MUX 8:1
    component MUX8_1
        port(
            i : in std_logic_vector(7 downto 0);
            s : in std_logic_vector(2 downto 0);
            y : out std_logic
        );
    end component;

begin

    -- Livello 1: 4 MUX 8:1
    mux80: mux8_1 port map(
        i => i(7 downto 0),
        s => s(2 downto 0),
        y => u0
    );
    
    mux81: mux8_1 port map(
        i => i(15 downto 8),
        s => s(2 downto 0),
        y => u1
    );
    
    mux82: mux8_1 port map(
        i => i(23 downto 16),
        s => s(2 downto 0),
        y => u2
    );
    
    mux83: mux8_1 port map(
        i => i(31 downto 24),
        s => s(2 downto 0),
        y => u3
    );
    
    -- Livello 2 2 MUX 2:1
    mux20: mux2_1 port map(
        i(0) => u0,
        i(1) => u1,
        s => s(3),
        y => v0
    );
    
    mux21: mux2_1 port map(
        i(0) => u2,
        i(1) => u3,
        s => s(3),
        y => v1  -- corretto da v0 a v1
    );

    -- Livello 3: 1 MUX 2:1
    lastmux : mux2_1 port map(
        i(0) => v0,
        i(1) => v1,
        s => s(4),
        y => y
    );

end structural;
