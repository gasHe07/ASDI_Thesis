----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 16:22:39
-- Design Name: 
-- Module Name: Mux32_1 - structural
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux32_1 is
    Port ( 
        b      : in  STD_LOGIC_VECTOR (31 downto 0);
        se     : in  STD_LOGIC_VECTOR (4 downto 0);
        y_32_1 : out STD_LOGIC
    );
end Mux32_1;

architecture structural of Mux32_1 is
    -- segnali livello 1 (uscita MUX8:1)
    signal u0, u1, u2, u3 : std_logic;
    -- segnali livello 2 (uscita MUX2:1)
    signal v0, v1 : std_logic;
    
    -- componente MUX2:1
    component Mux2_1
        Port (
            a0   : in std_logic;
            a1   : in std_logic;
            s0   : in std_logic;
            y2_1 : out std_logic
        );
    end component;
    
    -- componente MUX8:1
    component Mux81
        Port(
            a   : in  std_logic_vector(7 downto 0);
            s1  : in  std_logic_vector(2 downto 0);  
            y81 : out std_logic                      
        );
    end component;

begin
-- LIVELLO 1: 4 MUX 8:1
mux8_0: Mux81 port map (
    a   => b(7 downto 0),
    s1  => se(2 downto 0),
    y81 => u0
);

mux8_1: Mux81 port map (
    a   => b(15 downto 8),
    s1  => se(2 downto 0),
    y81 => u1
);

mux8_2: Mux81 port map (
    a   => b(23 downto 16),
    s1  => se(2 downto 0),
    y81 => u2
);

mux8_3: Mux81 port map (
    a   => b(31 downto 24),
    s1  => se(2 downto 0),
    y81 => u3
);

-- LIVELLO 2: 2 MUX 2:1
mux_2_0: Mux2_1 port map(
    a0   => u0,
    a1   => u1,
    s0   => se(3),
    y2_1 => v0
);

mux_2_1: Mux2_1 port map(
    a0   => u2,
    a1   => u3,
    s0   => se(3),
    y2_1 => v1
);

-- LIVELLO 3: 1 MUX 2:1
last_mux: Mux2_1 port map(
    a0   => v0,
    a1   => v1,
    s0   => se(4),
    y2_1 => y_32_1
);

end structural;

