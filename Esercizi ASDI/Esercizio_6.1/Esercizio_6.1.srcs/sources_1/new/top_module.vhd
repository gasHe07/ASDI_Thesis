----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025
-- Design Name: 
-- Module Name: top_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Top module con FSM, contatore, ROM, memoria e comparatore
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Top module con FSM, contatore, ROM, memoria e comparatore
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    Port (
        clk   : in std_logic;
        start : in std_logic;
        read  : in std_logic;
        r     : in std_logic;  -- reset attivo alto
        y     : out std_logic
    );
end top_module;

architecture Behavioral of top_module is

    -- Tipi e FSM
    type state_type is (S0, S1, S2);
    signal stato_corrente, stato_prossimo : state_type := S0;

    -- Segnali di controllo
    signal read_ROM, write_MEM : std_logic := '0';

    -- Segnali per contatore, ROM e memoria
    signal dout       : std_logic_vector(2 downto 0);  -- address
    signal readed     : std_logic_vector(7 downto 0);  -- dato ROM
    signal reg_readed : std_logic_vector(7 downto 0);  -- dato registrato
    signal str        : std_logic_vector(7 downto 0) := "00000101";

    -- Segnale pushed
    signal pushed     : std_logic := '0';

    -- Segnale y registrato
    signal y_reg      : std_logic := '0';

begin

    --------------------------------------------------------------------------
    -- Latch "pushed": resta alto dopo un impulso di start
    --------------------------------------------------------------------------
    process(clk, r)
    begin
        if r = '1' then
            pushed <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                pushed <= '1';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- FSM combinatoria
    --------------------------------------------------------------------------
    fsm_comb : process(stato_corrente, pushed, r)
    begin
        -- default
        read_ROM  <= '0';
        write_MEM <= '0';
        case stato_corrente is
            when S0 =>
                if r = '1' then
                    stato_prossimo <= S0;
                elsif pushed = '1' then
                    stato_prossimo <= S1;
                else
                    stato_prossimo <= S0;
                end if;
            when S1 =>
                read_ROM <= '1';
                if r = '1' then
                    stato_prossimo <= S0;
                else
                    stato_prossimo <= S2;
                end if;
            when S2 =>
                read_ROM  <= '1';
                write_MEM <= '1';
                if r = '1' then
                    stato_prossimo <= S0;
                else
                    stato_prossimo <= S1;
                end if;
        end case;
    end process;

    --------------------------------------------------------------------------
    -- FSM sincrona
    --------------------------------------------------------------------------
    fsm_sync : process(clk)
    begin
        if rising_edge(clk) then
            stato_corrente <= stato_prossimo;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Contatore abilitato SOLO da read
    --------------------------------------------------------------------------
    contatore : entity work.counter_mod_60
        generic map(
            max   => 8,
            depth => 3
        )
        port map(
            en   => read,   --  unica sorgente di enable
            clk  => clk,
            r    => r,
            dout => dout
        );

    --------------------------------------------------------------------------
    -- ROM
    --------------------------------------------------------------------------
    r0m : entity work.rom
        generic map(
            word  => 8,
            depth => 3
        )
        port map(
            addr => dout,
            clk  => clk,
            read => read_ROM,
            dout => readed
        );

    --------------------------------------------------------------------------
    -- Registro per dato ROM stabilizzato
    --------------------------------------------------------------------------
    process(clk, r)
    begin
        if r = '1' then
            reg_readed <= (others => '0');
        elsif rising_edge(clk) then
            if read_ROM = '1' then
                reg_readed <= readed;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------
    -- Comparatore: y alto un ciclo quando reg_readed = str
    --------------------------------------------------------------------------
    process(clk, r)
    begin
        if r = '1' then
            y_reg <= '0';
        elsif rising_edge(clk) then
            if reg_readed = str then
                y_reg <= '1';
            else
                y_reg <= '0';
            end if;
        end if;
    end process;

    y <= y_reg;

    --------------------------------------------------------------------------
    -- Memoria
    --------------------------------------------------------------------------
    memory : entity work.mem
        generic map(
            word  => 8,
            depth => 3
        )
        port map(
            din   => reg_readed,
            addr  => dout,
            write => write_MEM,
            clk   => clk,
            r     => r
        );

end Behavioral;

