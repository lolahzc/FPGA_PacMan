library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MaqPACMAN is
    Port (
        clk          : in STD_LOGIC;
        reset        : in STD_LOGIC;
        refresh      : in STD_LOGIC;
        empieza      : in STD_LOGIC;
        muerte       : in STD_LOGIC;
        udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
        addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
        dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        enableMem    : out STD_LOGIC;
        done         : out STD_LOGIC;
        puntosOut       : out STD_LOGIC_VECTOR(6 downto 0);
        puntosEnable : out STD_LOGIC;
        write        : out STD_LOGIC_VECTOR(0 downto 0);
        cc_udlr      : out std_logic_vector (3 downto 0)
    );
end MaqPACMAN;

architecture Behavioral of MaqPACMAN is
    type estados is (reposo, espera,botonDireccion, movimiento, comprueboDireccion, confirmoDireccion,pintaPacman);
    signal estado, p_estado       : estados;
    signal p_address, last_address : std_logic_vector(8 downto 0);
    signal posx, p_posx, posx_ant, p_posx_ant : std_logic_vector(3 downto 0) :=("0001");
    signal posy, p_posy, posy_ant, p_posy_ant : std_logic_vector(4 downto 0):=("00001");
    signal p_Dout : std_logic_vector(3 downto 0);
    signal last_udlr, p_last_udlr,udlr,p_udlr : std_logic_vector(3 downto 0);
    signal hayMuro ,p_hayMuro,p_kill,choque,p_choque : std_logic;
    signal p_write : std_logic_vector(0 downto 0);
    signal done_reg : std_logic := '0';
    signal p_ciclo,ciclos : unsigned (4 downto 0);
    signal p_contVidas,contVidas : unsigned (1 downto 0);
    signal gameOver, p_gameOver : std_logic ;
    signal enableMemoria,p_enableMemoria: std_logic :='1';
    signal p_puntoEnable,puntoEnable: std_logic :='0';
     signal p_puntos,puntos : unsigned (6 downto 0);
    signal aux_udlr_cc : std_logic_vector (3 downto 0);
