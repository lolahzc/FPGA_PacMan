----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2024 11:07:47
-- Design Name: 
-- Module Name: DIV_FREC - Behavioral
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

entity FREC_PIXEL is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sat : out STD_LOGIC);
end FREC_PIXEL;



architecture Behavioral of FREC_PIXEL is
signal p_cont,cont: unsigned(2 downto 0);
begin

sec:process(clk,reset)
begin
    if(reset='1') then
        cont<=(others =>'0');
    elsif(rising_edge(clk)) then
        cont<=p_cont;
    end if;
 end process;
 
 comb:process(cont)
 begin
 p_cont<=cont+1;
 if(cont="011") then
 sat<= '1';
 p_cont<=(others =>'0');
 else
 sat <='0';
 end if;
 end process;
 
end Behavioral;
