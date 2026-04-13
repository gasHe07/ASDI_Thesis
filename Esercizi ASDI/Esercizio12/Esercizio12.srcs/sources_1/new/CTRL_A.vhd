----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 09:57:31
-- Design Name: 
-- Module Name: CTRL_A - Behavioral
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

entity CTRL_A is
    Port ( clk, r, start, ack, end_op : in STD_LOGIC;
           startc, en, load, req : out STD_LOGIC;
           count : in STD_LOGIC_VECTOR (3 downto 0));
end CTRL_A;

architecture Behavioral of CTRL_A is

type state is (idle, first, store, compute, wait_c, send_req, wait_ack, verify);
signal current : state := idle;

begin

FSM : process(clk, r)
begin
    if r = '1' then
        startc <= '0';
        en <= '0';
        load <= '0';
        req <= '0';
        current <= idle;

    elsif rising_edge(clk) then
        -- default
        startc <= '0';
        en <= '0';
        load <= '0';
        req <= '0';

        case current is

            when idle =>
                if start = '1' then
                    current <= first;
                end if;

            when first =>
                load <= '1';      -- carica primo valore nel registro
                current <= store;

            when store =>
                en <= '1';        -- incrementa indirizzo ROM
                current <= compute;

            when compute =>
                startc <= '1';    -- avvia Booth
                current <= wait_c;

            when wait_c =>
                if end_op = '1' then
                    current <= send_req;
                end if;

            when send_req =>
                req <= '1';
                current <= wait_ack;

            when wait_ack =>
                 req <= '1';
                if ack = '1' then
                    current <= verify;
                end if;

            when verify =>
                if count /= "1111" then
                    en <= '1';
                    current <= first;
                else
                    current <= idle;
                end if;

        end case;
    end if;
end process;

end Behavioral;