begin

    sync: process(clk, reset)
    begin
        if reset = '1' then
            estado <= reposo;
            posx <= (others => '0');
            posy <= (others => '0');
            done <= '0';
            posy_ant <= (others => '0');
            posx_ant <= (others => '0');
            ciclos <= "00000";
            contVidas <= "00";
            puntoEnable <= '0';
            puntos <= (others => '0');
            gameOver <= '0';
            addressAOut <=(others => '0');
            dAOut <= "0001";
            hayMuro <= '0';
            choque <='0';
            write <="0";
            udlr <= (others => '0');
            last_udlr <= "0001";
            enableMemoria<='1';
        elsif rising_edge(clk) then
            enableMemoria<=p_enableMemoria;
            addressAOut <= p_address;
            dAOut <= p_Dout;
            estado <= p_estado;
            posx <= p_posx;
            posy <= p_posy;
            puntoEnable <= p_puntoEnable;
            gameOver <= p_gameOver;
            choque<=p_choque;
            posx_ant <= p_posx_ant;
            posy_ant <= p_posy_ant;
            hayMuro <= p_hayMuro;
            puntos <= p_puntos;
            write <= p_write;
            ciclos <= p_ciclo;
            contVidas <= p_contVidas;
            udlr <= p_udlr;
            last_udlr <= p_last_udlr;
            done <= done_reg;
        end if;
    end process;

    comb: process(estado, muerte, refresh, puntos, empieza, p_last_udlr,last_udlr,udlr,hayMuro, udlrIn, dAIn, p_posx, done_reg, p_posy, posx,posx_ant,posy_ant, posy,ciclos,contVidas, choque, enableMemoria, gameOver)
    begin
        -- Default outputs

        p_enableMemoria<=enableMemoria;
        p_kill <= '0';
        p_last_udlr <= last_udlr; --Mantiene el valor del anterior
        p_udlr <= udlr; --Mantiene el valor del anterior
        p_ciclo <= "00000"; --Resetea el ciclo
        p_contVidas <= contVidas; -- Contador de vidas
        p_Dout <= "0000"; --Pone vacío por defecto
        p_write <= "0"; --Por defecto no escribe
        p_estado <= estado; --Se manteine en el mismo estado
        p_address <= p_posx & p_posy; --Actualiza la posición
        p_posx <= posx; --Por defecto la pos anterior si no se indica otra acción
        p_posy <= posy;
        p_posx_ant <= posx_ant; --Por defecto la pos anterior
        p_posy_ant <= posy_ant;
        p_choque <= choque;
        done_reg <= '0';
        p_hayMuro <= hayMuro; --Mantiene los valores
        p_gameOver <= gameOver;
        p_puntos <= puntos;
        p_puntoEnable<= '0';
        case estado is
            when reposo =>                --En reposo que dibuje el pacman en su posición

                if(gameOver = '1') then  --Si ha muerto, sale la pantalla de gameover
                    p_estado <= reposo;
                else
                    p_posx <= "0001";  -- Initial X position
                    p_posy <= "00001"; -- Initial Y position
                    p_Dout <= "0011";   -- Draw Pac-Man
                    p_address <= p_posx & p_posy;
                    p_write <= "1";
                    p_udlr <= udlrIn;
                    p_estado <= espera;
                    p_choque <= '0'; -- Si se había chocado, como ya está en el inicio, ya se pone a cero la variable
                end if;

            when espera =>
                p_enableMemoria <= '0'; -- No accede a memoria     
                if((muerte = '0' AND choque = '0') ) then -- Es decir, si el comecocos está vivo
                    if(empieza ='1' ) then -- Si ha recibido la señal de que empiece
                        p_estado <= botonDireccion;
                    else
                        P_estado <= estado;
                    end if;
                else

                    if(choque = '1') then --Si el pacman ha detectado un fantasma
                        done_reg <='1';
                    else
                        done_reg <='0';
                    end if;  --Todo esto significa que el comecocos está muerto 
                    p_estado <=  reposo;
                    p_contVidas <= contVidas + 1; --Este es el contaodr que indica las veces que ha muerto
                    if(contVidas >=3) then --Si se ha quedado sin vidas, muere
                        p_gameOver<='1';
                        p_estado <= reposo;
                    end if;
                end if;

            when botonDireccion =>
                p_enableMemoria <= '1'; --Dibuja un cero por donde va pasando el comecocos
                p_udlr <= udlrIn;
                p_posx_ant <= posx;
                p_posy_ant <= posy;
                p_write <= "1";
                p_puntos <= puntos;
                p_Dout <= "0000";
                p_address <= posx_ant & posy_ant;
                p_ciclo <= ciclos +1;

                -- Comparación entre last_udlr y udlr
                if (hayMuro = '1') then --Si hay muro
                    p_udlr <= last_udlr; -- Reutiliza la dirección anterior si hay muro
                    p_estado <= estado;
                    p_hayMuro <= '1';
                end if;
                if(ciclos >2) then --Dos ciclos para asegurar que ha pasado el tiempo suficiente
                    if udlr = "1000" then
                        p_posx <= std_logic_vector(unsigned(posx) - 1);
                        p_estado <= movimiento;
                    elsif udlr = "0100" then
                        p_posx <= std_logic_vector(unsigned(posx) + 1);
                        p_estado <= movimiento;
                    elsif udlr = "0010" then
                        p_posy <= std_logic_vector(unsigned(posy) - 1);
                        p_estado <= movimiento;
                    elsif udlr = "0001" then
                        p_posy <= std_logic_vector(unsigned(posy) + 1);
                        p_estado <= movimiento;
                    else
                        p_hayMuro <= '1'; -- Si no sabe qué hacer que coja el anterior (como si hubiese un muro)
                        p_estado <= estado;
                    end if;

                else p_estado <=estado;
                end if;

            when movimiento => --Pone un cero en la posición anterior
                p_address <= posx_ant & posy_ant;
                p_Dout <= "0000";
                p_write <= "1";
                p_estado <= comprueboDireccion;

            when comprueboDireccion => --En este estado pone la dirección de la casilla a la que se quiere leer para poder leerla en el siguiente estado como el dato que recibe de la memoria
                p_write <= "0";
                p_address <= p_posx & p_posy;
                p_ciclo <= ciclos +1;

                if(ciclos = 5) then --Nos aseguramos de que haya recibido el dato de la memoria para el siguiente estado
                    p_estado <= confirmoDireccion;
                else
                    p_estado <= comprueboDireccion;
                end if;

            when confirmoDireccion => --Aquí verifico si hay muro, fantasma, bola... --ASIGNO LA SIGUIENTE SALIDA
                p_write <= "1";
                p_estado <= pintaPacman;
                p_address <= p_posx & p_posy;
                if(daIn ="0010") then --Si hay bola
                 p_puntoEnable <= '1';
                p_puntos <= puntos +1;
                
                end if;
                if(dAIn = "0001") then --Si hay muro. 
                    --Primero he puesto un cero, si hay un muro se escribe arriba y vuelve a movimiento
                    if(last_udlr /= udlr) then --Si hay muro, me quedo en la posición en la que estaba para no comerme el muro
                        p_posx <= posx_ant;
                        p_posy <= posy_ant;
                        p_last_udlr <= last_udlr;
                        p_hayMuro<='1';
                        p_estado <= botonDireccion;
                        aux_udlr_cc  <= last_udlr ;

                    else -- Si hay muro pero puede ir en la dirección anterior

                        p_posx <= posx_ant; -- p_posx es donde estoy mirando para ir y posx_ant es donde estaba el pacman antes
                        p_posy <= posy_ant;
                        p_estado <= pintaPacman;
                        p_hayMuro<='0';
                        aux_udlr_cc  <= udlr ;

                    end if;
                --Esto pinta el pacman en la posición anterior

                elsif(dAIn = "0100" or dAIn = "0110" or dAIn = "0101" or dAIn = "0111") then --Si hay fantasma
                    p_hayMuro<='0';
                    p_choque <='1'; --Si hay fantasma es que se ha chocado
                    p_estado <= espera;
                    p_write <= "0";

                else --Si no detecta nada inusual, actualiza las variables y pone que no hay muro
                    p_hayMuro<='0';
                    p_last_udlr <= udlr;
                    aux_udlr_cc  <= udlr ;
                end if;

            when pintaPacman => --Aquí pinto en la casilla siguiente o en la anterior en función de confirmo dirección
                p_address <= p_posx & p_posy;
                p_ciclo <= ciclos;
                p_Dout <= "0011";
                p_write <= "1";
                if refresh = '1' then
                    p_ciclo <= ciclos +1;
                    p_enableMemoria <='1';
                    if ciclos >20 then --Espera 20 refresh
                        p_write <= "0";
                        p_udlr <= udlrIn;
                        p_estado <= espera;
                        p_last_udlr <= last_udlr;
                        done_reg <= '1';
                        p_enableMemoria <='0';
                    else
                        p_estado <= estado;
                    end if;
                else
                    p_estado <= estado;
                end if;
            when others =>
                p_estado <= estado;
        end case;
    end process; --Asignación variables para las salidas
    puntosOut <= std_logic_vector(puntos);
    puntosEnable <=puntoEnable;
    enableMem <= enableMemoria;
    cc_udlr  <= aux_udlr_cc;
end Behavioral;
