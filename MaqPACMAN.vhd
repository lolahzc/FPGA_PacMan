-- Máquina de Estados PacMan

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MaqPACMAN is
    Port (
        clk          : in STD_LOGIC;
        reset        : in STD_LOGIC;
        refresh      : in STD_LOGIC;
        move         : in STD_LOGIC;
        udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
        addressAIn   : in STD_LOGIC_VECTOR(8 DOWNTO 0);
        addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
        dAIn         : in STD_LOGIC_VECTOR(2 DOWNTO 0);
        dAOut        : out STD_LOGIC_VECTOR(2 DOWNTO 0);
        enableMem    : out STD_LOGIC;
        done         : out STD_LOGIC;
        write        : out STD_LOGIC_VECTOR(0 downto 0)
    );
end MaqPACMAN;

architecture Behavioral of MaqPACMAN is
    type estados is (reposo, botonDireccion, movimiento, comprueboDireccion, confirmoDireccion, muroEnMov, muroNoMov, movDir, botonDireccion2, noMov, pintaPacman);
    signal estado, p_estado       : estados;
    signal p_address, last_address : std_logic_vector(8 downto 0);
    signal posx, p_posx, posx_ant, p_posx_ant : std_logic_vector(3 downto 0);
    signal posy, p_posy, posy_ant, p_posy_ant : std_logic_vector(4 downto 0);
    signal p_Dout                 : std_logic_vector(2 downto 0);
    signal last_udlr, p_last_udlr,udlr : std_logic_vector(3 downto 0);
    signal pacmanEnMov,hayMuro ,p_hayMuro           : std_logic; -- Signal indicating if PacMan is in motion
    signal p_write                : std_logic_vector(0 downto 0);
    signal done_reg               : std_logic := '0'; -- Register done signal
    signal p_ciclo,ciclos : unsigned (4 downto 0);

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
        pacmanEnMov <= '0';
        addressAOut <= (others => '0');
        dAOut <= (others => '0');
        hayMuro <= '0';

    elsif rising_edge(clk) then
        addressAOut <= p_address;
        dAOut <= p_Dout;
        estado <= p_estado;
        posx <= p_posx;
        posy <= p_posy;
        posx_ant <= p_posx_ant;
        posy_ant <= p_posy_ant;
        hayMuro <= p_hayMuro;
        write <= p_write;
        ciclos <= p_ciclo;

    

        if p_estado = movimiento then
            pacmanEnMov <= '1';
        else
            pacmanEnMov <= '0';
        end if;

        done <= done_reg;
    end if;
end process;

    comb: process(estado, refresh, move,last_udlr,udlr,hayMuro, udlrIn, dAIn, p_posx, p_posy, posx,posx_ant,posy_ant, posy,ciclos, pacmanEnMov)
    begin
        -- Default outputs
        udlr <= udlrIn;
        p_ciclo <= "00000";
        p_Dout <= "000";
        p_write <= "0";
        p_estado <= estado;
        p_address <= p_posx & p_posy;
        p_posx <= posx;
        p_posy <= posy;
        p_posx_ant <= posx_ant;
        p_posy_ant <= posy_ant;
        enableMem <= '1';
        done_reg <= '0';
        p_hayMuro <= hayMuro;
        case estado is
            when reposo =>
                if move = '1' then
                    p_posx <= "0001";  -- Initial X position
                    p_posy <= "00001"; -- Initial Y position
                    p_Dout <= "011";   -- Draw Pac-Man
                    p_address <= p_posx & p_posy;
                    p_write <= "1";
                    p_estado <= botonDireccion;
                end if;

           when botonDireccion =>
            p_posx_ant <= posx;
            p_posy_ant <= posy;
            p_write <= "1";
            p_Dout <= "000";
            p_address <= posx_ant & posy_ant;
          
            
            -- Comparación entre last_udlr y udlr
            if (hayMuro = '1') then
               udlr <= p_last_udlr; -- Reutiliza la dirección anterior si hay muro
            end if;

            if udlr = "1000" then
                p_posx <= std_logic_vector(unsigned(posx) - 1);
                p_posy <= posy;
                p_estado <= movimiento;
            elsif udlr = "0100" then
                p_posx <= std_logic_vector(unsigned(posx) + 1);
                p_posy <= posy;
                p_estado <= movimiento;
            elsif udlr = "0010" then
                p_posx <= posx;
                p_posy <= std_logic_vector(unsigned(posy) - 1);
                p_estado <= movimiento;
            elsif udlr = "0001" then
                p_posx <= posx;
                p_posy <= std_logic_vector(unsigned(posy) + 1);
                p_estado <= movimiento;
            else
            
                p_estado <= estado;
            end if;
            last_udlr <= udlr;
            when movimiento =>
                if pacmanEnMov = '1' then   --Aquí lo que hago es que pongo un cero
                    p_address <= posx_ant & posy_ant; 
                    p_Dout <= "000";
                    p_write <= "1";
                    done_reg <= '1';
                    p_estado <= comprueboDireccion;
                elsif refresh = '1' then
                    p_estado <= muroNoMov;
                end if;
            --AQUÍ DEBERÍA HABER OTRO ESTADO QUE PONGA LA SALIDA PARA QUE PUEDA FUNCIONAR.
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
                p_write <= "1";
                if(dAIn = "001") then --Si hay muro. 
                --Primero he puesto un cero, si hay un muro se escribe arriba y vuelve a movimiento
                    p_hayMuro<='1';
                     p_posx <= posx_ant; 
                     p_posy <= posy_ant;
                      p_estado <= pintaPacman;
                    --Esto pinta el pacman en la posición anterior
                elsif (p_last_udlr = last_udlr) then
                      p_hayMuro<='0';
                      else
                       p_last_udlr <= udlr;
                end if;
                p_estado <= pintaPacman;
                p_address <= p_posx & p_posy;
        
           when pintaPacman => --Aquí pinto en la casilla siguiente o en la anterior en función de confirmo dirección
                p_address <= p_posx & p_posy;
          
                p_ciclo <= ciclos;
                p_Dout <= "011";
                p_write <= "1";
                if refresh = '1' then
                    p_ciclo <= ciclos +1;
                    if ciclos >20 then
                    --p_Dout <= "000";
                    p_write <= "0";
                    p_estado <= botonDireccion;
                         last_udlr <= p_last_udlr;
                    else
                     p_estado <= estado;
                    end if;
                else
                    p_estado <= estado;
                end if;

            when muroEnMov =>
                if (udlrIn = "1000" and dAIn = "001") or
                   (udlrIn = "0100" and dAIn = "001") or
                   (udlrIn = "0010" and dAIn = "001") or
                   (udlrIn = "0001" and dAIn = "001") then
                    p_estado <= muroEnMov;
                else
                    p_estado <= botonDireccion2;
                end if;

            when botonDireccion2 =>
             p_write <= "0";
                if move = '1' then
                    p_estado <= botonDireccion;
                else
                    p_estado <= botonDireccion;
                end if;

            when muroNoMov =>
                if (udlrIn = "1000" and dAIn /= "001") or
                   (udlrIn = "0100" and dAIn /= "001") or
                   (udlrIn = "0010" and dAIn /= "001") or
                   (udlrIn = "0001" and dAIn /= "001") then
                    p_estado <= botonDireccion2;
                else
                    p_estado <= botonDireccion;
                end if;

            when noMov =>
                p_write <= "0";
                p_estado <= botonDireccion2;

            when others =>
                p_estado <= reposo;
        end case;
    end process;

end Behavioral;
