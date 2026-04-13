library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rr_man is
    Port ( 
        clk, r :  in std_logic;
        A0, A1, A2, A3, A4, A5, A6, A7 : in std_logic_vector(9 downto 0); -- sel 3 bit + 3 dest + 4 payload
        s, d : out std_logic_vector(2 downto 0);
        B0, B1, B2, B3, B4, B5, B6, B7 : out std_logic_vector(3 downto 0) -- payloads (4 bit)
    );
end rr_man;

architecture Behavioral of rr_man is

    signal owner : unsigned(2 downto 0) := "000";

begin

    -- gestione del round robin
    RR: process(clk, r) 
    begin
        if r = '1' then
            owner <= "000";
        elsif rising_edge(clk) then
            owner <= owner + 1;
        end if;
    end process;
        
    -- ESTRAGGO LA SORGENTE
    with owner select
        s <= A0(9 downto 7) when "000",
             A1(9 downto 7) when "001",
             A2(9 downto 7) when "010",
             A3(9 downto 7) when "011",
             A4(9 downto 7) when "100",
             A5(9 downto 7) when "101",
             A6(9 downto 7) when "110",
             A7(9 downto 7) when "111",
             (others => '-') when others;
             
    -- ESTRAGGO LA DESTINAZIONE
    with owner select
        d <= A0(6 downto 4) when "000",
             A1(6 downto 4) when "001",
             A2(6 downto 4) when "010",
             A3(6 downto 4) when "011",
             A4(6 downto 4) when "100",
             A5(6 downto 4) when "101",
             A6(6 downto 4) when "110",
             A7(6 downto 4) when "111",
             (others => '-') when others;
             
    -- INOLTRO DEL PAYLOAD (4 bit)
    B0 <= A0(3 downto 0) when owner = "000" else (others => '-');
    B1 <= A1(3 downto 0) when owner = "001" else (others => '-');
    B2 <= A2(3 downto 0) when owner = "010" else (others => '-');
    B3 <= A3(3 downto 0) when owner = "011" else (others => '-');
    B4 <= A4(3 downto 0) when owner = "100" else (others => '-');
    B5 <= A5(3 downto 0) when owner = "101" else (others => '-');
    B6 <= A6(3 downto 0) when owner = "110" else (others => '-');
    B7 <= A7(3 downto 0) when owner = "111" else (others => '-');

end Behavioral;
