library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_mod_60 is
    generic (
        max : integer := 60;
        depth : integer := 5
        );
    Port ( 
        en        : in STD_LOGIC;
        clk       : in STD_LOGIC;
        r         : in STD_LOGIC;
        dout      : out STD_LOGIC_VECTOR (depth - 1 downto 0)
    );
end counter_mod_60;

architecture Behavioral of counter_mod_60 is
    signal count : unsigned(depth - 1  downto 0) := (others => '0');
begin

    process(clk, r)
    begin
        if r = '1' then
            count <= (others => '0');

        elsif rising_edge(clk) then
            if en = '1' then
                if count = max - 1 then
                    count <= (others => '0');           -- overflow
                else
                    count <= count + 1;
                end if;

            end if;

        end if;
    end process;

   dout <= std_logic_vector(count);

end Behavioral;
