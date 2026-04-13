----------------------------------------------------------------------------------
-- Testbench per sequence_recognizer
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sequence_recognizer is
-- Nessuna porta, testbench interno
end tb_sequence_recognizer;

architecture behavior of tb_sequence_recognizer is

    -- Component declaration del modulo da testare
    component sequence_recognizer
        Port(
            i   : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            r   : in  STD_LOGIC;
            y   : out STD_LOGIC
        );
    end component;

    -- Segnali per connettere il DUT
    signal i_tb   : STD_LOGIC := '0';
    signal clk_tb : STD_LOGIC := '0';
    signal r_tb   : STD_LOGIC := '0';
    signal y_tb   : STD_LOGIC;

    -- Parametri di simulazione
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanziazione del DUT
    DUT: sequence_recognizer
        Port map(
            i   => i_tb,
            clk => clk_tb,
            r   => r_tb,
            y   => y_tb
        );

    -- Generatore di clock
    clk_process :process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimoli di test
    stim_proc: process
    begin
        -- Reset iniziale
        r_tb <= '1';
        wait for 2*CLK_PERIOD;
        r_tb <= '0';
        wait for CLK_PERIOD;

        -- Sequenza di test: verificare riconoscimento 111
        -- Formato: "i_tb <= valore; wait for CLK_PERIOD;"
        i_tb <= '1'; wait for CLK_PERIOD;
        i_tb <= '1'; wait for CLK_PERIOD;
        i_tb <= '1'; wait for CLK_PERIOD;  -- Qui y dovrebbe diventare '1' per Mealy/Moore
        i_tb <= '0'; wait for CLK_PERIOD;
        i_tb <= '1'; wait for CLK_PERIOD;
        i_tb <= '1'; wait for CLK_PERIOD;
        i_tb <= '1'; wait for CLK_PERIOD;  -- Riconoscimento sequenza di nuovo
        i_tb <= '0'; wait for CLK_PERIOD;
        i_tb <= '0'; wait for CLK_PERIOD;

        -- Fine simulazione
        wait for 5*CLK_PERIOD;
    end process;

end behavior;
