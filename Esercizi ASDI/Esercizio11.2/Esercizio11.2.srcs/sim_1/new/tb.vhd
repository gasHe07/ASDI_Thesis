----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2025
-- Design Name: 
-- Module Name: tb_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:
--  Testbench completo per il modulo top.
--  - Clock reale
--  - Reset sincrono
--  - Stimoli sincronizzati al fronte di salita
--  - Ingressi mantenuti validi per più cicli
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    --------------------------------------------------------------------
    -- Component Under Test
    --------------------------------------------------------------------
    component top is
        Port (
            clk : in std_logic;
            r   : in std_logic;

            a0, a1, a2, a3, a4, a5, a6, a7 : in  STD_LOGIC_VECTOR (10 downto 0);

            o0, o1, o2, o3, o4, o5, o6, o7 : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Segnali di test
    --------------------------------------------------------------------
    signal clk : std_logic := '0';
    signal r   : std_logic := '1';

    signal a0, a1, a2, a3, a4, a5, a6, a7 : std_logic_vector(10 downto 0) := (others=>'0');

    signal o0, o1, o2, o3, o4, o5, o6, o7 : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    DUT : top
        port map(
            clk => clk,
            r   => r,

            a0 => a0, a1 => a1, a2 => a2, a3 => a3,
            a4 => a4, a5 => a5, a6 => a6, a7 => a7,

            o0 => o0, o1 => o1, o2 => o2, o3 => o3,
            o4 => o4, o5 => o5, o6 => o6, o7 => o7
        );

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- STIMOLI
    --------------------------------------------------------------------
    stim_proc : process
    begin
        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        r <= '1';
        wait for 3*CLK_PERIOD;
        wait until rising_edge(clk);
        r <= '0';

        ----------------------------------------------------------------
        -- ATTESA POST RESET
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        ----------------------------------------------------------------
        -- PACCHETTO 1
        -- src = 0, dest = 1, payload = 10
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        a0 <= "1" & "000" & "001" & "1010";

        -- mantieni valido per 2 cicli
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        a0 <= (others=>'0');

        ----------------------------------------------------------------
        -- ATTESA SMALTIMENTO FIFO
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        ----------------------------------------------------------------
        -- PACCHETTO 2 (parallelo)
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        a1 <= "1" & "001" & "010" & "0101"; -- src=1 dest=2 payload=5
        a2 <= "1" & "010" & "011" & "1111"; -- src=2 dest=3 payload=15

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        a1 <= (others=>'0');
        a2 <= (others=>'0');

        ----------------------------------------------------------------
        -- ATTESA
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        ----------------------------------------------------------------
        -- PACCHETTO 3
        ----------------------------------------------------------------
        wait until rising_edge(clk);
        a5 <= "1" & "101" & "000" & "1100"; -- src=5 dest=0 payload=12

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        a5 <= (others=>'0');

        ----------------------------------------------------------------
        -- FINE SIMULAZIONE
        ----------------------------------------------------------------
        wait for 200 ns;
        wait;
    end process;

end Behavioral;
