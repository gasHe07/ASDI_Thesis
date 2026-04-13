----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025 14:40:25
-- Design Name: 
-- Module Name: Node_B - Behavioral
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

entity Node_B is
    generic (n : positive range 1 to 32 := 8);
    Port ( start : in STD_LOGIC; 
           clk : in STD_LOGIC;
           r : in STD_LOGIC;
           ack : out STD_LOGIC;
           din : in STD_LOGIC_VECTOR (n - 1 downto 0);
           req : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (n/2 - 1 downto 0));
end Node_B;

architecture Behavioral of Node_B is
type state is (idle, wait_req, send_ack, acquire);
signal current : state := idle;
signal my_ack : std_logic := '0';
signal u0 : STD_LOGIC_VECTOR (n - 1 downto 0);

begin
    Machine : entity work.machine
        generic map (word => n)
        port map(
            val => u0,
            dout => dout
        );
    
    FSM: process(clk,r)
    begin
        if r = '1' then
            current <= idle;
        elsif rising_edge(clk) then
            case current is 
                -- caso idle
                when idle =>
                    if start = '1' then
                        current <= wait_req;
                    end if;
                -- caso wait
                when wait_req =>
                    if req = '1' then
                        current <= send_ack;
                    end if;
                -- caso send ack
                when send_ack => 
                    my_ack <= '1';
                    current <= acquire;
                when acquire =>
                    my_ack <= '0';
                    u0 <= din;
                    current <= wait_req;    
            end case;
         end if;
    end process;
    
    ack <= my_ack;

end Behavioral;
