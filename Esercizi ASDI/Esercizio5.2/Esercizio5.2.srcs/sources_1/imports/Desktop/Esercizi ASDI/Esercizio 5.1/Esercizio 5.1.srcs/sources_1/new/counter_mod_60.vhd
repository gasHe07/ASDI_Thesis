library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_mod_60 is
    generic (max : integer := 60;
             depth : integer := 5
            );
    Port ( 
        en        : in STD_LOGIC;
        clk       : in STD_LOGIC;
        set       : in STD_LOGIC;                      -- nuovo segnale SET
        init_val  : in STD_LOGIC_VECTOR(depth downto 0);   -- valore da caricare
        r         : in STD_LOGIC;
        dout      : out STD_LOGIC_VECTOR (depth downto 0);
        carry_out : out STD_LOGIC
    );
end counter_mod_60;

architecture Behavioral of counter_mod_60 is
    signal count : unsigned(depth downto 0) := (others => '0');
begin

    -------------------------------------------------------------------
    -- PROCESSO PRINCIPALE (reset asincrono, set sincronizzato)
    -------------------------------------------------------------------
    process(clk, r)
    begin
        if r = '1' then
            count <= (others => '0');

        elsif rising_edge(clk) then

            if set = '1' then
                count <= unsigned(init_val);            -- set sincrono

            elsif en = '1' then
                if count = max - 1 then
                    count <= (others => '0');           -- overflow
                else
                    count <= count + 1;
                end if;

            end if;

        end if;
    end process;


    -------------------------------------------------------------------
    -- CARRY OUT SUL FRONTE DI DISCESA
    -------------------------------------------------------------------
    process(clk, r)
    begin
        if r = '1' then
            carry_out <= '0';

        elsif falling_edge(clk) then

            if en = '1' then
                if count = max - 1 then
                    carry_out <= '1';                   -- impulso
                else
                    carry_out <= '0';
                end if;
            else
                carry_out <= '0';
            end if;

        end if;
    end process;


    dout <= std_logic_vector(count);

end Behavioral;
