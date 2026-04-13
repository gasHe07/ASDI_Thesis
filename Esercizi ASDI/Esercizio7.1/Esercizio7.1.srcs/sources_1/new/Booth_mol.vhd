----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.12.2025 14:58:54
-- Design Name: 
-- Module Name: Booth_mol - Behavioral
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

entity Booth_mol is
port( clock, reset, start: in std_logic;
		   X, Y: in std_logic_vector(7 downto 0);		   
		   --stop: out std_logic;	--a che serve?	   
		   P: out std_logic_vector(15 downto 0);
		   stop_cu: out std_logic);
end Booth_mol;

architecture Behavioral of Booth_mol is

    --------------------------------------------------------------------
    --  Segnali di collegamento CU ? UO
    --------------------------------------------------------------------
    signal loadM_s    : std_logic;
    signal loadAQ_s   : std_logic;
    signal shift_s    : std_logic;
    signal count_in_s : std_logic;
    signal selM_s     : std_logic;
    signal selAQ_s    : std_logic;
    signal selF_s     : std_logic;
    signal sub_s      : std_logic;

    --------------------------------------------------------------------
    --  Segnali di collegamento UO ? CU
    --------------------------------------------------------------------
    signal q0_s       : std_logic;
    signal q_1_s      : std_logic;
    signal count_s    : std_logic_vector(2 downto 0);

begin

    --------------------------------------------------------------------
    --  Unità Operativa (boot_uo)
    --------------------------------------------------------------------
    UO: entity work.boot_uo
        port map(
            X        => X,
            Y        => Y,
            clock    => clock,
            reset    => reset,

            loadAQ   => loadAQ_s,
            shift    => shift_s,
            loadM    => loadM_s,
            sub      => sub_s,
            selM     => selM_s,
            selAQ    => selAQ_s,
            selF     => selF_s,
            count_in => count_in_s,

            count    => count_s,
            q0       => q0_s,
            q_1      => q_1_s,
            P        => P
        );

    --------------------------------------------------------------------
    --  Unità di Controllo (booth_uc)
    --------------------------------------------------------------------
    CU: entity work.booth_uc
        port map(
            clk      => clock,
            r        => reset,
            start    => start,

            q0       => q0_s,
            q_1      => q_1_s,
            count    => count_s,

            loadM    => loadM_s,
            loadAQ   => loadAQ_s,
            shift    => shift_s,
            count_in => count_in_s,
            selM     => selM_s,
            selAQ    => selAQ_s,
            selF     => selF_s,
            sub      => sub_s
        );

    --------------------------------------------------------------------
    --  Segnale di fine (puoi adattarlo alla tua logica)
    --------------------------------------------------------------------
    stop_cu <= '1' when count_s = "111" else '0';

end Behavioral;
