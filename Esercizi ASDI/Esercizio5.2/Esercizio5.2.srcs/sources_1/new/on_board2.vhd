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
use IEEE.NUMERIC_STD.ALL;

entity on_board2 is
    port(
        clk : in std_logic;
        s : in std_logic; -- BTNC
        r   : in std_logic; -- BTNR
        view : in std_logic; -- BTNU mi fa passare da modalità cronometro a modalità visualizzazione
        intertempo : in  std_logic; -- BTND 
        scroll : in std_logic; -- BTNL
        SW  : in std_logic_vector(11 downto 0); 
        anodes : out  STD_LOGIC_VECTOR (7 downto 0);
	    cathodes : out  STD_LOGIC_VECTOR (7 downto 0)
    );
end on_board2;

architecture Behavioral of on_board2 is
signal cleaned_set, cleaned_r, cleaned_i, cleaned_v, cleaned_scroll : std_logic;
type state is (idle, load_p1, load_p2, stop);
signal current_state : state := idle;

signal reg : std_logic_vector(16 downto 0) := (others => '0'); -- registro dove accumulo i valori da caricare
signal second, cset : std_logic;
signal sec, min : std_logic_vector(5 downto 0);
signal hour : std_logic_vector(4 downto 0);

signal disp_value  : std_logic_vector(31 downto 0) := (others => '0');
signal disp_enable : std_logic_vector(7 downto 0)  := (others => '0');
signal disp_dots   : std_logic_vector(7 downto 0)  := (others => '0');

signal read, write : std_logic;
signal addr_r, addr_w, selected_addr: std_logic_vector(2 downto 0);
signal count_r, count_w : unsigned(2 downto 0);
signal s_view: std_logic := '0';
signal append, viewed  : std_logic_vector(31 downto 0) := (others => '0'); -- registro di appoggio per i dati letti

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
                    reg(11 downto 0) <= SW;        -- minuti/secondi  -- RISOLTO: SW (corretto da 'sw')
                    current_state <= load_p2;
                end if;

            when load_p2 =>
                if cleaned_r = '1' then
                    reg <= (others => '0');
                    current_state <= idle;
                elsif cleaned_set = '1' then
                    reg(16 downto 12) <= SW(4 downto 0);  -- ore  -- RISOLTO: SW (corretto da 'sw')
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
    clean_scroll : entity work.ButtonDebouncer
    generic map (
        CLK_period      => 10,
        btn_noise_time  => 10_000_000
    )
    port map (
        RST         => cleaned_r,
        CLK         => clk,
        BTN         => scroll,
        CLEARED_BTN => cleaned_scroll
    );
    
    clean_intertempo : entity work.ButtonDebouncer
    generic map (
        CLK_period      => 10,
        btn_noise_time  => 10_000_000
    )
    port map (
        RST         => cleaned_r,
        CLK         => clk,
        BTN         => intertempo,
        CLEARED_BTN => cleaned_i
    );
    
    clean_view : entity work.ButtonDebouncer
    generic map (
        CLK_period      => 10,
        btn_noise_time  => 10_000_000
    )
    port map (
        RST         => cleaned_r,
        CLK         => clk,
        BTN         => view,
        CLEARED_BTN => cleaned_v
    );
    
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
    disp_value(23 downto 16) <= "000" & hour; -- 3 bit di padding
    disp_value(31 downto 24) <= (others => '0');
    
    -- abilito tutte le cifre
    disp_enable <=(others => '1');
    -- disabilito i punti
    disp_dots <= (others => '0');


    -- serve per dare indirizzo di lettura
    process(clk, cleaned_scroll, cleaned_r)
    begin
        if (rising_edge(clk)) then
            if (cleaned_r = '1') then
                read <= '0';
                count_r <= (others => '0');
            -- LETTURA SOLO SE SONO IN MODALITÀ VIEW (s_view = '1')
            elsif (cleaned_scroll = '1' and s_view = '1') then
                read <= '1';
                if (count_r < 8) then
                    count_r <= count_r + 1;
                else 
                    count_r <= (others => '0'); 
                end if;

            else 
                read <= '0';    
            end if;
        end if;
    end process;
    
    addr_r <= std_logic_vector(count_r);

    
    -- serve per dare indirizzo di scrittura
    process(clk, cleaned_i, cleaned_r)
    begin
        if (rising_edge(clk)) then
            if (cleaned_r = '1') then
                write <= '0';
                count_w <= (others => '0');

            -- SCRITTURA SOLO SE NON SONO IN VIEW (s_view = '0')
            elsif (cleaned_i = '1' and s_view = '0') then
                write <= '1';
                if (count_w < 8) then
                    count_w <= count_w + 1;
                else 
                    count_w <= (others => '0'); 
                end if;

            else 
                write <= '0';    
            end if;
        end if;
    end process;

    addr_w <= std_logic_vector(count_w);

    
    process(clk,cleaned_v, cleaned_r)
    begin
        if(rising_edge (clk)) then 
            if(cleaned_v = '1') then
                s_view <= not(s_view); -- inverte la polarità in modo da star sicuri di stare in quella posizione
            elsif (r = '1') then
                s_view <= '0'; -- lo riporto al valore iniziale
            end if;
        end if;
    end process;
    
    -- selezione l'indirizzo in base a se sto scrivendo o se sto leggendo 
    selected_addr <= addr_r when s_view = '1' else addr_w;
    
    mem0 : entity work.memory
    generic map(
        n     => 8,
        depth => 3
    )
    port map(
        clk  => clk,
        addr => selected_addr,      -- indirizzo selezionato dal mux
        r    => cleaned_r,             -- reset 
        read => read,
        w    => write,
        din  => disp_value,
        dout => append -- registro di appoggio per i dati letti per stabilizzare
    );
    
    -- in base a se sto visualizzando gli intertempi o visualizzando lo scorrimento del cronometro
    viewed <= append when s_view = '1' else  disp_value;
    
    display_inst : entity work.display_seven_segments
        generic map (
            clock_frequency_in  => 100000000, -- clock Nexys (100 MHz)
            clock_frequency_out => 500        -- frequenza di multiplex 
        )
        port map (
            clock      => clk,
            reset      => cleaned_r,      
            value32_in => viewed,
            enable     => disp_enable,
            dots       => disp_dots,
            anodes     => anodes,
            cathodes   => cathodes         
        );
 
end Behavioral;
