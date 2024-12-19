----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
--
-- Create Date: 23.11.2024 15:22:33
-- Design Name: 
-- Module Name: Selector - Behavioral
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

entity Selector is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        gameOverIn : in STD_LOGIC;
        addraInCC  : in  STD_LOGIC_VECTOR(8 DOWNTO 0);
        addraInG1  : in  STD_LOGIC_VECTOR(8 DOWNTO 0);
        addraInG2  : in  STD_LOGIC_VECTOR(8 DOWNTO 0);
        addraInG3  : in  STD_LOGIC_VECTOR(8 DOWNTO 0);
        addraInG4  : in  STD_LOGIC_VECTOR(8 DOWNTO 0);
        dataCC     : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataG1     : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataG2     : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataG3     : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataG4     : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataReset  : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
        writeCC    : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
        writeG1    : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
        writeG2    : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
        writeG3    : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
        writeG4    : in  STD_LOGIC_VECTOR(0 DOWNTO 0);
        eje_x      : in  STD_LOGIC_VECTOR(9 DOWNTO 0);
        eje_y      : in  STD_LOGIC_VECTOR(9 DOWNTO 0);
        PACMAN     : in  STD_LOGIC;
        GHOST1     : in  STD_LOGIC;
        GHOST2     : in  STD_LOGIC;
        GHOST3     : in  STD_LOGIC;
        GHOST4     : in  STD_LOGIC;
        ADDRESS    : out STD_LOGIC_VECTOR(8 DOWNTO 0);
        DATA       : out STD_LOGIC_VECTOR(3 DOWNTO 0);
        WRITE      : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        dataGameOver  : in  STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end Selector;

architecture Behavioral of Selector is
    type estados is (normal, reseteo,gameover);
    signal p_address : STD_LOGIC_VECTOR(8 DOWNTO 0) := (others => '0');
    signal p_data    : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal p_write   : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
    signal fila      : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal columna   : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal estado, p_estado : estados; 
begin

    -- Cálculo de fila y columna
    fila    <= eje_y(7 DOWNTO 4);
    columna <= eje_x(4 DOWNTO 0);

    resetear: process(clk,reset, fila, estado, columna, PACMAN, GHOST1, GHOST2, GHOST3, GHOST4,
                     addraInCC, addraInG1, addraInG2, addraInG3, addraInG4,
                     dataCC, dataG1, dataG2, dataG3, dataG4, dataReset,
                     writeCC, writeG1, writeG2, writeG3, writeG4, dataGameOver,gameOverIn)
    begin
    if(rising_edge(clk)) then
    estado <= p_estado;
    end if;
    p_estado <= normal;
    case estado is
        when normal =>
         if (PACMAN = '1') then
                p_address <= addraInCC;
                p_data    <= dataCC;
                p_write   <= writeCC;
            elsif (GHOST1 = '1') then
                p_address <= addraInG1;
                p_data    <= dataG1;
                p_write   <= writeG1;
            elsif (GHOST2 = '1') then
                p_address <= addraInG2;
                p_data    <= dataG2;
                p_write   <= writeG2;
            elsif (GHOST3 = '1') then
                p_address <= addraInG3;
                p_data    <= dataG3;
                p_write   <= writeG3;
            elsif (GHOST4 = '1') then
                p_address <= addraInG4;
                p_data    <= dataG4;
                p_write   <= writeG4;
            else
                p_address <= (others => '0');
                p_data    <= (others => '0');
                p_write   <= (others => '0');
            end if;
            if(reset ='1') then
            p_estado <= reseteo;
            end if;
            if(gameOverIn = '1') then
            p_estado <= gameover;
            end if;
        when reseteo =>
            p_data    <= dataReset;
            p_address <= fila & columna;
            p_write   <= "1";
            p_estado <= estado;
            if(columna = "11111" AND fila = "1111") then
            P_estado <= normal;
            
            end if;
         when gameover =>
            p_data    <= dataGameOver;
            p_address <= fila & columna;
            p_write   <= "1";
            p_estado <= estado;
            if(columna = "11111" AND fila = "1111") then
            P_estado <= normal;
            end if;
        end case;
            -- Determina quién está activo y asigna en consecuencia
           
    end process;

    ADDRESS <= p_address;
    DATA    <= p_data;
    WRITE   <= p_write;

end Behavioral;