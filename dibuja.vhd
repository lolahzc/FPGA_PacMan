library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity dibuja is
    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0);
           
           codigo_color : in std_logic_vector (2 downto 0);
           RGB : out STD_LOGIC_VECTOR (11 downto 0));

end dibuja;

architecture Behavioral of dibuja is
signal RED_in, GRN_in, BLU_in : std_logic_vector (3 downto 0);
signal REDaux, GRNaux, BLUaux : std_logic_vector (3 downto 0);

begin
    dibuja: process(eje_x, eje_y,codigo_color)
    begin

        case codigo_color is
            when "000" => -- Negro
                REDaux <= "0000";
                BLUaux<= "0000";
                GRNaux <= "0000";
            
            when "001" => -- Blanco
                REDaux <= "1111";
                BLUaux<= "1111";
                GRNaux <= "1111";

            when "010" => -- Amarillo
                REDaux <= "1111";
                BLUaux<= "1111";
                GRNaux <= "0000";

            when "011" => -- Rojo 
                REDaux <= "1111";
                BLUaux<= "0000";
                GRNaux <= "0000";
                
            when others => 
                REDaux <= "0000";
                BLUaux<= "0000";
                GRNaux <= "0000";
                
            end case;
    end process;

--RED <= std_logic_vector(RED_in);
--GRN <= std_logic_vector(GRN_in);
--BLU <= std_logic_vector(BLU_in);

RGB <= REDaux & BLUaux & GRNaux;
end Behavioral;
