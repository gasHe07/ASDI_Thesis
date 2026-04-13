----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2025 11:27:14
-- Design Name: 
-- Module Name: cronometro - Behavioral
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

entity cronometro is
    Port ( en : in STD_LOGIC; -- ingresso da dare al primo contatore
           clk : in STD_LOGIC; -- sincronizzazione 
           r : in STD_LOGIC; -- segnale di reset
           init_val_s : in std_logic_vector(5 downto 0);
           init_val_m : in std_logic_vector(5 downto 0);
           init_val_h : in std_logic_vector(4 downto 0);
           set: in std_logic;
           doutsec : out STD_LOGIC_VECTOR (5 downto 0); -- uscita dei secondi
           doutmin : out STD_LOGIC_VECTOR (5 downto 0); -- uscita dei minuti 
           douth : out STD_LOGIC_VECTOR (4 downto 0)); -- uscita delle ore 
end cronometro;

architecture Structural of cronometro is

signal u0,u1 : std_logic; -- segnali per interconnettere il contatori

component counter_mod_60
     Port ( en : in STD_LOGIC;
           clk : in std_logic;
           set : in std_logic;
           init_val : in std_logic_vector(5 downto 0);
           r : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (5 downto 0);
           carry_out : out STD_LOGIC);
end component;

begin
    seconds_counter : counter_mod_60
        port map(
            en => en,
            clk => clk,
            set => set,
            init_val => init_val_s,
            r => r,
            dout => doutsec,
            carry_out => u0
        );    
     minutes_counter : counter_mod_60
        port map(
            en => u0,
            clk => clk,
            set => set,
            init_val => init_val_m,
            r => r,
            dout => doutmin,
            carry_out => u1
            );
   
    hour_counter : entity work.counter_mod_60 -- se non lo dichiaro cos? non potrei fare il generic port map per scalare a mod 24
    generic map (
        max => 24,
        depth => 4
        
    )
    port map (
        en        => u1,
        clk       => clk,
        set => set,
        init_val => init_val_h,
        r         => r,
        dout      => douth,   
        carry_out => open -- lasci aperto perch? non deve andare in ingresso ad altri
    );
    
    

end Structural;