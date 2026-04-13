----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2025 15:50:05
-- Design Name: 
-- Module Name: shiftreg - Behavioral
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

entity shiftreg is
    generic (
            n: positive :=4
        );
    Port ( i : in STD_LOGIC_VECTOR (1 downto 0); -- i(0) ingresso dx, i(1) ingresso sx
           clk : in STD_LOGIC;  
           rst : in STD_LOGIC;
           dir : in STD_LOGIC; -- serve per dare la direzione
           m : in STD_LOGIC; -- modalità ad 1 bit e 2 bit 
           y : out STD_LOGIC; -- uscita MSB
           q : out STD_LOGIC_VECTOR (n-1 downto 0)); 
end shiftreg;

architecture Behavioral of shiftreg is
signal shift : STD_LOGIC_VECTOR (n-1 downto 0); 
begin
process(clk) 
begin 
    case m is 
        -- 1 bit
        when '0'=>
        case dir is 
            -- shift a dx
            when '0' =>
            if (rst = '1')then 
                    shift <= (others => '0');
                elsif (rising_edge(clk)) then
                    shift <= shift(n-2 downto 0) & i(0);  -- metto in ingresso a dx      
            end if;
        -- shift i a sx    
        when '1' =>
            if (rst = '1')then 
                    shift <= (others => '0');
                elsif (rising_edge(clk)) then
                    shift <= i(1) & shift(n-2 downto 0);  -- metto in ingresso a sx      
            end if;
        when others =>
                shift<= (others => '0');   
        end case;
        
        when '1' =>
        case dir is 
            when '0' =>
            if (rst = '1') then 
                shift <= (others => '0');
             elsif (rising_edge(clk)) then
                shift <= shift(n-3 downto 0) & i(0) & i(0);
            end if;
            when '1' =>
            if (rst = '1') then
                shift <= (others => '0');
            elsif (rising_edge(clk)) then
                shift <= i(1) & i(1) & shift(n-3 downto 0);
            end if; 
            when others =>
                shift<= (others => '0');   
                
        end case;   
        
        when others =>
                shift<= (others => '0');    
        
    end case;
    
    q <= shift;
    y <= shift(n-1);

end process;
end Behavioral;


architecture structural of shiftreg is

    -- DFF componente già presente nel tuo file
    component FFD is 
        Port ( d   : in  STD_LOGIC;
               clk : in  STD_LOGIC;
               rst : in  STD_LOGIC;
               q   : out STD_LOGIC);
    end component;

    -- MUX 4:1 con 4 ingressi e 2 bit di selezione
    component mux4_1 is
        Port ( i : in  STD_LOGIC_VECTOR (3 downto 0);
               s : in  STD_LOGIC_VECTOR (1 downto 0);
               y : out STD_LOGIC);
    end component;

     signal shift : STD_LOGIC_VECTOR(n-1 downto 0);
    signal sel   : STD_LOGIC_VECTOR(1 downto 0);
    signal mux_in : STD_LOGIC_VECTOR(3 downto 0);
    
begin

    sel(0) <= dir;
    sel(1) <= m;
    
    gen_shif: for j in 0 to n-1 generate
    
        signal mux_out : std_logic;
        begin
        -- calolo ingressi mux
        process(shift,i)
        begin
            -- shift a dx di un bit
            if j = 0 then
                mux_in(0) <= i(0);
            else
                mux_in(0) <= shift(j-1);
            end if;
            
            -- shift sx 1-bit
            if j = n-1 then
                mux_in(1) <= i(1);
            else
                mux_in(1) <= shift(j+1);
            end if;

            -- shift dx 2-bit
            if j < 2 then
                mux_in(2) <= i(0);
            else
                mux_in(2) <= shift(j-2);
            end if;

            -- shift sx 2-bit
            if j > n-3 then
                mux_in(3) <= i(1);
            else
                mux_in(3) <= shift(j+2);
            end if;
        end process;
        
        -- Istanzia il MUX 4:1
        mux_inst: mux4_1
            port map(
                i => mux_in,
                s => sel,
                y => mux_out
            );

        -- Istanzia il DFF
        dff_inst: ffd
            port map(
                d   => mux_out,
                clk => clk,
                rst => rst,
                q   => shift(j)
            );
        
    end generate;
    
    q <= shift;
    y <= shift(n-1);


end Structural;
