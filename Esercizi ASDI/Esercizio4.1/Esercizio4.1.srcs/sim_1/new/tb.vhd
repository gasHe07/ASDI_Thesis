library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_shiftreg is
-- Testbench non ha porte
end tb_shiftreg;

architecture behavior of tb_shiftreg is

    -- Parametro del registro
    constant N : positive := 4;

    -- Component sotto test
    component shiftreg
        generic ( n : positive := 4 );
        port(
            i   : in  std_logic_vector(1 downto 0);
            clk : in  std_logic;
            rst : in  std_logic;
            dir : in  std_logic;
            m   : in  std_logic;
            y   : out std_logic;
            q   : out std_logic_vector(n-1 downto 0)
        );
    end component;

    -- Segnali di collegamento
    signal i_sig   : std_logic_vector(1 downto 0) := (others => '0');
    signal clk_sig : std_logic := '0';
    signal rst_sig : std_logic := '0';
    signal dir_sig : std_logic := '0';
    signal m_sig   : std_logic := '0';
    signal y_sig   : std_logic;
    signal q_sig   : std_logic_vector(N-1 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Istanzia shift register
    UUT: shiftreg
        generic map(n => N)
        port map(
            i   => i_sig,
            clk => clk_sig,
            rst => rst_sig,
            dir => dir_sig,
            m   => m_sig,
            y   => y_sig,
            q   => q_sig
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk_sig <= '0';
            wait for clk_period/2;
            clk_sig <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset iniziale
        rst_sig <= '1';
        wait for 20 ns;
        rst_sig <= '0';
        wait for clk_period;

        -- ===========================
        -- TEST 1: shift a dx 1-bit
        m_sig <= '0';        -- modalità 1-bit
        dir_sig <= '0';      -- shift dx
        i_sig <= "01";       -- ingresso i(0)=1, i(1)=0
        wait for clk_period*8;

        -- TEST 2: shift a sx 1-bit
        dir_sig <= '1';      -- shift sx
        i_sig <= "10";       -- ingresso i(0)=0, i(1)=1
        wait for clk_period*8;

        -- TEST 3: shift dx 2-bit
        m_sig <= '1';        -- modalità 2-bit
        dir_sig <= '0';
        i_sig <= "01";
        wait for clk_period*8;

        -- TEST 4: shift sx 2-bit
        dir_sig <= '1';
        i_sig <= "10";
        wait for clk_period*8;

        -- Fine simulazione
        wait;
    end process;

end behavior;
