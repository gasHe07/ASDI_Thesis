----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.10.2025 17:28:17
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


entity Demux8_1 is
    Port ( 
        i1 : in  STD_LOGIC;                  
        s3 : in  STD_LOGIC_VECTOR(2 downto 0); 
        o2 : out STD_LOGIC_VECTOR(7 downto 0)  
    );
end Demux8_1;

architecture dataflow of Demux8_1 is
begin
    o2(0) <= i1 when s3 = "000" else '0';
    o2(1) <= i1 when s3 = "001" else '0';
    o2(2) <= i1 when s3 = "010" else '0';
    o2(3) <= i1 when s3 = "011" else '0';
    o2(4) <= i1 when s3 = "100" else '0';
    o2(5) <= i1 when s3 = "101" else '0';
    o2(6) <= i1 when s3 = "110" else '0';
    o2(7) <= i1 when s3 = "111" else '0';
end dataflow;