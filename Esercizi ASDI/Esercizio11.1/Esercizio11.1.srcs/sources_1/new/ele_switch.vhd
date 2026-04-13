----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2025 09:57:04
-- Design Name: 
-- Module Name: ele_switch - Behavioral
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

-- la traccia non parlava di invio di bit o word, quindi mi sono messo nel caso
-- dell'invio della word
entity ele_switch is
    Port (
        x0, x1 : in  STD_LOGIC_VECTOR(3 downto 0);  -- due ingressi da 4 bit
        src    : in  STD_LOGIC;                     -- controlla il MUX (da s)
        dest   : in  STD_LOGIC;                     -- controlla il DEMUX (da d)
        y0, y1 : out STD_LOGIC_VECTOR(3 downto 0)   -- due uscite da 4 bit
    );
end ele_switch;

architecture Behavioral of ele_switch is
    signal mux_out : STD_LOGIC_VECTOR(3 downto 0);
begin

    -- MUX 2?1 : seleziona quale dei due ingressi passa
    mux_out <= x0 when src = '0' else x1;

    -- DEMUX 1?2 : instrada l'uscita verso y0 o y1
    -- nelle uscite non attive mettiamo '-' (don't care)
    y0 <= mux_out when dest = '0' else (others => '-');
    y1 <= mux_out when dest = '1' else (others => '-');

end Behavioral;
