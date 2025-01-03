----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2024 14:14:18
-- Design Name: 
-- Module Name: random_number - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LFSR_Random_Generator is
    Port ( clk               : in std_logic;               -- Reloj de entrada
         refresh             : in std_logic;               -- refresh
         seed                 : in std_logic_vector (4 downto 0);
         random_number_out : out std_logic_vector(4 downto 0)  -- Salida de 5 bits
        );
end LFSR_Random_Generator;

architecture Behavioral of LFSR_Random_Generator is

    signal lfsr,p_lfsr : std_logic_vector(4 downto 0); -- Semilla inicial
    signal cont,p_cont,Aux: std_logic_vector(10 downto 0):= "00000000000";
    signal cont3,p_cont3: std_logic_vector(6 downto 0):= "0000000";
begin
    -- Proceso que genera los números pseudoaleatorios en cada flanco de subida del reloj
    process(clk,cont,seed, Aux, cont3)
    begin
    
    lfsr <= seed;
        if cont = 500 then --Valor que ajusta la velocidad a la que son dadas las direcciones aleatorias
            -- Si se activa el refresh, se carga la semilla inicial
            cont <= "00000000000"; 
            Aux <= Aux +1;
            case Aux is --Estados distintos para darle más aleatoriedad y que no se repitan
                when "00000000001" => -- no movement
                lfsr <= "10100"+seed;
                when "00000000010" => -- no movement
                lfsr <= "10010" + seed;
               when "00000000011" => -- no movement
                lfsr <= "00111" + seed;
                when others => -- no movement
                lfsr <= "10111" + seed;
                Aux <= "00000000000";
                end case;
        elsif rising_edge(clk) then
            -- Cálculo del feedback: XOR de los bits especificados (taps)
            -- Tap en las posiciones 4 y 1
            lfsr <= p_lfsr;
            cont <= p_cont;
            cont3 <= p_cont3;
            Aux <= Aux; 

        end if;
    end process;

    comb :process(lfsr,cont,refresh, cont3)
    begin
        p_cont<= cont;
        p_cont3 <= cont3;
        p_lfsr <= lfsr;
        if(refresh = '1') then
         if(cont3 = 80) then
        p_lfsr(4) <= lfsr(4) xor lfsr(1);  -- Feedback calculado por XOR
        -- Desplazamos el registro, exceptuando el bit de feedback
        p_lfsr(3 downto 0) <= lfsr(4 downto 1);  -- Desplazamos el resto de los bits
        end if;
        p_cont3 <= cont3 + 1;
        p_cont <= cont +1;
        end if;
        
    end process;
    -- La salida del generador aleatorio es el valor del registro LFSR
    random_number_out <= lfsr;

end Behavioral;