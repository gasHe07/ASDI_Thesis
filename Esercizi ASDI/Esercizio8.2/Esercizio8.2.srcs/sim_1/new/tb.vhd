----------------------------------------------------------------------------------
-- Testbench for top_module
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_module is
end tb_top_module;

architecture Behavioral of tb_top_module is

    constant n : integer := 8;

    -- segnali di test
    signal clk   : STD_LOGIC := '0';
    signal r     : STD_LOGIC := '1';
    signal start : STD_LOGIC := '0';
    signal dout  : STD_LOGIC_VECTOR(n/2 - 1 downto 0);

    -- periodo clock
    constant Tclk : time := 10 ns;

begin

    --------------------------------------------------------------------------
    -- Clock generator
    --------------------------------------------------------------------------
    clk <= not clk after Tclk/2;

    --------------------------------------------------------------------------
    -- DUT: top_module
    --------------------------------------------------------------------------
    DUT : entity work.top_module
        generic map (
            n => n
        )
        port map (
            clk   => clk,
            r     => r,
            start => start,
            dout  => dout
        );

    --------------------------------------------------------------------------
    -- Stimoli
    --------------------------------------------------------------------------
    stim_proc : process
    begin
        -- reset attivo
        r <= '1';
        start <= '0';
        wait for 30 ns;

        -- rilascio reset
        r <= '0';
        wait for 20 ns;

        -- impulso di start
        start <= '1';
        wait for Tclk;
        start <= '0';

        -- attendo che il sistema lavori (ROM + handshake)
        wait for 500 ns;

        -- fine simulazione
        wait;
    end process;

end Behavioral;
