----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025 19:00:31
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module is
    generic (
        n : positive range 1 to 32 := 8
    );
    Port (
        clk   : in  STD_LOGIC;
        r     : in  STD_LOGIC;
        start : in  STD_LOGIC;
        dout  : out STD_LOGIC_VECTOR(n/2 - 1 downto 0)
    );
end top_module;

architecture Behavioral of top_module is

    -- segnali handshake
    signal req_sig  : STD_LOGIC;
    signal ack_sig  : STD_LOGIC;
    signal done_sig : STD_LOGIC;

    -- bus dati tra Node_A e Node_B
    signal val_sig  : STD_LOGIC_VECTOR(n - 1 downto 0);

begin

    NODO_A : entity work.Node_A
        generic map (
            n => n
        )
        port map (
            clk   => clk,
            r     => r,
            start => start,
            req   => req_sig,
            ack   => ack_sig,
            done  => done_sig,
            dout  => val_sig
        );


    NODO_B : entity work.Node_B
        generic map (
            n => n
        )
        port map (
            clk   => clk,
            r     => r,
            start => start,
            req   => req_sig,
            ack   => ack_sig,
            done  => done_sig,
            din   => val_sig,
            dout  => dout
        );

end Behavioral;
