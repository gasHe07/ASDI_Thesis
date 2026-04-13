----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025
-- Module Name: top_module - Behavioral
-- Description: Top module che collega Node_A e Node_B con handshake req/ack
--              e passaggio dati dalla ROM di Node_A a Node_B.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    generic (n : positive range 1 to 32 := 8); 
    Port ( clk   : in  STD_LOGIC;
           r     : in  STD_LOGIC;
           start : in  STD_LOGIC;
           dout  : out STD_LOGIC_VECTOR(n/2 -1 downto 0)  -- dati finali dalla macchina di Node_B
    );
end top_module;

architecture Behavioral of top_module is

    -- Segnali interni per il protocollo req/ack e i dati
    signal req_sig : STD_LOGIC := '0';              -- uscita Node_A / ingresso Node_B
    signal ack_sig : STD_LOGIC := '0';              -- uscita Node_B / ingresso Node_A
    signal val_sig : STD_LOGIC_VECTOR(n - 1 downto 0); -- dati letti da Node_A (ROM)

begin

    --------------------------------------------------------------------------
    -- Instanza Node_A
    -- Node_A legge la ROM, genera req e riceve ack da Node_B
    --------------------------------------------------------------------------
    NODO_A : entity work.node_a
        generic map(n => n)
        port map(
            clk   => clk,
            r     => r,
            start => start,
            req   => req_sig,
            ack   => ack_sig,
            dout  => val_sig
        );

    --------------------------------------------------------------------------
    -- Instanza Node_B
    -- Node_B riceve req, genera ack, acquisisce i dati da Node_A
    -- e li passa alla sua macchina interna (dout)
    --------------------------------------------------------------------------
    NODO_B : entity work.node_b
        generic map(n => n)
        port map(
            clk   => clk,
            r     => r,
            start => start,
            req   => req_sig,
            ack   => ack_sig,
            din   => val_sig,
            dout  => dout
        );

end Behavioral;
