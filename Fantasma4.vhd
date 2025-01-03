-- Máquina de Estados PacMan

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fantasma4 is
    Port (
        clk          : in STD_LOGIC;
        reset        : in STD_LOGIC;
        refresh      : in STD_LOGIC;
        move         : in STD_LOGIC;
        empieza      : in STD_LOGIC;
        udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
        addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
        dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        enableMem    : out STD_LOGIC;
        done         : out STD_LOGIC;
        killghost    : out STD_LOGIC;
        write        : out STD_LOGIC_VECTOR(0 downto 0)
    );
end Fantasma4;

architecture Behavioral of Fantasma4 is
    type estados is (reposo, espera,botonDireccion, movimiento, comprueboDireccion, confirmoDireccion,pintaPacman);
    signal estado, p_estado       : estados;
    signal p_address, last_address : std_logic_vector(8 downto 0);
    signal posx, p_posx, posx_ant, p_posx_ant : std_logic_vector(3 downto 0) :=("0001");
    signal posy, p_posy, posy_ant, p_posy_ant : std_logic_vector(4 downto 0):=("00001");
    signal p_Dout                 : std_logic_vector(3 downto 0);
    signal last_udlr, p_last_udlr,udlr,p_udlr : std_logic_vector(3 downto 0);
    signal hayMuro ,p_hayMuro,hayBola,p_hayBola,p_kill           : std_logic; -- Signal indicating if PacMan is in motion
    signal p_write                : std_logic_vector(0 downto 0);
    signal done_reg ,enableMemoria, p_enableMemoria             : std_logic := '1'; -- Register done signal
    signal p_ciclo,ciclos : unsigned (4 downto 0);

begin

sync: process(clk, reset)
begin
    if reset = '1' then
        estado <= reposo;
        enableMemoria <= '1';
        posx <= (others => '0');
        posy <= (others => '0');
        done <= '0';
        hayBola<='0';
        posy_ant <= (others => '0');
        posx_ant <= (others => '0');
        ciclos <= "00000";
        killghost <='0';
        addressAOut <=(others => '0');
        dAOut <= "0000";
        hayMuro <= '0';
        write <="0";
        udlr <= (others => '0');
        last_udlr <= "0001";
    elsif rising_edge(clk) then
        addressAOut <= p_address;
        killghost <= p_kill;
        hayBola<=p_hayBola;
        dAOut <= p_Dout;
        estado <= p_estado;
        posx <= p_posx;
        posy <= p_posy;
        posx_ant <= p_posx_ant;
        posy_ant <= p_posy_ant;
        hayMuro <= p_hayMuro;
        write <= p_write;
        ciclos <= p_ciclo;
        udlr <= p_udlr;
        last_udlr <= p_last_udlr;
        enableMemoria <= p_enableMemoria;
        done <= done_reg;
    end if;
end process;

