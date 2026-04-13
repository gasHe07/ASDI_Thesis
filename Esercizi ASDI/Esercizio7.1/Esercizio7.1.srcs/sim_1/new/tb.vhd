library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Booth_mol is
end tb_Booth_mol;

architecture Behavioral of tb_Booth_mol is

    -- segnali per collegare il DUT
    signal clock   : std_logic := '0';
    signal reset   : std_logic := '0';
    signal start   : std_logic := '0';
    signal X, Y    : std_logic_vector(7 downto 0) := (others => '0');
    signal P       : std_logic_vector(15 downto 0);
    signal stop_cu : std_logic;

    -- clock period
    constant Tclk : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clock <= not clock after Tclk/2;

    --------------------------------------------------------------------
    -- DUT instantiation
    --------------------------------------------------------------------
    DUT: entity work.Booth_mol
        port map(
            clock   => clock,
            reset   => reset,
            start   => start,
            X       => X,
            Y       => Y,
            P       => P,
            stop_cu => stop_cu
        );

    --------------------------------------------------------------------
    -- Stimoli di test
    --------------------------------------------------------------------
    stim_proc: process
    begin

        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- TEST 1:  7 × 3 = 21
        ----------------------------------------------------------------
        X <= std_logic_vector(to_signed(7, 8));
        Y <= std_logic_vector(to_signed(3, 8));

        start <= '1';
        wait for Tclk;
        start <= '0';

        wait until stop_cu = '1';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- TEST 2:  7 × (-3) = -21
        ----------------------------------------------------------------
        X <= std_logic_vector(to_signed(7, 8));
        Y <= std_logic_vector(to_signed(-3, 8));

        start <= '1';
        wait for Tclk;
        start <= '0';

        wait until stop_cu = '1';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- TEST 3:  (-5) × (-6) = 30
        ----------------------------------------------------------------
        X <= std_logic_vector(to_signed(-5, 8));
        Y <= std_logic_vector(to_signed(-6, 8));

        start <= '1';
        wait for Tclk;
        start <= '0';

        wait until stop_cu = '1';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- TEST 4:  12 × 0 = 0
        ----------------------------------------------------------------
        X <= std_logic_vector(to_signed(12, 8));
        Y <= std_logic_vector(to_signed(0, 8));

        start <= '1';
        wait for Tclk;
        start <= '0';

        wait until stop_cu = '1';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- END SIMULATION
        ----------------------------------------------------------------
        wait;
    end process;

end Behavioral;
