----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2025 15:20:58
-- Design Name: 
-- Module Name: muxN_1 - Behavioral
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
entity mux4_1 is
    port (
        i : in  STD_LOGIC_VECTOR(3 downto 0);
        s : in  STD_LOGIC_VECTOR(1 downto 0);
        y : out STD_LOGIC
    );
end mux4_1;

architecture dataflow of mux4_1 is
begin
    -- Selezione dell'ingresso in base a s
    y <= i(to_integer(unsigned(s)));
end dataflow;