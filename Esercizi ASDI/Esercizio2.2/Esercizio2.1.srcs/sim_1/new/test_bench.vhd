library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_comb_net is
end tb_comb_net;

architecture test of tb_comb_net is
    -- Parametri da usare anche nel DUT
    constant word   : positive := 8;
    constant deepth : positive := 4;

    -- Segnali per collegare il DUT
    signal addr : std_logic_vector(deepth - 1 downto 0) := (others => '0');
    signal dout : std_logic_vector(word/2 - 1 downto 0);

begin

    -- istanziazione del DUT
    uut: entity work.comb_net
        generic map(
            word   => word,
            deepth => deepth
        )
        port map(
            addr => addr,
            dout => dout
        );

    -- processo di stimolo
    stim_proc: process
    begin
        for i in 0 to 2**deepth - 1 loop
            addr <= std_logic_vector(to_unsigned(i, deepth));
            wait for 10 ns;
        end loop;

        wait; -- fine simulazione
    end process;

end test;
