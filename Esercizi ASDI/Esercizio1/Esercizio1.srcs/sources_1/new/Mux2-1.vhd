----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 15:40:11
-- Design Name: 
-- Module Name: Mux2-1 - Dataflow
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


----------------------------------------------------------------------------------
-- MUX 2:1 - Dataflow corretto
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2_1 is
    Port ( 
        a0   : in  STD_LOGIC;
        a1   : in  STD_LOGIC;
        s0   : in  STD_LOGIC;   
        y2_1 : out STD_LOGIC    
    );
end Mux2_1;

architecture Dataflow of Mux2_1 is
begin
    y2_1 <= (a0 and not(s0)) or (a1 and s0);
    -- Se s0 è alto -> in uscita troverò a1
    -- Se s0 è basso -> in uscita troverà a0
end Dataflow;

