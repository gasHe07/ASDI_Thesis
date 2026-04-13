library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_combnet is
-- Testbench non ha porte
end tb_combnet;

architecture behavior of tb_combnet is
    -- segnali per collegare al DUT
    signal addr : STD_LOGIC_VECTOR(3 downto 0);
    signal dout : STD_LOGIC_VECTOR(2 downto 0);
begin
    -- istanza del DUT (Device Under Test)
    dut: entity work.combnet
        port map(
            addr => addr,
            dout => dout
        );

    -- processo di stimolo
    stim_proc: process
    begin
        
        -- ciclo attraverso tutti gli indirizzi da 0 a 15
        for i in 0 to 15 loop
            addr <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;
        end loop;

        -- lascia l'ultimo valore stabile per osservazione
        wait for 50 ns;

        -- fine simulazione
        wait;
    end process;

end behavior;
