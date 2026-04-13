----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2025 12:29:10
-- Design Name: 
-- Module Name: comb_net - structural
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

entity comb_net is
    Port ( i : in STD_LOGIC_VECTOR (31 downto 0);
           sm : in STD_LOGIC_VECTOR (4 downto 0);
           sd : in STD_LOGIC_VECTOR (2 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0));
end comb_net;

architecture structural of comb_net is

    signal u0: std_logic; --segnale per connettere mux al demux
    
    --componente mux 32:1
    component mux32_1
        port(
            i: in std_logic_vector(31 downto 0);
            s: in std_logic_vector(4 downto 0); 
            y: out std_logic
        );
    end component;
    
    -- componente demux 1:8
    component demux1_8
        port(
            i: in std_logic;
            s: in std_logic_vector(2 downto 0);
            y: out std_logic_vector(7 downto 0)
        );
    end component;

begin
    --composizione
    -- mux -> signal
    mux: mux32_1 port map(
        i => i,
        s => sm,
        y => u0
    );
    
    --demux -> out
    demux: demux1_8 port map(
        i => u0,
        s => sd,
        y => y
    );

end structural;

