library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dibuja is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        eje_x : in STD_LOGIC_VECTOR (9 downto 0);
        eje_y : in STD_LOGIC_VECTOR (9 downto 0);

        udlrIn : in std_logic_vector (3 downto 0);
        udlrF1, udlrF2, udlrF3, udlrF4 : in std_logic_vector (3 downto 0);
        codigo_color : in std_logic_vector (3 downto 0);
        RGB : out STD_LOGIC_VECTOR (11 downto 0);
        direccion: out STD_LOGIC_VECTOR (8 downto 0);

        data_muro : in std_logic_vector (11 downto 0);
        dir_muro : out std_logic_vector (7 downto 0);
        data_bolita : in std_logic_vector (11 downto 0);
        dir_bolita : out std_logic_vector (7 downto 0);

        -- Señales comecocos abiertos
        data_cc_abi_der, data_cc_abi_izq, data_cc_abi_arr, data_cc_abi_aba : in std_logic_vector (11 downto 0);
        dir_cc_abi_der, dir_cc_abi_izq, dir_cc_abi_arr, dir_cc_abi_aba: out std_logic_vector (7 downto 0);
        -- Señales comecocos cerrados
        data_cc_cer_der, data_cc_cer_izq, data_cc_cer_arr, data_cc_cer_aba : in std_logic_vector (11 downto 0);
        dir_cc_cer_der, dir_cc_cer_izq, dir_cc_cer_arr, dir_cc_cer_aba: out std_logic_vector (7 downto 0);

        -- Señales fantasmas            
        data_fant_ver_der, data_fant_ver_izq, data_fant_ver_arr, data_fant_ver_aba : in std_logic_vector (11 downto 0);
        dir_fant_ver_der, dir_fant_ver_izq, dir_fant_ver_arr, dir_fant_ver_aba : out std_logic_vector (7 downto 0);

        data_fant_azu_der, data_fant_azu_izq, data_fant_azu_arr, data_fant_azu_aba : in std_logic_vector (11 downto 0);
        dir_fant_azu_der, dir_fant_azu_izq, dir_fant_azu_arr, dir_fant_azu_aba : out std_logic_vector (7 downto 0);

        data_fant_mar_der, data_fant_mar_izq, data_fant_mar_arr, data_fant_mar_aba : in std_logic_vector (11 downto 0);
        dir_fant_mar_der, dir_fant_mar_izq, dir_fant_mar_arr, dir_fant_mar_aba : out std_logic_vector (7 downto 0);

        data_fant_roj_der, data_fant_roj_izq, data_fant_roj_arr, data_fant_roj_aba : in std_logic_vector (11 downto 0);
        dir_fant_roj_der, dir_fant_roj_izq, dir_fant_roj_arr, dir_fant_roj_aba : out std_logic_vector (7 downto 0);
        
        data_corazon_empty : in std_logic_vector (11 downto 0);
        dir_corazon_empty : out std_logic_vector (7 downto 0);
        data_corazon_full : in std_logic_vector (11 downto 0);
        dir_corazon_full : out std_logic_vector (7 downto 0)

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
    dibuja: process(eje_x, eje_y, udlrIn, udlrF1, udlrF2, udlrF3, udlrF4, codigo_color,data_corazon_empty,data_corazon_full, data_muro, data_bolita, data_cc_abi_der , data_cc_cer_der ,data_cc_abi_arr , data_cc_cer_arr, data_cc_abi_aba , data_cc_cer_aba, data_cc_abi_izq , data_cc_cer_izq ,pacman_sprite, data_fant_ver_der, data_fant_ver_izq,data_fant_ver_arr,data_fant_ver_aba, data_fant_azu_der, data_fant_azu_izq,data_fant_azu_arr,data_fant_azu_aba, data_fant_mar_der, data_fant_mar_izq,data_fant_mar_arr,data_fant_mar_aba, data_fant_roj_der, data_fant_roj_izq,data_fant_roj_arr,data_fant_roj_aba  )
    begin
        dir_muro <= (others => '1'); -- COMPROBAR SI AL QUITAR EL LATCH CON ESTO SIGUE FUNCIONANDO
        dir_bolita <= (others => '1');
        dir_corazon_empty <= (others => '1');
        dir_corazon_full <= (others => '1');

        -- Señales comecocos
        dir_cc_abi_der  <= (others => '1');
        dir_cc_cer_der  <= (others => '1');
        dir_cc_abi_izq  <= (others => '1');
        dir_cc_cer_izq  <= (others => '1');
        dir_cc_abi_arr  <= (others => '1');
        dir_cc_cer_arr  <= (others => '1');
        dir_cc_abi_aba  <= (others => '1');
        dir_cc_cer_aba  <= (others => '1');

        -- Señales fantasmas      
        dir_fant_ver_der <= (others => '1');
        dir_fant_ver_izq <= (others => '1');
        dir_fant_ver_arr <= (others => '1');
        dir_fant_ver_aba <= (others => '1');
        dir_fant_azu_der <= (others => '1');
        dir_fant_azu_izq <= (others => '1');
        dir_fant_azu_arr <= (others => '1');
        dir_fant_azu_aba <= (others => '1');
        dir_fant_mar_der <= (others => '1');
        dir_fant_mar_izq <= (others => '1');
        dir_fant_mar_arr <= (others => '1');
        dir_fant_mar_aba <= (others => '1');
        dir_fant_roj_der <= (others => '1');
        dir_fant_roj_izq <= (others => '1');
        dir_fant_roj_arr <= (others => '1');
        dir_fant_roj_aba <= (others => '1');


        if (unsigned(eje_x) > 0 and unsigned(eje_x) < 512 and unsigned(eje_y) > 0 and unsigned(eje_y) < 256) then
            case codigo_color is
                when "0000" => -- Vacío -> negro
                    REDaux <= "0000";
                    BLUaux <= "0000";
                    GRNaux <= "0000";

                when "0001" => -- Muros
                    dir_muro(3 downto 0) <= eje_x(3 downto 0);
                    dir_muro(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_muro(11 downto 8);
                    BLUaux <= data_muro(7 downto 4);
                    GRNaux <= data_muro(3 downto 0);

                when "0010" => -- Bolas
                    dir_bolita(3 downto 0) <= eje_x(3 downto 0);
                    dir_bolita(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_bolita(11 downto 8);
                    BLUaux <= data_bolita(7 downto 4);
                    GRNaux <= data_bolita(3 downto 0);
                    
                when "1000" => -- Corazon lleno
                    dir_corazon_full(3 downto 0) <= eje_x(3 downto 0);
                    dir_corazon_full(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_corazon_full(11 downto 8);
                    BLUaux <= data_corazon_full(7 downto 4);
                    GRNaux <= data_corazon_full(3 downto 0);
                 
                 when "1001" => -- Corazon vacio
                    dir_corazon_empty(3 downto 0) <= eje_x(3 downto 0);
                    dir_corazon_empty(7 downto 4) <= eje_y(3 downto 0);
                    REDaux <= data_corazon_empty(11 downto 8);
                    BLUaux <= data_corazon_empty(7 downto 4);
                    GRNaux <= data_corazon_empty(3 downto 0);   
                 

                when "0011" => -- Pacman
                    case udlrIn is
                        when "0001" =>
                            if pacman_sprite = '0' then
                                dir_cc_abi_der(3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_abi_der(7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_abi_der (11 downto 8);
                                BLUaux <= data_cc_abi_der (7 downto 4);
                                GRNaux <= data_cc_abi_der (3 downto 0);
                            else
                                dir_cc_cer_der (3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_cer_der (7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_cer_der (11 downto 8);
                                BLUaux <= data_cc_cer_der (7 downto 4);
                                GRNaux <= data_cc_cer_der (3 downto 0);
                            end if;
                        when "0010" =>
                            if pacman_sprite = '0' then
                                dir_cc_abi_izq(3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_abi_izq(7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_abi_izq (11 downto 8);
                                BLUaux <= data_cc_abi_izq (7 downto 4);
                                GRNaux <= data_cc_abi_izq (3 downto 0);
                            else
                                dir_cc_cer_izq (3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_cer_izq (7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_cer_izq (11 downto 8);
                                BLUaux <= data_cc_cer_izq (7 downto 4);
                                GRNaux <= data_cc_cer_izq (3 downto 0);
                            end if;
                        when "0100" =>
                            if pacman_sprite = '0' then
                                dir_cc_abi_aba(3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_abi_aba(7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_abi_aba (11 downto 8);
                                BLUaux <= data_cc_abi_aba (7 downto 4);
                                GRNaux <= data_cc_abi_aba (3 downto 0);
                            else
                                dir_cc_cer_aba (3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_cer_aba (7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_cer_aba (11 downto 8);
                                BLUaux <= data_cc_cer_aba (7 downto 4);
                                GRNaux <= data_cc_cer_aba (3 downto 0);
                            end if;
                        when "1000" =>
                            if pacman_sprite = '0' then
                                dir_cc_abi_arr(3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_abi_arr(7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_abi_arr (11 downto 8);
                                BLUaux <= data_cc_abi_arr (7 downto 4);
                                GRNaux <= data_cc_abi_arr (3 downto 0);
                            else
                                dir_cc_cer_arr (3 downto 0) <= eje_x(3 downto 0);
                                dir_cc_cer_arr (7 downto 4) <= eje_y(3 downto 0);
                                REDaux <= data_cc_cer_arr (11 downto 8);
                                BLUaux <= data_cc_cer_arr (7 downto 4);
                                GRNaux <= data_cc_cer_arr (3 downto 0);
                            end if;
                        when others =>
                            REDaux <= "0000";
                            BLUaux <= "0000";
                            GRNaux <= "0000";
                    end case;

                when "0100" => -- Fantasma rojo
                    case udlrF1 is
                        when "0001" =>
                            dir_fant_roj_der (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_roj_der (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_roj_der (11 downto 8);
                            BLUaux <= data_fant_roj_der (7  downto 4);
                            GRNaux <= data_fant_roj_der (3 downto 0);
                        when "0010" =>
                            dir_fant_roj_izq (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_roj_izq (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_roj_izq (11 downto 8);
                            BLUaux <= data_fant_roj_izq (7  downto 4);
                            GRNaux <= data_fant_roj_izq (3 downto 0);
                        when "0100" =>
                            dir_fant_roj_aba (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_roj_aba (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_roj_aba (11 downto 8);
                            BLUaux <= data_fant_roj_aba (7  downto 4);
                            GRNaux <= data_fant_roj_aba (3 downto 0);
                        when "1000" =>
                            dir_fant_roj_arr (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_roj_arr (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_roj_arr (11 downto 8);
                            BLUaux <= data_fant_roj_arr (7  downto 4);
                            GRNaux <= data_fant_roj_arr (3 downto 0);
                        when others =>
                            REDaux <= "0000";
                            BLUaux <= "0000";
                            GRNaux <= "0000";
                    end case;

                when "0101" => -- Fantasma verde 
                    case udlrF2 is
                        when "0001" =>
                            dir_fant_ver_der (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_ver_der (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_ver_der (11 downto 8);
                            BLUaux <= data_fant_ver_der (7  downto 4);
                            GRNaux <= data_fant_ver_der (3 downto 0);
                        when "0010" =>
                            dir_fant_ver_izq (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_ver_izq (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_ver_izq (11 downto 8);
                            BLUaux <= data_fant_ver_izq (7  downto 4);
                            GRNaux <= data_fant_ver_izq (3 downto 0);
                        when "0100" =>
                            dir_fant_ver_aba (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_ver_aba (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_ver_aba (11 downto 8);
                            BLUaux <= data_fant_ver_aba (7  downto 4);
                            GRNaux <= data_fant_ver_aba (3 downto 0);
                        when "1000" =>
                            dir_fant_ver_arr (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_ver_arr (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_ver_arr (11 downto 8);
                            BLUaux <= data_fant_ver_arr (7  downto 4);
                            GRNaux <= data_fant_ver_arr (3 downto 0);
                        when others =>
                            REDaux <= "0000";
                            BLUaux <= "0000";
                            GRNaux <= "0000";
                    end case;

                when "0110" => -- Fantasma azul
                    case udlrF3 is
                        when "0001" =>
                            dir_fant_azu_der (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_azu_der (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_azu_der (11 downto 8);
                            BLUaux <= data_fant_azu_der (7  downto 4);
                            GRNaux <= data_fant_azu_der (3 downto 0);
                        when "0010" =>
                            dir_fant_azu_izq (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_azu_izq (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_azu_izq (11 downto 8);
                            BLUaux <= data_fant_azu_izq (7  downto 4);
                            GRNaux <= data_fant_azu_izq (3 downto 0);
                        when "0100" =>
                            dir_fant_azu_aba (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_azu_aba (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_azu_aba (11 downto 8);
                            BLUaux <= data_fant_azu_aba (7  downto 4);
                            GRNaux <= data_fant_azu_aba (3 downto 0);
                        when "1000" =>
                            dir_fant_azu_arr (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_azu_arr (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_azu_arr (11 downto 8);
                            BLUaux <= data_fant_azu_arr (7  downto 4);
                            GRNaux <= data_fant_azu_arr (3 downto 0);
                        when others =>
                            REDaux <= "0000";
                            BLUaux <= "0000";
                            GRNaux <= "0000";
                    end case;

                when "0111" => -- Fantasma marron
                    case udlrF4 is
                        when "0001" =>
                            dir_fant_mar_der (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_mar_der (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_mar_der (11 downto 8);
                            BLUaux <= data_fant_mar_der (7  downto 4);
                            GRNaux <= data_fant_mar_der (3 downto 0);
                        when "0010" =>
                            dir_fant_mar_izq (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_mar_izq (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_mar_izq (11 downto 8);
                            BLUaux <= data_fant_mar_izq (7  downto 4);
                            GRNaux <= data_fant_mar_izq (3 downto 0);
                        when "0100" =>
                            dir_fant_mar_aba (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_mar_aba (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_mar_aba (11 downto 8);
                            BLUaux <= data_fant_mar_aba (7  downto 4);
                            GRNaux <= data_fant_mar_aba (3 downto 0);
                        when "1000" =>
                            dir_fant_mar_arr (3 downto 0) <= eje_x(3 downto 0);
                            dir_fant_mar_arr (7 downto 4) <= eje_y(3 downto 0);
                            REDaux <= data_fant_mar_arr (11 downto 8);
                            BLUaux <= data_fant_mar_arr (7  downto 4);
                            GRNaux <= data_fant_mar_arr (3 downto 0);
                        when others =>
                            REDaux <= "0000";
                            BLUaux <= "0000";
                            GRNaux <= "0000";
                    end case;

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

            -- Señales comecocos
            dir_cc_abi_der  <= (others => '1');
            dir_cc_cer_der  <= (others => '1');
            dir_cc_abi_izq  <= (others => '1');
            dir_cc_cer_izq  <= (others => '1');
            dir_cc_abi_arr  <= (others => '1');
            dir_cc_cer_arr  <= (others => '1');
            dir_cc_abi_aba  <= (others => '1');
            dir_cc_cer_aba  <= (others => '1');

            -- Señales fantasmas      
            dir_fant_ver_der <= (others => '1');
            dir_fant_ver_izq <= (others => '1');
            dir_fant_ver_arr <= (others => '1');
            dir_fant_ver_aba <= (others => '1');
            dir_fant_azu_der <= (others => '1');
            dir_fant_azu_izq <= (others => '1');
            dir_fant_azu_arr <= (others => '1');
            dir_fant_azu_aba <= (others => '1');
            dir_fant_mar_der <= (others => '1');
            dir_fant_mar_izq <= (others => '1');
            dir_fant_mar_arr <= (others => '1');
            dir_fant_mar_aba <= (others => '1');
            dir_fant_roj_der <= (others => '1');
            dir_fant_roj_izq <= (others => '1');
            dir_fant_roj_arr <= (others => '1');
            dir_fant_roj_aba <= (others => '1');


        end if;
    end process;

    -- Calcular fila y columna en pantalla
    fila <= eje_y(7 downto 4);
    columna <= eje_x(8 downto 4);
    direccion <= fila & columna;

    -- Construir el valor RGB final
    RGB <= REDaux & GRNaux & BLUaux;

end Behavioral;
