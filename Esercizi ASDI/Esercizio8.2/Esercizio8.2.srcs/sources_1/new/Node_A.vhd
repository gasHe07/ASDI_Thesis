----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025 18:47:45
-- Design Name: 
-- Module Name: Node_A - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Node_A is
    generic(n : positive range 1 to 32 := 8); 
    Port ( start : in STD_LOGIC;
           clk : in STD_LOGIC;
           r : in STD_LOGIC;
           req : out STD_LOGIC;
           ack : in STD_LOGIC;
           done : in STD_LOGIC;
           dout : out std_logic_vector(n - 1 downto 0));
end Node_A;

architecture Behavioral of Node_A is
    signal count  : unsigned(n/2 - 1 downto 0) := (others => '0');
    signal readed : STD_LOGIC_VECTOR (n - 1 downto 0);

    type state is (idle, requ, wait_ack,wait_done,inc_count, verify);
    signal current : state := idle;

    signal my_req : STD_LOGIC := '0';

begin

    ROM : entity work.rom
        generic map (
            word  => n,
            depth => n/2
        )
        port map (
            addr => std_logic_vector(count),
            dout => readed
        );

    CTRL_UNIT : process(clk, r)
    begin
        if r = '1' then
            current <= idle;
            count   <= (others => '0');
            my_req  <= '0';
        elsif rising_edge(clk) then
            case current is 
                when idle =>
                    if start = '1' then
                        current <= requ;
                    end if;
                when requ =>
                    my_req <= '1';
                    current <= wait_ack;
                when wait_ack =>
                    if ack = '1' then
                       current <= wait_done;
                    end if;
                when wait_done =>
                    my_req <= '0';
                    if done = '1' then
                       current <= inc_count;
                    end if;
                when inc_count =>
                    count <= count + 1;
                    current <= verify;
                when verify =>
                    if count < (2**count'length - 1) then
                      current <= requ;
                    else
                      count   <= (others => '0');
                      current <= idle;
                    end if;

            end case;
        end if;
    end process;

    dout <= readed;
    req  <= my_req;
end Behavioral;
