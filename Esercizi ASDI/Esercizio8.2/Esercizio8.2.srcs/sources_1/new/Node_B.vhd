----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025 18:57:53
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
    Port (
        start : in  STD_LOGIC; 
        clk   : in  STD_LOGIC;
        r     : in  STD_LOGIC;
        req   : in  STD_LOGIC;
        ack   : out STD_LOGIC;
        done  : out STD_LOGIC;
        din   : in  STD_LOGIC_VECTOR (n - 1 downto 0);
        dout  : out STD_LOGIC_VECTOR (n/2 - 1 downto 0)
    );
end Node_B;

architecture Behavioral of Node_B is

    type state is (
        idle,
        wait_req,
        send_ack,
        acquire,
        send_done
    );

    signal current : state := idle;

    signal my_ack  : STD_LOGIC := '0';
    signal my_done : STD_LOGIC := '0';

    signal u0 : STD_LOGIC_VECTOR (n - 1 downto 0);

begin
    Machine : entity work.machine
        generic map (word => n)
        port map(
            val  => u0,
            dout => dout
        );
    FSM : process(clk, r)
    begin
        if r = '1' then
            current <= idle;
            my_ack  <= '0';
            my_done <= '0';
        elsif rising_edge(clk) then
            case current is
                when idle =>
                    if start = '1' then
                        current <= wait_req;
                    end if;
                when wait_req =>
                    my_done <= '0';
                    if req = '1' then
                        current <= send_ack;
                    end if;
                when send_ack =>
                    my_ack  <= '1';
                    my_done <= '0';
                    current <= acquire;
                when acquire =>
                    u0      <= din;      -- acquisizione certa del dato
                    current <= send_done;
                when send_done =>
                    my_done <= '1';      -- segnalo acquisizione completata
                    current <= wait_req;
            end case;
        end if;
    end process;

    ack  <= my_ack;
    done <= my_done;

end Behavioral;