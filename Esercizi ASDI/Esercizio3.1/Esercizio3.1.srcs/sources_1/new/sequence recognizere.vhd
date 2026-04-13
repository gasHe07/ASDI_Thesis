----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.10.2025 09:29:11
-- Design Name: 
-- Module Name: Sequence_reconizer - Behavioral
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

entity Sequence_reconizer is
    Port ( i : in STD_LOGIC;
           clk : in STD_LOGIC;
           r: in std_logic;
           y : out STD_LOGIC);
end Sequence_reconizer;

architecture Behavioral_Mealy_2 of Sequence_reconizer is
    type stato is(S0,S1,S2,S3,S4);
    signal stato_corrente : stato :=S0;
    signal stato_prossimo : stato;


begin
    f_stato_uscita: process(stato_corrente,i)
    begin
        case stato_corrente is 
            when S0 =>
              if(i='0') then
                stato_prossimo <=S3;
                y <='0';
               else
                stato_prossimo <=S1;
                y <='0';
               end if;
               when S1 =>
               if(i = '0') then
                   stato_prossimo <=S4;
                   y <= '0';
               else
                   stato_prossimo <=S2;
                   y <='0';
                end if;
                when S2 =>
                if(i='0') then
                    stato_prossimo <=S0;
                    y <='0';
                 else
                    stato_prossimo <=S0;
                    y<='1';
                 end if;
                 when S3 =>
                    stato_prossimo <=S4;
                    y<='0';
                 when s4 =>
                    stato_prossimo <=S0;
                    y<='0';
                 when others =>
                    stato_prossimo <=S0;
                    y<='0';
                  
               end case;
          end process;
 main: process(CLK,r)
    begin
      if rising_edge(clk) then
       if(r='1') then 
            stato_corrente <=S0;
        else
            stato_corrente<= stato_prossimo;
        end if;
       end if;
      end process;
        
               
end Behavioral_Mealy_2;

architecture Behavioral_Mealy_1 of Sequence_reconizer is
    type stato is(S0,S1,S2,S3,S4);
    signal stato_corrente : stato :=S0;
    
begin
stato_uscita_mem: process(clk,r)
    begin
        if(r='1') then
        stato_corrente <=S0;
        y <='0';
        elsif rising_edge(clk)then
            
        
        case stato_corrente is
            when S0 =>
              if(i='0') then
                stato_corrente <=S3;
                y <='0';
               else
                stato_corrente <=S1;
                y <='0';
               end if;
               when S1 =>
               if(i = '0') then
                   stato_corrente <=S4;
                   y <= '0';
               else
                   stato_corrente <=S2;
                   y <='0';
                end if;
                when S2 =>
                if(i='0') then
                    stato_corrente <=S0;
                    y <='0';
                 else
                    stato_corrente <=S0;
                    y<='1';
                 end if;
                 when S3 =>
                    stato_corrente <=S4;
                    y<='0';
                 when s4 =>
                    stato_corrente <=S0;
                    y<='0';
                 when others =>
                    stato_corrente <=S0;
                    y<='0';
                  

    end case;
    end if;
end process;

end Behavioral_Mealy_1;

architecture Behavioral_Moore_2 of Sequence_reconizer is
    type stato is(S0,S1,S2,S3,S4,S5);
    signal stato_corrente : stato :=S0;
    signal stato_prossimo : stato;
begin
 f_stato_uscita: process(stato_corrente)
    begin
    case stato_corrente is
        when S0 => 
            if(i='0') then 
              stato_prossimo <=S4;
             else
               stato_prossimo <=s1;
             end if;
          when S1 => 
               if(i='0') then 
                  stato_prossimo <=s5;
                else
                   stato_prossimo<=s2;
                 end if;
           when S2 => 
                if(i='0') then
                   stato_prossimo <=s0;
                 else
                    stato_prossimo <=s3;
                 end if;
            when S3 =>
                 if(i='0') then
                    stato_prossimo <=s0;
                  else
                    stato_prossimo <=s0;
                  end if;
             when S4 =>
                  stato_prossimo <=s5;
             when s5 => 
                  stato_prossimo <=s0;
             when others =>
                stato_prossimo <=s0;
          end case;
      end process;
main: process(clk,r)
begin
    if rising_edge(clk) then
        if(r='1') then
            stato_corrente <=s0;
         else
            stato_corrente <= stato_prossimo;
          end if;
      end if;
end process;

with stato_corrente select -- aggiornamento dell'uscita
        y <= '1' when s3,
            '0' when others;
    
      
end Behavioral_Moore_2;

architecture Behavioral_Moore_1 of Sequence_reconizer is
    type stato is(S0,S1,S2,s3,s4,s5);
    signal stato_corrente : stato :=S0;
begin 
stato_uscita_mem: process(clk,r)
     begin
        if(r='1') then
            stato_corrente <=S0;
            y <='0';
            elsif rising_edge(clk) then
     case stato_corrente is
         when S0 => 
            if(i='0') then 
              stato_corrente <=S4;
             else
               stato_corrente <=s1;
             end if;
          when S1 => 
               if(i='0') then 
                  stato_corrente <=s5;
                else
                   stato_corrente<=s2;
                 end if;
           when S2 => 
                if(i='0') then
                   stato_corrente <=s0;
                 else
                    stato_corrente <=s3;
                 end if;
            when S3 =>
                 if(i='0') then
                    stato_corrente <=s0;
                  else
                    stato_corrente <=s0;
                  end if;
             when S4 =>
                  stato_corrente <=s5;
             when s5 => 
                  stato_corrente <=s0;
             when others =>
                stato_corrente <=s0;
             
            end case;
            end if;
      end process;
      
    with stato_corrente select -- aggiornamento dell'uscita
        y <= '1' when s3,
            '0' when others;
        
     
end Behavioral_Moore_1;
    

