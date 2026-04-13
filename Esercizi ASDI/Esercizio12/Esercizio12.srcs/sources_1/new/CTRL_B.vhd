----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.01.2026 13:58:55
-- Design Name: 
-- Module Name: CTRL_B - Behavioral
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

entity CTRL_B is
    Port ( clk, start, r, req : in STD_LOGIC;
           count : in STD_LOGIC_VECTOR (2 downto 0);
           res : in STD_LOGIC_VECTOR (1 downto 0);
           ack, load, write, en : out STD_LOGIC);
end CTRL_B;

architecture Behavioral of CTRL_B is
type state is (idle, wait_req, send_ack, cmp, mem, inc_count, verify);
signal current : state := idle;
begin
FSM : process(clk, r)
      begin
        if r = '1' then
            ack <= '0';
            load <= '0';
            write <= '0';
            en <= '0';
            current <= idle;
            
        elsif rising_edge(clk) then 
            -- default
            ack <= '0';
            load <= '0';
            write <= '0';
            en <= '0';
            
            case current is
                when idle =>
                    if start = '1' then
                        current <= wait_req;
                    end if;
                    
                when wait_req => 
                    if req = '1' then 
                        current <= send_ack;
                    end if;    
                    
                when send_ack => 
                    ack <= '1';
                    load <= '1';
                    current <= cmp;
                when cmp => -- ipotizzo che il comparatore abbia tempi di propagazione < di clk
                    if res = "10" then
                        current <= mem;
                    else current <= inc_count;
                    end if;    
                
                when mem => 
                    write <= '1';
                    current <= inc_count;
                    
                when inc_count =>
                    en <= '1';
                    current <= verify;
                    
                when verify =>
                    if count /= "111" then
                        current <= wait_req;
                    else current <= idle;
                    end if;
                
            end case;
        end if;
      end process;
end Behavioral;
