----------------------------------------------------------------------------------
-- Testbench per il modulo finale
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_finale is
-- Nessun port perché è un testbench
end tb_finale;

architecture behavior of tb_finale is

    -- Dichiarazione del componente sotto test
    component finale
        Port ( 
            i  : in  STD_LOGIC_VECTOR(31 downto 0);
            s0 : in  STD_LOGIC_VECTOR(4 downto 0);
            s1 : in  STD_LOGIC_VECTOR(2 downto 0);
            y  : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Segnali di collegamento
    signal i_tb  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal s0_tb : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
    signal s1_tb : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');
    signal y_tb  : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Istanza del DUT (Device Under Test)
    UUT: finale port map(
        i  => i_tb,
        s0 => s0_tb,
        s1 => s1_tb,
        y  => y_tb
    );

    -- Processo di stimolo
    stim_proc: process
    begin
        -- Test 1: ingresso 0 -> uscita 0
        i_tb  <= X"00000001"; -- solo bit 0 alto
        s0_tb <= "00000";     -- selezione ingresso 0
        s1_tb <= "000";       -- selezione uscita 0
        wait for 20 ns;

        -- Test 2: ingresso 5 -> uscita 3
        i_tb  <= X"00000020"; -- solo bit 5 alto
        s0_tb <= "00101";     -- selezione ingresso 5
        s1_tb <= "011";       -- selezione uscita 3
        wait for 20 ns;

        -- Test 3: ingresso 31 -> uscita 7
        i_tb  <= X"80000000"; -- solo bit 31 alto
        s0_tb <= "11111";     -- selezione ingresso 31
        s1_tb <= "111";       -- selezione uscita 7
        wait for 20 ns;

        -- Test 4: più bit attivi
        i_tb  <= X"F0F0F0F0"; -- combinazione complessa
        s0_tb <= "10010";      -- ingresso 18
        s1_tb <= "101";        -- uscita 5
        wait for 20 ns;

        -- Fine simulazione
        wait;
    end process;

end behavior;

--test bench fatto da gpt
