----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2025 14:29:44
-- Design Name: 
-- Module Name: on_board - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity on_board is
    port(
        clk : in std_logic;
        s : in std_logic; -- BTNC
        r   : in std_logic; -- BTNR
        SW  : in std_logic_vector(11 downto 0); 
        anodes : out  STD_LOGIC_VECTOR (7 downto 0);
	    cathodes : out  STD_LOGIC_VECTOR (7 downto 0)
    );
end on_board;

architecture Behavioral of on_board is
signal cleaned_set, cleaned_r : std_logic;
type state is (idle, load_p1, load_p2, stop);
signal current_state : state := idle;

signal reg : std_logic_vector(16 downto 0) := (others => '0'); -- registro dove accumulo i valori da caricare
signal second, cset : std_logic;
signal sec, min : std_logic_vector(5 downto 0);
signal hour : std_logic_vector(4 downto 0);

signal disp_value  : std_logic_vector(31 downto 0) := (others => '0');
signal disp_enable : std_logic_vector(7 downto 0)  := (others => '0');
signal disp_dots   : std_logic_vector(7 downto 0)  := (others => '0');

begin

    -- FSM per caricare i dati
    
    process(clk, cleaned_r, cleaned_set)
    begin  
    if rising_edge(clk) then
        cset <= '0';
        case current_state is
            
            when idle =>
                if cleaned_r = '1' then
                    reg <= (others => '0');
                    current_state <= idle;
                elsif cleaned_set = '1' then
                    current_state <= load_p1;
                end if;

            when load_p1 =>
                if cleaned_r = '1' then
                    reg <= (others => '0');
                    current_state <= idle;
                elsif cleaned_set = '1' then
                    reg(11 downto 0) <= sw;        -- minuti/secondi
                    current_state <= load_p2;
                end if;

            when load_p2 =>
                if cleaned_r = '1' then
                    reg <= (others => '0');
                    current_state <= idle;
                elsif cleaned_set = '1' then
                    reg(16 downto 12) <= sw(4 downto 0);  -- ore
                    cset <= '1';
                    current_state <= stop;
                end if;

            when stop =>
                if cleaned_r = '1' then
                    reg <= (others => '0');
                    current_state <= idle;
                elsif cleaned_set = '1' then
                    current_state <= load_p1;
                end if;

        end case;

    end if;    
end process;

    
    -- dichiaro i componenti
   clean_set : entity work.ButtonDebouncer
    generic map (
        CLK_period      => 10,
        btn_noise_time  => 10_000_000
    )
    port map (
        RST         => cleaned_r,
        CLK         => clk,
        BTN         => s,
        CLEARED_BTN => cleaned_set
    );
    
    clean_reset : entity work.ButtonDebouncer
    generic map (
        CLK_period      => 10,
        btn_noise_time  => 10_000_000
    )
    port map (
        RST         => '0',
        CLK         => clk,
        BTN         => r,
        CLEARED_BTN => cleaned_r
    );
    
    secondi : entity work.clock_divider
        generic map(
            clock_frequency_in => 100000000,
            clock_frequency_out => 1
        )
        port map(
            clock_in => clk,
		   reset => cleaned_r,
           clock_out => second
        );
    
    cronos : entity work.cronometro
        port map(
            en => second,
            clk => clk,
            r => cleaned_r,
            init_val_s => reg(5 downto 0),
            init_val_m => reg(11 downto 6),
            init_val_h => reg(16 downto 12),
            set => cset,
            doutsec => sec,
            doutmin => min,
            douth   => hour
        );
    
    -- mappatura ore minuti secondi
    disp_value(7 downto 0) <= "00" & sec; -- aggiungo 2 bit di padding per il primo byte
    disp_value(15 downto 8) <= "00" & min;
    disp_value(23 downto 16) <= "000" & hour; -- 
    disp_value(31 downto 24) <= (others => '0');
    
    -- abilito tutte le cifre
    disp_enable <=(others => '1');
    -- disabilito i punti
    disp_dots <= (others => '0');
    
    display_inst : entity work.display_seven_segments
        generic map (
            clock_frequency_in  => 100000000, -- clock Nexys (100 MHz)
            clock_frequency_out => 500        -- frequenza di multiplex 
        )
        port map (
            clock      => clk,
            reset      => cleaned_r,      
            value32_in => disp_value,
            enable     => disp_enable,
            dots       => disp_dots,
            anodes     => anodes,
            cathodes   => cathodes         
        );
 
end Behavioral;