comb: process(estado, refresh,done_reg, empieza, move,p_last_udlr,last_udlr,udlr,hayMuro, udlrIn, dAIn, p_posx, p_posy, posx,posx_ant,posy_ant, posy,ciclos,hayBola, enableMemoria)
begin
    -- Default outputs
    p_last_udlr <= last_udlr; --Mantiene el valor del anterior
    p_kill <= '0';
    p_udlr <= udlr; --Mantiene el valor del anterior
    p_ciclo <= "00000"; --Resetea el ciclo
    p_Dout <= "0000"; --Pone vacío por defecto
    p_write <= "0"; --Por defecto no escribe
    p_estado <= estado; --Se manteine en el mismo estado
    p_address <= p_posx & p_posy; --Actualiza la posición
    p_posx <= posx; --Por defecto la pos anterior
    p_posy <= posy;
    p_posx_ant <= posx_ant; --Por defecto la pos anterior
    p_posy_ant <= posy_ant;
    --Por defecto siempre está activo
    done_reg <= '0';
    p_hayBola <= hayBola;
    p_hayMuro <= hayMuro;
    p_enableMemoria <= enableMemoria;
    case estado is
    when reposo =>
        p_posx <= "0001";  -- Initial X position
        p_posy <= "00100"; -- Initial Y position
        p_Dout <= "0111";
        if move = '1' then
            -- Draw Pac-Man
            p_address <= p_posx & p_posy;
            p_write <= "1";
            p_udlr <= udlrIn;
            p_estado <= espera;
            done_reg <= '0';
        end if;
    when espera =>
        p_enableMemoria<='0';
        p_kill <= '0';
        if(empieza ='1') then

            p_estado <= botonDireccion;
        else
            p_estado <= espera;
        end if;

    when botonDireccion =>
        p_enableMemoria <= '1';
        p_udlr <= udlrIn;
        p_posx_ant <= posx;
        p_posy_ant <= posy;
        p_write <= "0";
        if(hayBola = '1') then
        if(ciclos >2) then
            p_Dout <= "0010";
            else 
            p_estado <= estado;
            end if;
        else
         if(ciclos >2) then
         p_write <= "1";
            p_Dout<= "0000";
             
            else 
            p_estado <= estado;
            end if;
        end if;

        p_address <= posx_ant & posy_ant;
        p_ciclo <= ciclos +1;

        -- Comparación entre last_udlr y udlr
        if (hayMuro = '1') then
            p_udlr <= last_udlr; -- Reutiliza la dirección anterior si hay muro
            p_estado <= estado;
        end if;
        if(ciclos >2) then

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
            p_hayMuro <= '1'; -- Si no sabe qué hacer que coja el anterior
            p_estado <= estado;
        end if;
    else p_estado <=estado;
                    end if;
            when movimiento =>
            
                    p_address <= posx_ant & posy_ant;                 
                    p_write <= "1";
                    p_estado <= comprueboDireccion;
                     if(hayBola = '1') then
                      p_Dout <= "0010";

                      else
           p_Dout <= "0000";
           end if;
            when comprueboDireccion =>
                p_write <= "0";
                p_address <= p_posx & p_posy;
                p_ciclo <= ciclos +1;

                if(ciclos = 5) then
                    p_estado <= confirmoDireccion;
                else
                    p_estado <= comprueboDireccion;
                end if;

            when confirmoDireccion => --Aquí verifico si hay muro o no --ASIGNO LA SIGUIENTE SALIDA
                p_write <= "0";
                p_estado <= pintaPacman;
                p_address <= p_posx & p_posy;
                if(dAIn = "0001") then --Si hay muro. 
                    p_hayBola<=hayBola;--Primero he puesto un cero, si hay un muro se escribe arriba y vuelve a movimiento
                    if(last_udlr /= udlr) then --Veo si  puedo ir en la dirección anterior
                        p_posx <= posx_ant;
                        p_posy <= posy_ant;
                        p_last_udlr <= last_udlr;
                        p_hayMuro<='1';
                        p_estado <= botonDireccion;
                    else
                        p_hayMuro<='0';
                        p_posx <= posx_ant;
                        p_posy <= posy_ant;
                        p_estado <= pintaPacman;
                    end if;
                --Esto pinta el pacman en la posición anterior
                
                elsif(dAIn = "0010" or (dAIn/="0010" and hayBola ='1')) then--Hay bolas o la ultima fue bola
                    if(dAIn = "0010") then
                    p_hayBola<='1';
                    p_hayMuro<='0';
                    p_last_udlr <= udlr;
                    elsif(dAIn/="0010" and hayBola ='1') then
                    p_hayBola<='0';
                    p_hayMuro<='0';
                    p_last_udlr <= udlr;
                    p_write <="1";
                    p_Dout <= "0010";
                    p_address <= posx_ant & posy_ant;
                    else
                    p_hayMuro<='0';
                       p_hayBola<='0';
                    p_last_udlr <= udlr;
                    end if;
                    end if;
                if(dAIn = "0011") then               
                    p_hayMuro<='0';
                    p_last_udlr <= udlr;
                    p_kill <= '1';
                p_estado <= pintaPacman;
                
         
                
            end if;

           when pintaPacman => --Aquí pinto en la casilla siguiente o en la anterior en función de confirmo dirección
                p_address <= p_posx & p_posy;
                p_ciclo <= ciclos;
                p_Dout <= "0111";
                p_write <= "1";
                    p_ciclo <= ciclos +1;
                   p_enableMemoria<='1';
                   if ciclos = 8 then 
                   p_write <= "0";
                   p_estado <= estado;
                   end if;
                   if ciclos >10 then
                        p_write <= "0";
                        p_udlr <= udlrIn;
                        p_estado <= espera;
                        p_last_udlr <= last_udlr;
                         done_reg <= '1';
                         p_enableMemoria <='0';
                    else
                        p_estado <= estado;
                    end if;

    

            when others =>
                p_estado <= estado;

        end case;
    end process;
    enableMem<=enableMemoria;
end Behavioral;