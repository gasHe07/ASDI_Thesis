----------------------------------------------------------------------------------
-- Testbench for cronometro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cronometro is
-- Testbench non ha porte
end tb_cronometro;

architecture Behavioral of tb_cronometro is

    -- Component under test
    component cronometro
        Port ( 
            en          : in  STD_LOGIC;
            clk         : in  STD_LOGIC;
            r           : in  STD_LOGIC;
            init_val_s  : in  STD_LOGIC_VECTOR(5 downto 0);
            init_val_m  : in  STD_LOGIC_VECTOR(5 downto 0);
            init_val_h  : in  STD_LOGIC_VECTOR(4 downto 0);
            set         : in  STD_LOGIC;
            doutsec     : out STD_LOGIC_VECTOR(5 downto 0);
            doutmin     : out STD_LOGIC_VECTOR(5 downto 0);
            douth       : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    -- Signals
    signal clk_tb       : std_logic := '0';
    signal en_tb        : std_logic := '0';
    signal r_tb         : std_logic := '0';
    signal set_tb       : std_logic := '0';
    signal init_val_s_tb: std_logic_vector(5 downto 0) := (others => '0');
    signal init_val_m_tb: std_logic_vector(5 downto 0) := (others => '0');
    signal init_val_h_tb: std_logic_vector(4 downto 0) := (others => '0');
    signal doutsec_tb   : std_logic_vector(5 downto 0);
    signal doutmin_tb   : std_logic_vector(5 downto 0);
    signal douth_tb     : std_logic_vector(4 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    DUT: cronometro
        port map(
            en => en_tb,
            clk => clk_tb,
            r => r_tb,
            init_val_s => init_val_s_tb,
            init_val_m => init_val_m_tb,
            init_val_h => init_val_h_tb,
            set => set_tb,
            doutsec => doutsec_tb,
            doutmin => doutmin_tb,
            douth => douth_tb
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset
        r_tb <= '1';
        en_tb <= '0';
        wait for 20 ns;
        r_tb <= '0';
        wait for 20 ns;

        -- Set initial values
        init_val_s_tb <= "000001"; -- 1 secondo
        init_val_m_tb <= "000010"; -- 2 minuti
        init_val_h_tb <= "00011";  -- 3 ore
        set_tb <= '1';
        wait for CLK_PERIOD;
        set_tb <= '0';

        -- Enable the counter
        en_tb <= '1';

        -- Let the counter run for some time
        wait for 1000 ns;

        -- Reset again
        r_tb <= '1';
        wait for 20 ns;
        r_tb <= '0';

        -- End simulation
        wait for 100 ns;
        assert false report "Simulation finished" severity note;
        wait;
    end process;

end Behavioral;
