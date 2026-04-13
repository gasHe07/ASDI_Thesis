----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 16:07:08
-- Design Name: 
-- Module Name: Mux81 - Dataflow
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

entity Mux81 is
    Port ( 
        a  : in  STD_LOGIC_VECTOR(7 downto 0);
        s1 : in  STD_LOGIC_VECTOR(2 downto 0);  
        y81: out STD_LOGIC                      
    );
end Mux81;

architecture Dataflow of Mux81 is
begin
    y81 <= a(0) when s1 = "000" else
           a(1) when s1 = "001" else
           a(2) when s1 = "010" else
           a(3) when s1 = "011" else
           a(4) when s1 = "100" else
           a(5) when s1 = "101" else
           a(6) when s1 = "110" else
           a(7) when s1 = "111" else
           '0';
end Dataflow;
