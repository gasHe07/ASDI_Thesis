----------------------------------------------------------------------------------
-- Testbench semplice per Top Module Node_A ? Node_B
-- Senza monitor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_module_simple is
end tb_top_module_simple;

architecture Behavioral of tb_top_module_simple is

    signal clk   : STD_LOGIC := '0';
    signal r     : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal dout  : STD_LOGIC_VECTOR(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    --------------------------------------------------------------------------
    -- Instanza del top module
    --------------------------------------------------------------------------
    UUT : entity work.top_module
        port map(
            clk   => clk,
            r     => r,
            start => start,
            dout  => dout
        );

    --------------------------------------------------------------------------
    -- Generazione clock
    --------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    --------------------------------------------------------------------------
    -- Stimoli: reset e start
    --------------------------------------------------------------------------
    stim_proc : process
    begin
        -- Reset iniziale
        r <= '1';
        start <= '0';
        wait for 20 ns;
        r <= '0';
        wait for 10 ns;

        -- Start del sistema
        start <= '1';
        wait for 10 ns;
        start <= '0';

        -- Lascia girare la simulazione
        wait for 500 ns;

        -- Fine simulazione
        wait;
    end process;

end Behavioral;
