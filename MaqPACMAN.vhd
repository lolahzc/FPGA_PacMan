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
    type estados is (reposo, botonDireccion, movimiento, muroEnMov, muroNoMov, movDir, botonDireccion2, noMov,pintaPacman);
    signal estado, p_estado    : estados;
    signal p_address,last_address          : std_logic_vector(8 downto 0);
    signal posx, p_posx, posx_ant     : std_logic_vector(3 downto 0);
    signal posy, p_posy, posy_ant        : std_logic_vector(4 downto 0);
    signal p_Dout : std_logic_vector(2 downto 0);
    signal last_udlr, p_last_udlr : std_logic_vector(3 downto 0);
    signal pacmanEnMov: std_logic;  -- Signal indicating if PacMan is in motion
    signal p_write  : std_logic_vector(0 downto 0);
    signal done_reg : std_logic  := '0'; -- Register done signal  

begin

    sync: process(clk, reset)
    begin
        -- Update the state and variables on each clock cycle
        if reset = '1' then
            estado <= reposo;
            posx <= (others => '0');
            posy <= (others => '0');
            last_udlr <= (others => '0');
            done <= '0';
            done_reg <= '0';
            pacmanEnMov <= '0';
            done_reg <= '0';
       
        elsif rising_edge(clk) then
        
            addressAOut <= p_address;
            dAOut <= p_Dout;
            estado <= p_estado;
            posx <= p_posx;
            posy <= p_posy;
            write <= p_write;   
            last_udlr <= p_last_udlr;

            if (p_estado = movimiento) then
                pacmanEnMov <= '1';
            else
                pacmanEnMov <= '0';
            end if; 

            done <= done_reg ;
          
            

        end if;
    end process;

    comb: process(estado, refresh, move, udlrIn, dAIn, p_posx, p_posy, posx, posy, pacmanEnMov)
    begin
        -- Default outputs
        p_Dout <= "000";
        p_write <= "0";
       
        p_estado <= estado;
        p_address <= p_posx & p_posy;
        p_posx <= posx;
        p_posy <= posy;
        enableMem <= '1';  
        done_reg <= '0';
             

    
        case estado is
            when reposo =>
                if move = '1'  then
                    p_posx <= "0001";  -- Initial X position
                    p_posy <= "00001"; -- Initial Y position
                    p_Dout <= "011";    -- Draw Pac-Man
                    p_address <= p_posx & p_posy;
                    p_write <= "1";
                    p_estado <= botonDireccion;
                end if;

            when botonDireccion =>
                posx_ant <= posx;
                posy_ant <= posy;
                p_write <="1";
                
                    if udlrIn = "1000" then  -- UP direction
                    
                        p_posx <= std_logic_vector(unsigned(posx) - 1);
                        p_posy <= posy;
                        p_estado <= movimiento;
                    elsif udlrIn = "0100" then  -- DOWN direction
                        p_posx <= std_logic_vector(unsigned(posx) + 1);
                        p_posy <= posy;
                        p_estado <= movimiento;
                    elsif udlrIn = "0010" then  -- LEFT direction
                        p_posx <= posx;
                        p_posy <= std_logic_vector(unsigned(posy) - 1);
                        p_estado <= movimiento;
                    elsif udlrIn = "0001" then  -- RIGHT direction
                        p_posx <= posx;
                        p_posy <= std_logic_vector(unsigned(posy) + 1);
                        p_estado <= movimiento;
                    else
                        p_estado <= reposo;
                    end if;
        

            when movimiento =>
                if (pacmanEnMov = '1' ) then
                    
                    p_address <= posx_ant & posy_ant ;
                    p_Dout <= "000"; --Dibujo pacman en la posición siguiente
                    p_write <="1";
                    --Me voy a la pos anterior y pinto vacío
                    done_reg <= '1';     
                    p_estado <= pintaPacman; --
                    
                    elsif( Refresh = '1' )        then
                    p_estado <= muroNoMov;
                    end if;
            when pintaPacman =>
               
                p_address <= p_posx & p_posy;
                p_Dout <= "011";
                p_write <="1";
                if(Refresh = '1' ) then
                
                p_estado <= muroEnMov;
                else
                p_estado <= estado;
               end if;
             
            when muroEnMov =>
                if  (udlrIn = "1000" and dAIn = "001") or 
                    (udlrIn = "0100" and dAIn = "001") or 
                    (udlrIn = "0010" and dAIn = "001") or 
                    (udlrIn = "0001" and dAIn = "001") then  -- Wall detected
                    p_estado <= muroEnMov;              --Si detecta un muro no hace nada
                else
                    p_estado <= botonDireccion2;             -- Move in button direction
                end if;

            when botonDireccion2 =>
                if move = '1'  then  
                    p_estado <= botonDireccion; --Si le siguen llegando señales de movimiento, se va al principio
                else
                    p_estado <= noMov; --Si no tiene señales, que no se mueva
                end if;

            when muroNoMov =>
                if  (udlrIn = "1000" and dAIn /= "001") or 
                    (udlrIn = "0100" and dAIn /= "001") or 
                    (udlrIn = "0010" and dAIn /= "001") or 
                    (udlrIn = "0001" and dAIn /= "001") then  -- No wall, proceed
                    p_estado <= botonDireccion2;
                else
                    p_estado <= botonDireccion;
                end if;

            when noMov =>
                -- Stop movement and reset to initial direction
                p_write <= "0";
                p_estado <= botonDireccion2;
                

            when others =>
                p_estado <= reposo;

        end case;
    end process;

end Behavioral;
