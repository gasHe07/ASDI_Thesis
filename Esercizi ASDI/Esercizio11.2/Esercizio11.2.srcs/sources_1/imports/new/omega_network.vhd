----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2025 13:46:02
-- Design Name: 
-- Module Name: omega_network - Behavioral
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

entity omega_network is
    Port (
         i0, i1, i2, i3, i4, i5, i6, i7 : in STD_LOGIC_VECTOR (3 downto 0); -- payload
         src, dest : in std_logic_vector(2 downto 0); -- bit di routing uno per ogni livello
         o0, o1, o2, o3, o4, o5, o6, o7 : out std_logic_vector(3 downto 0)
    );
end omega_network;

architecture Behavioral of omega_network is

    -- bus per i collegamenti intermedi
    type bus_array is array (0 to 7) of std_logic_vector(3 downto 0);

    signal s0, s1, s2, s3 : bus_array;

begin

    --------------------------------------------------------------------------
    -- STADIO 0 (usa src(2), dest(2))
    --------------------------------------------------------------------------
    SW0_0 : entity work.ele_switch
        port map(
            x0 => i0,
            x1 => i1,
            src => src(2),
            dest => dest(2),
            y0 => s0(0),
            y1 => s0(1)
        );  
        
    SW0_1 : entity work.ele_switch
        port map(
            x0 => i2,
            x1 => i3,
            src => src(2),
            dest => dest(2),
            y0 => s0(2),
            y1 => s0(3)
        );  
        
    SW0_2 : entity work.ele_switch
        port map(
            x0 => i4,
            x1 => i5,
            src => src(2),
            dest => dest(2),
            y0 => s0(4),
            y1 => s0(5)
        );  
        
    SW0_3 : entity work.ele_switch
        port map(
            x0 => i6,
            x1 => i7,
            src => src(2),
            dest => dest(2),
            y0 => s0(6),
            y1 => s0(7)
        );  


    --------------------------------------------------------------------------
    -- SHUFFLE 0 ? 1 (perfect shuffle)
    -- mapping: 0?0, 1?4, 2?1, 3?5, 4?2, 5?6, 6?3, 7?7
    --------------------------------------------------------------------------
    s1(0) <= s0(0);
    s1(1) <= s0(2);
    s1(2) <= s0(4);
    s1(3) <= s0(6);
    s1(4) <= s0(1);
    s1(5) <= s0(3);
    s1(6) <= s0(5);
    s1(7) <= s0(7);


    --------------------------------------------------------------------------
    -- STADIO 1 (usa src(1), dest(1))
    --------------------------------------------------------------------------
    SW1_0 : entity work.ele_switch
        port map(
            x0 => s1(0),
            x1 => s1(1),
            src => src(1),
            dest => dest(1),
            y0 => s2(0),
            y1 => s2(1)
        );

    SW1_1 : entity work.ele_switch
        port map(
            x0 => s1(2),
            x1 => s1(3),
            src => src(1),
            dest => dest(1),
            y0 => s2(2),
            y1 => s2(3)
        );

    SW1_2 : entity work.ele_switch
        port map(
            x0 => s1(4),
            x1 => s1(5),
            src => src(1),
            dest => dest(1),
            y0 => s2(4),
            y1 => s2(5)
        );

    SW1_3 : entity work.ele_switch
        port map(
            x0 => s1(6),
            x1 => s1(7),
            src => src(1),
            dest => dest(1),
            y0 => s2(6),
            y1 => s2(7)
        );


    --------------------------------------------------------------------------
    -- SHUFFLE 1 ? 2 (perfect shuffle)
    --------------------------------------------------------------------------
    s3(0) <= s2(0);
    s3(1) <= s2(2);
    s3(2) <= s2(4);
    s3(3) <= s2(6);
    s3(4) <= s2(1);
    s3(5) <= s2(3);
    s3(6) <= s2(5);
    s3(7) <= s2(7);


    --------------------------------------------------------------------------
    -- STADIO 2 (usa src(0), dest(0)) ? uscite finali
    --------------------------------------------------------------------------
    SW2_0 : entity work.ele_switch
        port map(
            x0 => s3(0),
            x1 => s3(1),
            src => src(0),
            dest => dest(0),
            y0 => o0,
            y1 => o1
        );

    SW2_1 : entity work.ele_switch
        port map(
            x0 => s3(2),
            x1 => s3(3),
            src => src(0),
            dest => dest(0),
            y0 => o2,
            y1 => o3
        );

    SW2_2 : entity work.ele_switch
        port map(
            x0 => s3(4),
            x1 => s3(5),
            src => src(0),
            dest => dest(0),
            y0 => o4,
            y1 => o5
        );

    SW2_3 : entity work.ele_switch
        port map(
            x0 => s3(6),
            x1 => s3(7),
            src => src(0),
            dest => dest(0),
            y0 => o6,
            y1 => o7
        );

end Behavioral;
