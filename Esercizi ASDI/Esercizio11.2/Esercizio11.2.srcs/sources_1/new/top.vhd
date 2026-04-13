----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2025 10:28:18
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  Top-level che collega:
--   - manager (gestione pacchetti e FIFO)
--   - omega_network (rete di commutazione)
-- 
-- Dependencies: 
--  manager
--  omega_network
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk : in std_logic;
        r   : in std_logic;
        a0, a1, a2, a3, a4, a5, a6, a7 : in  STD_LOGIC_VECTOR (10 downto 0);
        o0, o1, o2, o3, o4, o5, o6, o7 : out STD_LOGIC_VECTOR (3 downto 0)
    );
end top;

architecture Behavioral of top is

    --------------------------------------------------------------------
    -- Segnali interni tra manager e omega_network
    --------------------------------------------------------------------
    signal s_net, d_net : std_logic_vector(2 downto 0);

    signal i0_net, i1_net, i2_net, i3_net : std_logic_vector(3 downto 0);
    signal i4_net, i5_net, i6_net, i7_net : std_logic_vector(3 downto 0);

    signal o0_net, o1_net, o2_net, o3_net : std_logic_vector(3 downto 0);
    signal o4_net, o5_net, o6_net, o7_net : std_logic_vector(3 downto 0);

begin

    --------------------------------------------------------------------
    -- ISTANZA DEL MANAGER
    --------------------------------------------------------------------
    MAN : entity work.manager
        port map(
            clk => clk,
            r   => r,

            A0 => a0, A1 => a1, A2 => a2, A3 => a3,
            A4 => a4, A5 => a5, A6 => a6, A7 => a7,

            s  => s_net,
            d  => d_net,

            i0 => i0_net, i1 => i1_net, i2 => i2_net, i3 => i3_net,
            i4 => i4_net, i5 => i5_net, i6 => i6_net, i7 => i7_net
        );

    --------------------------------------------------------------------
    -- ISTANZA DELLA OMEGA NETWORK
    --------------------------------------------------------------------
    OMEGA : entity work.omega_network
        port map(
            i0 => i0_net, i1 => i1_net, i2 => i2_net, i3 => i3_net,
            i4 => i4_net, i5 => i5_net, i6 => i6_net, i7 => i7_net,

            src  => s_net,
            dest => d_net,

            o0 => o0_net, o1 => o1_net, o2 => o2_net, o3 => o3_net,
            o4 => o4_net, o5 => o5_net, o6 => o6_net, o7 => o7_net
        );

    --------------------------------------------------------------------
    -- COLLEGAMENTO USCITE FINALI
    --------------------------------------------------------------------
    o0 <= o0_net;
    o1 <= o1_net;
    o2 <= o2_net;
    o3 <= o3_net;
    o4 <= o4_net;
    o5 <= o5_net;
    o6 <= o6_net;
    o7 <= o7_net;

end Behavioral;
