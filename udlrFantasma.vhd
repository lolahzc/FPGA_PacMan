----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2024 14:25:08
-- Design Name: 
-- Module Name: mov_fantasma - Behavioral
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

entity mov_fantasma is
  Port (
  clk : in std_logic;
  random_number_in : in std_logic_vector (4 downto 0);
  udlr_ghost : out std_logic_vector(3 downto 0)
   );
end mov_fantasma;

architecture Behavioral of mov_fantasma is
signal udlr:std_logic_vector(3 downto 0);
signal p_udlr_ghost:std_logic_vector(3 downto 0);
begin
udlr_ghost<=udlr;
sync : process(clk)
begin
    if(rising_edge(clk)) then
    udlr <= p_udlr_ghost;
    end if;
end process;


comb:process (random_number_in,udlr)  -- Sensibilidad a las señales relevantes
    begin
    p_udlr_ghost <= udlr;
    if(random_number_in(0)='0') then
    
        case random_number_in is
            when "00000" => -- up
                p_udlr_ghost <= "1000";
                
            when "00001" => -- up
                p_udlr_ghost <= "1000";
                
            when "00010" => -- down
                p_udlr_ghost <= "0100";
                
            when "00011" => -- up
                p_udlr_ghost <= "1000";
                
            when "00100" => -- left
                p_udlr_ghost <= "0001";
                
            when "00101" => -- right
                p_udlr_ghost <= "0100";
                
            when "00110" => -- left
                p_udlr_ghost <= "0010";
                
            when "00111" => -- right
                p_udlr_ghost <= "0010";
                
            when "01000" => -- left
                p_udlr_ghost <= "0001";
                
            when "01001" => -- up
                p_udlr_ghost <= "1000";
                
            when "01010" => -- down
                p_udlr_ghost <= "0100";
                
            when "01011" => -- right
                p_udlr_ghost <= "0010";
                
            when "01100" => -- left
                p_udlr_ghost <= "0001";
                
            when "01101" => -- up
                p_udlr_ghost <= "1000";
                
            when "01110" => -- down
                p_udlr_ghost <= "0100";
                
            when "01111" => -- rigt
                p_udlr_ghost <= "0010";
                
            when "10000" => -- up
                p_udlr_ghost <= "1000";
                
            when "10001" => -- left
                p_udlr_ghost <= "0010";
                
            when "10010" => -- up
                p_udlr_ghost <= "1000";
                
            when "10011" => -- right
                p_udlr_ghost <= "0010";
                
            when "10100" => -- left
                p_udlr_ghost <= "0001";
                
            when "10101" => -- up
                p_udlr_ghost <= "1000";
                
            when "10110" => -- down
                p_udlr_ghost <= "0100";
                
            when "10111" => -- up
                p_udlr_ghost <= "1000";
                
            when "11000" => -- up
                p_udlr_ghost <= "1000";
                
            when "11001" => -- up
                p_udlr_ghost <= "1000";
                
            when "11010" => -- down
                p_udlr_ghost <= "0100";
                
            when "11011" => -- right
                p_udlr_ghost <= "0010";
                
            when "11100" => -- left
                p_udlr_ghost <= "0001";
                
            when "11101" => -- up
                p_udlr_ghost <= "1000";
                
            when "11110" => -- up
                p_udlr_ghost <= "1000";
                
            when "11111" => -- up
                p_udlr_ghost <= "1000";
             when others =>
             p_udlr_ghost <= udlr;
        end case;
        
        else
        
        case random_number_in is
            when "00000" => -- right
                p_udlr_ghost <= "0010";
                
            when "00001" => -- down
                p_udlr_ghost <= "0100";
                
            when "00010" => -- left
                p_udlr_ghost <= "0001";
                
            when "00011" => -- up
                p_udlr_ghost <= "1000";
                
            when "00100" => -- left
                p_udlr_ghost <= "0001";
                
            when "00101" => -- right
                p_udlr_ghost <= "0010";
                
            when "00110" => -- up
                p_udlr_ghost <= "1000";
                
            when "00111" => -- up
                p_udlr_ghost <= "1000";
                
            when "01000" => -- left
                p_udlr_ghost <= "0010";
                
            when "01001" => -- up
                p_udlr_ghost <= "1000";
                
            when "01010" => -- right
                p_udlr_ghost <= "0010";
                
            when "01011" => -- left
                p_udlr_ghost <= "0001";
                
            when "01100" => -- up
                p_udlr_ghost <= "1000";
                
            when "01101" => -- down
                p_udlr_ghost <= "0100";
                
            when "01110" => -- up
                p_udlr_ghost <= "1000";
                
            when "01111" => -- left
                p_udlr_ghost <= "0001";
                
            when "10000" => -- right
                p_udlr_ghost <= "1000";
                
            when "10001" => -- right
                p_udlr_ghost <= "0010";
                
            when "10010" => -- up
                p_udlr_ghost <= "1000";
                
            when "10011" => -- left
                p_udlr_ghost <= "0001";
                
            when "10100" => -- down
                p_udlr_ghost <= "0100";
                
            when "10101" => -- right
                p_udlr_ghost <= "0010";
                
            when "10110" => -- left
                p_udlr_ghost <= "0001";
                
            when "10111" => -- up
                p_udlr_ghost <= "1000";
                
            when "11000" => -- down
                p_udlr_ghost <= "0100";
                
            when "11001" => -- left
                p_udlr_ghost <= "0001";
                
            when "11010" => -- up
                p_udlr_ghost <= "1000";
                
            when "11011" => -- up
                p_udlr_ghost <= "1000";
                
            when "11100" => -- right
                p_udlr_ghost <= "0010";
                
            when "11101" => -- up
                p_udlr_ghost <= "1000";
                
            when "11110" => -- left
                p_udlr_ghost <= "0001";
                
            when "11111" => -- up
                p_udlr_ghost <= "1000";
                  when others =>
             p_udlr_ghost <= udlr;
        end case;

        end if;
    end process;

end Behavioral;