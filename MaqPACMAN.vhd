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
        write        : out STD_LOGIC
    );
end MaqPACMAN;

architecture Behavioral of MaqPACMAN is
    type estados is (reposo, botonDireccion, movimiento, muroEnMov, muroNoMov, movDir, botonDireccion2, noMov);
    signal estado, p_estado    : estados;
    signal posx, p_posx        : std_logic_vector(3 downto 0);
    signal posy, p_posy        : std_logic_vector(4 downto 0);
    signal last_udlr, p_last_udlr : std_logic_vector(3 downto 0);
    signal pacmanEnMov         : std_logic;  -- Signal indicating if PacMan is in motion
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
            write <= '0';
       
        elsif rising_edge(clk) then
            estado <= p_estado;
            posx <= p_posx;
            posy <= p_posy;
            last_udlr <= p_last_udlr;

            if p_estado = movimiento then
                pacmanEnMov <= '1';
            else
                pacmanEnMov <= '0';
            end if; 

            done <= done_reg ;
            done_reg <= '0'; -- Desactivate 'done_reg' in each refresh
            write <= '0';

        end if;
    end process;

    comb: process(estado, refresh, move, udlrIn, dAIn)
    begin
        -- Default outputs
        dAOut <= "000";
        enableMem <= '1';
        write <= '0';
        p_estado <= estado;
        pacmanEnMov <= '0';
        done_reg <= '0';

        case estado is
            when reposo =>
                if move = '1' and refresh = '1' then
                    p_posx <= "0001";  -- Initial X position
                    p_posy <= "00001"; -- Initial Y position
                    dAOut <= "011";    -- Draw Pac-Man
                    write <= '1';
                    p_estado <= botonDireccion;
                end if;

            when botonDireccion =>
                if refresh = '1' then
                    if udlrIn = "1000" then  -- UP direction
                        addressAOut <= std_logic_vector(unsigned(p_posy) - 1) & posx;
                        p_estado <= movimiento;
                    elsif udlrIn = "0100" then  -- DOWN direction
                        addressAOut <= std_logic_vector(unsigned(p_posy) + 1) & posx;
                        p_estado <= movimiento;
                    elsif udlrIn = "0010" then  -- LEFT direction
                        addressAOut <= p_posy & std_logic_vector(unsigned(posx) - 1);
                        p_estado <= movimiento;
                    elsif udlrIn = "0001" then  -- RIGHT direction
                        addressAOut <= p_posy & std_logic_vector(unsigned(posx) + 1);
                        p_estado <= movimiento;
                    else
                        p_estado <= reposo;
                    end if;
                end if;

            when movimiento =>
                if pacmanEnMov = '1' then
                    p_estado <= muroEnMov;
                    done_reg <= '1';    -- Correct movement
                    
                    addressAOut <= p_posx & p_posy ;
                    dAOut <= "000";
                    write <= '1';
                    addressAOut <= posx & posy; 
                    dAOut <= "011";     -- As it's a correct movement draw PacMan
                    write <= '1';       -- Activate write to draw 
                else
                    p_estado <= muroNoMov;
                end if;

            when muroEnMov =>
                if  (udlrIn = "1000" and dAIn = "001") or 
                    (udlrIn = "0100" and dAIn = "001") or 
                    (udlrIn = "0010" and dAIn = "001") or 
                    (udlrIn = "0001" and dAIn = "001") then  -- Wall detected
                    p_estado <= botonDireccion;              -- Maintain direction
                else
                    p_estado <= botonDireccion2;             -- Move in button direction
                end if;

            when botonDireccion2 =>
                if move = '1' and refresh = '1' then  
                    p_estado <= muroEnMov;
                else
                    p_estado <= noMov;
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
                write <= '0';
                p_estado <= reposo;

            when others =>
                p_estado <= reposo;

        end case;
    end process;

end Behavioral;