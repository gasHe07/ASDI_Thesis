----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2025 12:09:13
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
    Port (
        clk   : in std_logic;
        start : in std_logic; -- bottone centrale
        read  : in std_logic; -- bottone sx
        r     : in std_logic;  -- bottore destro
        led0  : out std_logic; -- uscita 
        led1  : out std_logic -- uscita troppo veloce, si mantiene sempre alto 
    );
end on_board;

architecture structural of on_board is
signal cleaned_reset, cleaned_start, cleanded_read : std_logic; -- segnali bottoni "puliti"
signal y_latched, y : std_logic; -- segnali delle uscite
begin
    
    reset_deb : entity work.ButtonDebouncer
    generic map (
        CLK_period     => 10,       -- periodo del clock (della board) in ns
        btn_noise_time => 10000000  -- durata stimata del rimbalzo del pulsante
    )
    port map (
        RST         => '0', -- il reset non ha bisogno di essere resettato
        CLK         => clk,
        BTN         => r,
        CLEARED_BTN => cleaned_reset
    );
    
    start_deb : entity work.ButtonDebouncer
    generic map (
        CLK_period     => 10,       -- periodo del clock (della board) in ns
        btn_noise_time => 10000000  -- durata stimata del rimbalzo del pulsante
    )
    port map (
        RST         => cleaned_reset,
        CLK         => clk,
        BTN         => start,
        CLEARED_BTN => cleaned_start
    );
    
    read_deb : entity work.ButtonDebouncer
    generic map (
        CLK_period     => 10,       -- periodo del clock (della board) in ns
        btn_noise_time => 10000000  -- durata stimata del rimbalzo del pulsante
    )
    port map (
        RST         => cleaned_reset,
        CLK         => clk,
        BTN         => read,          
        CLEARED_BTN => cleanded_read
    );
    
    control_unit : entity work.top_module
        Port map(
        clk   => clk,
        start => cleaned_start,
        read  => cleanded_read,
        r     => cleaned_reset,
        y     => y
    );

    process(clk, r)
    begin
        if rising_edge(clk) then
            if cleaned_reset = '1' then
                y_latched <= '0';
            elsif y = '1' then
                y_latched <= y;
            end if;
        end if;
    end process;

    led0 <= y;
    led1 <= y_latched;




end structural;
