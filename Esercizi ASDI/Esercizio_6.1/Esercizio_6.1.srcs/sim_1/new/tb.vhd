----------------------------------------------------------------------------------
-- Testbench per top_module con FSM, pushed e y
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_module is
end tb_top_module;

architecture Behavioral of tb_top_module is

    -- Segnali collegati al DUT
    signal clk    : std_logic := '0';
    signal start  : std_logic := '0';
    signal r      : std_logic := '0';  -- reset attivo alto
    signal read   : std_logic := '0';  -- non usato nel DUT ma presente per compatibilità
    signal y      : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- Istanza del DUT
    ------------------------------------------------------------------------
    uut: entity work.top_module
        port map(
            clk   => clk,
            start => start,
            r     => r,
            read  => read,  -- puoi collegarlo a '0', il DUT non lo usa
            y     => y
        );

    ------------------------------------------------------------------------
    -- Generatore di clock
    ------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    ------------------------------------------------------------------------
    -- Processo di stimoli
    ------------------------------------------------------------------------
    stim_proc : process
    begin
        --------------------------------------------------------------------
        -- RESET iniziale (attivo alto)
        --------------------------------------------------------------------
        r <= '1';        -- attivo
        start <= '0';
        wait for 3 * CLK_PERIOD;

        r <= '0';        -- release reset
        wait for 2 * CLK_PERIOD;

        --------------------------------------------------------------------
        -- Primo impulso di start
        --------------------------------------------------------------------
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait for 10 * CLK_PERIOD;  -- lascia avanzare FSM, contatore e ROM

        --------------------------------------------------------------------
        -- Secondo impulso di start (opzionale)
        --------------------------------------------------------------------
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait for 10 * CLK_PERIOD;

        --------------------------------------------------------------------
        -- Verifica del funzionamento continuo
        --------------------------------------------------------------------
        -- Il segnale y deve alzarsi per un fronte quando reg_readed = str
        wait for 20 * CLK_PERIOD;

        --------------------------------------------------------------------
        -- Fine simulazione
        --------------------------------------------------------------------
        wait;
    end process;

end Behavioral;
