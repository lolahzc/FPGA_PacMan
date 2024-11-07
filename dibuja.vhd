library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity dibuja is
    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0);
           
           codigo_color : in std_logic_vector (2 downto 0);
           
           RED : out STD_LOGIC_VECTOR (3 downto 0);
           GRN : out STD_LOGIC_VECTOR (3 downto 0);
           BLU : out STD_LOGIC_VECTOR (3 downto 0));
end dibuja;

architecture Behavioral of dibuja is
signal RED_in, GRN_in, BLU_in : std_logic_vector (3 downto 0);

begin
    dibuja: process(eje_x, eje_y)
    begin

        case codigo_color is
            when "000" => -- Negro
                RED <= "0000";
                BLU <= "0000";
                GRN <= "0000";
            
            when "001" => -- Blanco
                RED <= "1111";
                BLU <= "1111";
                GRN <= "1111";

            when "010" => -- Amarillo
                RED <= "1111";
                BLU <= "1111";
                GRN <= "0000";

            when "011" => -- Rojo 
                RED <= "1111";
                BLU <= "0000";
                GRN <= "0000";
                
            when others => 
                RED <= "0000";
                BLU <= "0000";
                GRN <= "0000";
                
            end case;
    end process;

RED <= std_logic_vector(RED_in);
GRN <= std_logic_vector(GRN_in);
BLU <= std_logic_vector(BLU_in);

end Behavioral;
