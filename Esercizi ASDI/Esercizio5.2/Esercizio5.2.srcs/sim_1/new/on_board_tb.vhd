library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_on_board2 is
end tb_on_board2;

architecture Behavioral of tb_on_board2 is

    -- segnali verso la UUT
    signal clk        : std_logic := '0';
    signal s          : std_logic := '0';
    signal r          : std_logic := '0';
    signal view       : std_logic := '0';
    signal intertempo : std_logic := '0';
    signal scroll     : std_logic := '0';
    signal SW         : std_logic_vector(11 downto 0) := (others => '0');
    signal anodes     : std_logic_vector(7 downto 0);
    signal cathodes   : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- istanza dell'unità sotto test
    uut : entity work.on_board2
        port map (
            clk        => clk,
            s          => s,
            r          => r,
            view       => view,
            intertempo => intertempo,
            scroll     => scroll,
            SW         => SW,
            anodes     => anodes,
            cathodes   => cathodes
        );

    -- generatore di clock
    clk_proc : process
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
        wait for 200 ns;
        r <= '0';

        -- carico minuti e secondi
        SW <= "000101001010"; -- esempio sec/min
        wait for 100 ns;

        -- pressione SET (idle -> load_p1)
        s <= '1';
        wait for 50 ns;
        s <= '0';
        wait for 300 ns;

        -- pressione SET (load_p1 -> load_p2)
        s <= '1';
        wait for 50 ns;
        s <= '0';
        wait for 300 ns;

        -- carico ore
        SW <= "000000000101"; -- ore = 5
        wait for 100 ns;

        -- pressione SET (load_p2 -> stop, cset)
        s <= '1';
        wait for 50 ns;
        s <= '0';

        -- lascio scorrere il cronometro
        wait for 2 sec;

        -- salvo un intertempo
        intertempo <= '1';
        wait for 50 ns;
        intertempo <= '0';

        wait for 1 sec;

        -- passo in modalità VIEW
        view <= '1';
        wait for 50 ns;
        view <= '0';

        wait for 500 ms;

        -- scroll tra gli intertempi
        scroll <= '1';
        wait for 50 ns;
        scroll <= '0';

        wait for 500 ms;

        scroll <= '1';
        wait for 50 ns;
        scroll <= '0';

        -- ritorno in modalità cronometro
        view <= '1';
        wait for 50 ns;
        view <= '0';

        wait for 1 sec;

        -- reset finale
        r <= '1';
        wait for 200 ns;
        r <= '0';

        wait;
    end process;

end Behavioral;
