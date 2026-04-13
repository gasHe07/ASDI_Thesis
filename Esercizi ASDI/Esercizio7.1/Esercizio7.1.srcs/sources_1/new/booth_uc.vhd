library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth_uc is
    Port ( 
        clk, r, start : in  std_logic;
        q0, q_1       : in  std_logic;
        count         : in  std_logic_vector(2 downto 0);

        loadM, loadAQ : out std_logic;
        shift         : out std_logic;
        count_in      : out std_logic;
        selM, selAQ   : out std_logic;
        selF, sub     : out std_logic
    );
end booth_uc;


architecture Behavioral of booth_uc is

    type state is (idle, acquire, booth_op, shifting);
    signal current : state := idle;

begin

    process(clk, r)
    begin
        if r = '1' then
            loadM    <= '0';
            loadAQ   <= '0';
            shift    <= '0';
            count_in <= '0';
            selM     <= '0';
            selAQ    <= '0';
            selF     <= '0';
            sub      <= '0';
            current  <= idle;

        elsif rising_edge(clk) then

            -- default
            loadM    <= '0';
            loadAQ   <= '0';
            shift    <= '0';
            count_in <= '0';
            selM     <= '0';
            selAQ    <= '0';
            selF     <= '0';
            sub      <= '0';

            case current is

                when idle =>
                    if start = '1' then
                        current <= acquire;
                    end if;

                when acquire =>
                    loadM  <= '1';
                    selAQ  <= '0';
                    loadAQ <= '1';
                    current <= booth_op;

                when booth_op =>
                    if q0 = q_1 then
                        selM   <= '0';
                        loadAQ <= '0';

                    elsif q0 = '1' and q_1 = '0' then
                        selM   <= '1';
                        sub    <= '1';
                        loadAQ <= '1';

                    else
                        selM   <= '1';
                        sub    <= '0';
                        loadAQ <= '1';
                    end if;

                    current <= shifting;

                when shifting =>
                    shift    <= '1';
                    selF     <= '0';
                    count_in <= '1';

                    if count /= "111" then
                        current <= booth_op;
                    else
                        current <= idle;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;
