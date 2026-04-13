----------------------------------------------------------------------------------
-- Testbench per MUX32_1
-- Ingressi: 1 per indici dispari, 0 per indici pari
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MUX32_1 is
end tb_MUX32_1;

architecture behavioral of tb_MUX32_1 is

    component MUX32_1
        Port (
            i : in  STD_LOGIC_VECTOR(31 downto 0);
            s : in  STD_LOGIC_VECTOR(4 downto 0);
            y : out STD_LOGIC
        );
    end component;

    signal i_tb : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s_tb : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal y_tb : STD_LOGIC;

begin

    -- Istanziazione del MUX
    UUT: MUX32_1
        port map (
            i => i_tb,
            s => s_tb,
            y => y_tb
        );

    -- Processo di stimolazione
    stim_proc: process
    begin
        -- Imposta gli ingressi: 0 se pari, 1 se dispari
        for idx in 0 to 31 loop
            if (idx mod 2 = 0) then
                i_tb(idx) <= '0';
            else
                i_tb(idx) <= '1';
            end if;
        end loop;

        -- Ciclo completo sui segnali di selezione
        for sel in 0 to 31 loop
            s_tb <= std_logic_vector(to_unsigned(sel, 5));
            wait for 10 ns;

            -- Stampa risultato in console
            report "s = " & integer'image(sel) &
                   " -> y = " & std_logic'image(y_tb);
        end loop;

        report "----- FINE SIMULAZIONE MUX32_1 -----";
        wait;
    end process;

end behavioral;
