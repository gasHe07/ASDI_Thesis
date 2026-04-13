library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    signal clka, clkb : std_logic := '0';
    signal r, start   : std_logic := '0';

    -- clock periods (modificabili per testare clkA > clkB e viceversa)
    constant T_A : time := 10 ns;   -- clkA più veloce
    constant T_B : time := 16 ns;   -- clkB più lento

begin

    -- DUT
    DUT : entity work.top_module
        port map(
            clka  => clka,
            clkb  => clkb,
            r     => r,
            start => start
        );

    -- clock A
    clkA_gen : process
    begin
        clka <= '0';
        wait for T_A/2;
        clka <= '1';
        wait for T_A/2;
    end process;

    -- clock B
    clkB_gen : process
    begin
        clkb <= '0';
        wait for T_B/2;
        clkb <= '1';
        wait for T_B/2;
    end process;

    -- Stimoli
    stim : process
    begin
        -- reset
        r <= '1';
        wait for 30 ns;
        r <= '0';

        -- avvio
        wait for 20 ns;
        start <= '1';
        wait for 10 ns;
        start <= '0';

        -- lasciare andare la simulazione
        wait for 500 ns;

        -- SECONDO SCENARIO: invertiamo i clock
        report "---- INVERSIONE CLOCK ----";

        wait for 50 ns;
        r <= '1';
        wait for 20 ns;
        r <= '0';

        -- invertiamo i periodi
        -- (in ModelSim puoi modificare T_A e T_B e rilanciare)
        -- oppure fai un secondo TB

        wait for 500 ns;

        report "SIMULAZIONE COMPLETATA";
        wait;
    end process;

end Behavioral;
