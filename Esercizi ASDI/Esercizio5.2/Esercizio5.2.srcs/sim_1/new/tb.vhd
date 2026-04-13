library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_on_board is
end tb_on_board;

architecture Behavioral of tb_on_board is

    -- segnali per collegarsi alla UUT
    signal clk       : std_logic := '0';
    signal s         : std_logic := '0';
    signal r         : std_logic := '0';
    signal SW        : std_logic_vector(11 downto 0) := (others => '0');
    signal anodes    : std_logic_vector(7 downto 0);
    signal cathodes  : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- istanza dell'unità sotto test
    uut : entity work.on_board
        port map (
            clk       => clk,
            s         => s,
            r         => r,
            SW        => SW,
            anodes    => anodes,
            cathodes  => cathodes
        );

    -- generatore di clock
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- stimoli
    stim_proc : process
    begin
        -- reset iniziale
        r <= '1';
        wait for 100 ns;
        r <= '0';

        -- carico minuti e secondi
        SW <= "000101001010"; -- esempio: sec/min
        wait for 100 ns;

        -- pressione pulsante SET (passo idle -> load_p1)
        s <= '1';
        wait for 50 ns;
        s <= '0';
        wait for 200 ns;

        -- pressione SET (load_p1 -> load_p2)
        s <= '1';
        wait for 50 ns;
        s <= '0';
        wait for 200 ns;

        -- carico ore (solo 5 bit meno significativi)
        SW <= "000000000101"; -- ore = 5
        wait for 100 ns;

        -- pressione SET (load_p2 -> stop, cset attivo)
        s <= '1';
        wait for 50 ns;
        s <= '0';

        -- lascio andare il cronometro
        wait for 2 sec;

        -- reset finale
        r <= '1';
        wait for 100 ns;
        r <= '0';

        wait;
    end process;

end Behavioral;
