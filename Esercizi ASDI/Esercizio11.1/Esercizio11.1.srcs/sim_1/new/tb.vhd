library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top1 is
end tb_top1;

architecture behavior of tb_top1 is

    -- Component under test
    component top1
        port(
            clk : in std_logic;
            r   : in std_logic;
            A0, A1, A2, A3, A4, A5, A6, A7 : in std_logic_vector(9 downto 0);
            O0, O1, O2, O3, O4, O5, O6, O7 : out std_logic_vector(3 downto 0)
        );
    end component;

    -- segnali TB
    signal clk   : std_logic := '0';
    signal r     : std_logic := '0';

    signal A0, A1, A2, A3, A4, A5, A6, A7 : std_logic_vector(9 downto 0);

    signal O0, O1, O2, O3, O4, O5, O6, O7 : std_logic_vector(3 downto 0);

begin

    --------------------------------------------------------------------
    -- Instanzia il DUT (Device Under Test)
    --------------------------------------------------------------------
    DUT: top1
        port map(
            clk => clk,
            r   => r,
            A0  => A0,
            A1  => A1,
            A2  => A2,
            A3  => A3,
            A4  => A4,
            A5  => A5,
            A6  => A6,
            A7  => A7,
            O0  => O0,
            O1  => O1,
            O2  => O2,
            O3  => O3,
            O4  => O4,
            O5  => O5,
            O6  => O6,
            O7  => O7
        );

    --------------------------------------------------------------------
    -- Clock 10 ns
    --------------------------------------------------------------------
    clk <= not clk after 5 ns;

    --------------------------------------------------------------------
    -- Stimoli
    --------------------------------------------------------------------
    stim_proc : process
    begin
        -- reset
        r <= '1';
        wait for 20 ns;
        r <= '0';

        ----------------------------------------------------------------
        -- Imposto valori significativi sugli ingressi A0..A7
        -- Formato: [9..7]=src, [6..4]=dest, [3..0]=payload
        ----------------------------------------------------------------

        A0 <= "000" & "001" & "0001";  -- src=0, dest=1, payload=1
        A1 <= "001" & "010" & "0010";  -- src=1, dest=2, payload=2
        A2 <= "010" & "011" & "0011";  -- src=2, dest=3, payload=3
        A3 <= "011" & "100" & "0100";  -- src=3, dest=4, payload=4
        A4 <= "100" & "101" & "0101";  -- src=4, dest=5, payload=5
        A5 <= "101" & "110" & "0110";  -- src=5, dest=6, payload=6
        A6 <= "110" & "111" & "0111";  -- src=6, dest=7, payload=7
        A7 <= "111" & "000" & "1000";  -- src=7, dest=0, payload=8

        ----------------------------------------------------------------
        -- Lasciare girare il round-robin per un po'
        ----------------------------------------------------------------
        wait for 200 ns;

        ----------------------------------------------------------------
        -- Fine simulazione
        ----------------------------------------------------------------
        wait;
    end process;

end behavior;
