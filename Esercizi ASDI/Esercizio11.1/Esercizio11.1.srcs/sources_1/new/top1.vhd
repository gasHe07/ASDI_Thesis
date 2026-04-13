library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top1 is
    Port (
        clk   : in  std_logic;  -- clock per rr_man
        r     : in  std_logic;  -- reset
        A0, A1, A2, A3, A4, A5, A6, A7 : in  std_logic_vector(9 downto 0); 
        -- 10 bit: [9..7]=source, [6..4]=dest, [3..0]=payload

        O0, O1, O2, O3, O4, O5, O6, O7 : out std_logic_vector(3 downto 0)
        -- uscite finali della rete
    );
end top1;

architecture structural of top1 is
    -- payload selezionato dal rr_man
    signal B0_s, B1_s, B2_s, B3_s, B4_s, B5_s, B6_s, B7_s : std_logic_vector(3 downto 0);

    -- sorgente/destinazione scelti dal rr_man
    signal src_s, dest_s : std_logic_vector(2 downto 0);

begin
    
    -- ROUND-ROBIN MANAGER
    MANAGER: entity work.rr_man
        port map(
            clk => clk,
            r   => r,
            A0  => A0,
            A1  => A1,
            A2  => A2,
            A3  => A3,
            A4  => A4,
            A5  => A5,
            A6  => A6,
            A7  => A7,
            s   => src_s,
            d   => dest_s,
            B0  => B0_s,
            B1  => B1_s,
            B2  => B2_s,
            B3  => B3_s,
            B4  => B4_s,
            B5  => B5_s,
            B6  => B6_s,
            B7  => B7_s
        );
    
    -- OMEGA NETWORK 8x8
    OMEGA: entity work.omega_network
        port map(
            i0   => B0_s,
            i1   => B1_s,
            i2   => B2_s,
            i3   => B3_s,
            i4   => B4_s,
            i5   => B5_s,
            i6   => B6_s,
            i7   => B7_s,
            src  => src_s,
            dest => dest_s,
            o0   => O0,
            o1   => O1,
            o2   => O2,
            o3   => O3,
            o4   => O4,
            o5   => O5,
            o6   => O6,
            o7   => O7
        );

end structural;
