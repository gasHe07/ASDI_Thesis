library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_comb_net is
-- Testbench non ha porte
end tb_comb_net;

architecture behavior of tb_comb_net is

    -- segnali per collegamento al DUT
    signal i   : std_logic_vector(31 downto 0);
    signal sm  : std_logic_vector(4 downto 0);
    signal sd  : std_logic_vector(2 downto 0);
    signal y   : std_logic_vector(7 downto 0);

begin

    -- Istanza del DUT
    DUT: entity work.comb_net
        port map(
            i  => i,
            sm => sm,
            sd => sd,
            y  => y
        );

    -- Stimoli automatici
    process
        variable in_idx : integer;
        variable out_idx: integer;
    begin
        -- reset iniziale
        i  <= (others => '0');
        sm <= (others => '0');
        sd <= (others => '0');
        wait for 10 ns;

        -- loop su tutti i 32 ingressi
        for in_idx in 0 to 31 loop
            -- attiva solo un ingresso alla volta
            i <= (others => '0');
            i(in_idx) <= '1';
            sm <= std_logic_vector(to_unsigned(in_idx, 5));  -- selettore MUX32

            -- loop su tutte le 8 uscite del DEMUX
            for out_idx in 0 to 7 loop
                sd <= std_logic_vector(to_unsigned(out_idx, 3));  -- selettore DEMUX
                wait for 5 ns;  -- piccolo ritardo per vedere l’effetto
            end loop;
        end loop;

        -- fine simulazione
        wait;
    end process;

end behavior;
