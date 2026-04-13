----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 17:40:03
-- Design Name: 
-- Module Name: finale - structural
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

entity finale is
    Port ( 
        i  : in  STD_LOGIC_VECTOR (31 downto 0);
        s0 : in  STD_LOGIC_VECTOR (4 downto 0); -- selettore degli ingressi
        s1 : in  STD_LOGIC_VECTOR (2 downto 0); -- selettore delle uscite
        y  : out STD_LOGIC_VECTOR (7 downto 0)
    );
end finale;

architecture structural of finale is

    -- segnale interno che collega mux e demux
    signal u : std_logic;

    -- componente MUX32:1
    component Mux32_1
        port(
            b       : in  std_logic_vector(31 downto 0);
            se      : in  std_logic_vector(4 downto 0);
            y_32_1  : out std_logic
        );
    end component;

    -- componente DEMUX1:8
    component Demux8_1
        port(
            i1 : in  std_logic;
            s3 : in  std_logic_vector(2 downto 0);
            o2 : out std_logic_vector(7 downto 0)
        );
    end component;

begin

    -- Istanza del MUX 32:1
    mux_inst: Mux32_1 port map(
        b      => i,
        se     => s0,
        y_32_1 => u
    );

    -- Istanza del DEMUX 1:8
    demux_inst: Demux8_1 port map(
        i1 => u,
        s3 => s1,
        o2 => y
    );

end structural;
