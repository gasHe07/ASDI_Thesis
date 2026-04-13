----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2025 16:42:16
-- Design Name: 
-- Module Name: Booth_on_board - Behavioral
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

entity Booth_on_board is
    Port ( clk, r, start, load : in STD_LOGIC; -- escluso il clk, btnd, btnc, btnu
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           cat : out std_logic_vector(7 downto 0);
           AN : out std_logic_vector(7 downto 0)
           );
end Booth_on_board;

architecture Behavioral of Booth_on_board is

signal cleaned_start, cleaned_r, cleaned_load : std_logic;
signal upper, lower : STD_LOGIC_VECTOR (15 downto 0);
signal computed, inculata : std_logic_vector(31 downto 0);



-- segnali per il moltiplicatore Booth
signal P_s      : std_logic_vector(15 downto 0);
signal stop_s   : std_logic;
signal X_s, Y_s : std_logic_vector(7 downto 0);

begin
    upper <= (others => '0'); -- parte alta a zero

    RESET_DEBOUNCER: entity work.ButtonDebouncer
        port map(
            clk => clk,
            rst => '0',
            btn => r,
            CLEARED_BTN => cleaned_r
        );
            
    Start_DEBOUNCER: entity work.ButtonDebouncer
        port map(
            clk => clk,
            rst => cleaned_r,
            btn => start,
            CLEARED_BTN => cleaned_start
        );
            
    Load_DEBOUNCER: entity work.ButtonDebouncer
        port map(
            clk => clk,
            rst => cleaned_r,
            btn => load,
            CLEARED_BTN => cleaned_load
        );

    -- Caricamento moltiplicatore e moltiplicando
    LOADING: process(cleaned_load, cleaned_r)
    begin
        if cleaned_load = '1' then 
            lower <= SW;
        elsif cleaned_r = '1' then
            lower <= (others => '0');
        end if;
    end process;

    -- Mappatura switch ? X e Y
    X_s <= lower(15 downto 8);
    Y_s <= lower(7 downto 0);

    --------------------------------------------------------------------
    --  ISTANZA DEL MOLTIPLICATORE BOOTH
    --------------------------------------------------------------------
    BOOTH_INST : entity work.Booth_mol
        port map(
            clock   => clk,
            reset   => cleaned_r,
            start   => cleaned_start,
            X       => X_s,
            Y       => Y_s,
            P       => P_s,
            stop_cu => stop_s
        );

    -- Risultato esteso a 32 bit per il display
    computed <= upper & P_s;

    --------------------------------------------------------------------
    -- DISPLAY A 7 SEGMENTI
    --------------------------------------------------------------------
    display_inst : entity work.display_seven_segments
        generic map (
            clock_frequency_in  => 100000000,
            clock_frequency_out => 500
        )
        port map (
            clock      => clk,
            reset      => cleaned_r,      
            value32_in => computed,
            enable     => "11111111",
            dots       => "00000000",
            anodes     => an,
            cathodes   => cat         
        );
 
end Behavioral;
