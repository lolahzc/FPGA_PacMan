library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dibuja is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        eje_x : in STD_LOGIC_VECTOR (9 downto 0);
        eje_y : in STD_LOGIC_VECTOR (9 downto 0);
        codigo_color : in std_logic_vector (2 downto 0);
        RGB : out STD_LOGIC_VECTOR (11 downto 0);
        direccion: out STD_LOGIC_VECTOR (8 downto 0);
        data_muro : in std_logic_vector (11 downto 0);
        dir_muro : out std_logic_vector (7 downto 0);
        data_bolita : in std_logic_vector (11 downto 0);
        dir_bolita : out std_logic_vector (7 downto 0);
        data_cc : in std_logic_vector (11 downto 0);
        dir_cc: out std_logic_vector (7 downto 0);
        data_cc2 : in std_logic_vector (11 downto 0);
        dir_cc2: out std_logic_vector (7 downto 0);
        data_fant_r : in std_logic_vector (11 downto 0);
        dir_fant_r: out std_logic_vector (7 downto 0)
    );
end dibuja;

architecture Behavioral of dibuja is
    signal REDaux, GRNaux, BLUaux : std_logic_vector (3 downto 0);
    signal fila: std_logic_vector(3 downto 0);
    signal columna: std_logic_vector (4 downto 0);

    signal cuenta_pacman: std_logic_vector(25 downto 0); -- Contador grande (26 bits)
    signal pacman_sprite: std_logic := '0'; -- Controla el sprite de Pacman (0 o 1)

begin

    -- Proceso para el temporizador que alterna entre sprites
    sprite_timer: process(clk, reset)
    begin
        if reset = '1' then
            cuenta_pacman <= (others => '0');
            pacman_sprite <= '0';
          
        elsif rising_edge(clk) then
            if unsigned(cuenta_pacman) = 49999999 then -- Cambio cada 1 segundo (50 MHz)
                pacman_sprite <= not pacman_sprite; -- Alterna entre sprite 0 y 1
                cuenta_pacman <= (others => '0'); -- Resetea el contador
            else
                cuenta_pacman <= std_logic_vector(unsigned(cuenta_pacman) + 1); -- Incrementa contador
            end if;
        end if;
    end process;

    -- Proceso principal para dibujar los elementos en pantalla
    dibuja: process(eje_x, eje_y, codigo_color, data_muro, data_bolita, data_cc, data_cc2, pacman_sprite, data_fant_r)
    begin
        dir_muro <= (others => '1'); -- COMPROBAR SI AL QUITAR EL LATCH CON ESTO SIGUE FUNCIONANDO
        dir_bolita <= (others => '1');
        dir_cc <= (others => '1');
        dir_cc2 <= (others => '1');
        dir_fant_r <= (others => '1');
        
        if (unsigned(eje_x) > 0 and unsigned(eje_x) < 512 and unsigned(eje_y) > 0 and unsigned(eje_y) < 256) then
            case codigo_color is
                when "000" => -- Vacío -> negro
                    REDaux <= "0000";
                    BLUaux <= "0000";
                    GRNaux <= "0000";

                when "001" => -- Muros
                    dir_muro(3 downto 0) <= eje_x(3 downto 0);
                    dir_muro(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_muro(11 downto 8);
                    BLUaux <= data_muro(7 downto 4);
                    GRNaux <= data_muro(3 downto 0);

                when "010" => -- Bolas
                    dir_bolita(3 downto 0) <= eje_x(3 downto 0);
                    dir_bolita(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_bolita(11 downto 8);
                    BLUaux <= data_bolita(7 downto 4);
                    GRNaux <= data_bolita(3 downto 0);

                when "011" => -- Pacman
                    if pacman_sprite = '0' then
                        dir_cc(3 downto 0) <= eje_x(3 downto 0);
                        dir_cc(7 downto 4) <= eje_y(3 downto 0);
                        REDaux <= data_cc(11 downto 8);
                        BLUaux <= data_cc(7 downto 4);
                        GRNaux <= data_cc(3 downto 0);
                    else
                        dir_cc2(3 downto 0) <= eje_x(3 downto 0);
                        dir_cc2(7 downto 4) <= eje_y(3 downto 0);
                        REDaux <= data_cc2(11 downto 8);
                        BLUaux <= data_cc2(7 downto 4);
                        GRNaux <= data_cc2(3 downto 0);
                    end if;

                when "100" => -- Fantasma
                    dir_fant_r(3 downto 0) <= eje_x(3 downto 0);
                    dir_fant_r(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_fant_r(11 downto 8);
                    BLUaux <= data_fant_r(7 downto 4);
                    GRNaux <= data_fant_r(3 downto 0);
                    
                 when "101" =>
                    REDaux <= "1111";
                    BLUaux <= "1111";
                    GRNaux <= "0000";
                when "110" =>
                    REDaux <= "0000";
                    BLUaux <= "1111";
                    GRNaux <= "0000";
              
                when "111" =>
                    REDaux <= "0000";
                    BLUaux <= "1111";
                    GRNaux <= "1111";
                when others => 
                    REDaux <= "0000";
                    BLUaux <= "0000";
                    GRNaux <= "0000";

            end case;
        else
            -- Valores por defecto para áreas fuera del rango
            REDaux <= "1111";
            BLUaux <= "1111";
            GRNaux <= "1111";

            dir_muro <= (others => '1');
            dir_bolita <= (others => '1');
            dir_cc <= (others => '1');
            dir_cc2 <= (others => '1');
            dir_fant_r <= (others => '1');
        end if;
    end process;

    -- Calcular fila y columna en pantalla
    fila <= eje_y(7 downto 4);
    columna <= eje_x(8 downto 4);
    direccion <= fila & columna;

    -- Construir el valor RGB final
    RGB <= REDaux & GRNaux & BLUaux;

end Behavioral;
