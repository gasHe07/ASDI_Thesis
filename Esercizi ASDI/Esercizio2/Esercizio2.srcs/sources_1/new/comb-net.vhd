----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2025 10:49:48
-- Design Name: 
-- Module Name: comb-net - structural
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

entity combnet is
    Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (2 downto 0));
end combnet;

architecture structural of combnet is

    signal u : STD_LOGIC_VECTOR (3 downto 0);
    
    --dichiaro i componenti
    component rom 
        Port ( addr : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
           
    component machine
         Port ( val : in STD_LOGIC_VECTOR (3 downto 0);
           dout : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
begin
    --composizione
    mrom : rom port map(
        addr => addr,
        dout => u
    );
    
    mc : machine port map(
        val => u,
        dout => dout
    );

end structural;
