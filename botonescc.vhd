----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2024 13:19:33
-- Design Name: 
-- Module Name: gestion_botones - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gestion_botones is
  Port ( 
  clk : in std_logic;
  reset : in std_logic;
  up : in std_logic;
  down : in std_logic;
  left : in std_logic;
  right : in std_logic;
  move : out std_logic;
  udlrcc : out std_logic_vector(3 downto 0)
  );
end gestion_botones;

architecture Behavioral of gestion_botones is

    signal udlr_in, p_udlr,udlr : std_logic_vector(3 downto 0);
    
begin

    -- Concatenación de señales
    udlr_in <= up & down & left & right;
    sync : process(clk,reset)
        begin
    if( reset = '1') then
          udlr <= "0000";
        elsif (rising_edge(clk)) then
            udlr <= p_udlr;
    end if;
    
    end process;
    comb: process (udlr_in,udlr)  -- Sensibilidad a las señales relevantes
    
    begin
    move <= '0';
    p_udlr <= udlr;
 
        case udlr_in is
            when "1000" => -- up
                p_udlr <= "1000";
                move <='1';
            when "0100" => -- down
                p_udlr <= "0100";
                move <='1';
            when "0010" => -- left
                p_udlr <= "0010";
                move <='1';
            when "0001" => -- right
                p_udlr <= "0001";
                move <='1';
            when others =>
            p_udlr <= udlr;
        end case;
    end process;
udlrcc <= udlr;
end Behavioral;