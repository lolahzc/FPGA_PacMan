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
  Port ( up : in std_logic;
  down : in std_logic;
  left : in std_logic;
  right : in std_logic;
  move : out std_logic;
  udlrcc : out std_logic_vector(3 downto 0)
  );
end gestion_botones;

architecture Behavioral of gestion_botones is

    signal udlr_in : std_logic_vector(3 downto 0);
    
begin

    -- Concatenación de señales
    udlr_in <= up & down & left & right;

    process (udlr_in)  -- Sensibilidad a las señales relevantes
    
    begin
    move <= '0';
        case udlr_in is
            when "1000" => -- up
                udlrcc <= "1000";
                move <='1';
            when "0100" => -- down
                udlrcc <= "0100";
                move <='1';
            when "0010" => -- left
                udlrcc <= "0010";
                move <='1';
            when "0001" => -- right
                udlrcc <= "0001";
                move <='1';

            when others => -- Si recibe más de un valor a la vez
                udlrcc <= "0000";
        end case;
    end process;

end Behavioral;