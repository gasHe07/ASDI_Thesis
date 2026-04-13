library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
    port(
        parallel_in  : in  std_logic_vector(7 downto 0);
        serial_in    : in  std_logic;
        clock, reset : in  std_logic;
        load, shift  : in  std_logic;
        parallel_out : out std_logic_vector(7 downto 0)
    );
end shift_register;

architecture behavioural of shift_register is

    signal temp : std_logic_vector(7 downto 0);

begin

    SR : process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                temp <= (others => '0');

            elsif load = '1' then
                temp <= parallel_in;

            elsif shift = '1' then
                temp(6 downto 0) <= temp(7 downto 1);  -- shift right
                temp(7) <= serial_in;                  -- nuovo bit in ingresso
            end if;
        end if;
    end process;

    parallel_out <= temp;

end behavioural;
