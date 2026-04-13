----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2025 12:24:25
-- Design Name: 
-- Module Name: demux1_8 - dataflow
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

entity demux1_8 is
    Port ( i : in STD_LOGIC;
           s : in STD_LOGIC_VECTOR (2 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0));
end demux1_8;

architecture dataflow of demux1_8 is

begin
    y(0) <= i when s = "000" else '-';
    y(1) <= i when s = "001" else '-';
    y(2) <= i when s = "010" else '-';
    y(3) <= i when s = "011" else '-';
    y(4) <= i when s = "100" else '-';
    y(5) <= i when s = "101" else '-';
    y(6) <= i when s = "110" else '-';
    y(7) <= i when s = "111" else '-';
    
    -- tutte le n-1 uscite devono essere - mentre i-esima = input
end dataflow;
