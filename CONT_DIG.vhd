----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2024 13:59:18
-- Design Name: 
-- Module Name: CONTADOR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTADOR is
    Generic (Nbit: INTEGER := 3);
    Port ( 
    clk : in STD_LOGIC;
    reset : in STD_LOGIC; 
    resets : in STD_LOGIC; 
    enable : in STD_LOGIC;
    cuenta : out STD_LOGIC_VECTOR (Nbit-1 downto 0));
end CONTADOR;

architecture Behavioral of CONTADOR is

signal p_cuenta, cont: unsigned(Nbit-1 downto 0);

begin

sinc:process(clk,reset)
begin
    if(reset = '1') then
        cont <= (others=>'0');
    elsif(rising_edge(clk)) then 
        cont <= p_cuenta;
end if;

end process sinc;

comb: process(cont,  enable, resets)
begin
   if(resets = '1') then  p_cuenta <= (others=>'0'); 
   else
         p_cuenta<= cont;
     if(enable = '1') then
             p_cuenta <= cont + 1;
        end if;
        
    end if;
end process comb;
cuenta <= std_logic_vector(cont);
end Behavioral;
