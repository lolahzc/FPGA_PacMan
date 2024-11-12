----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2024 13:26:28
-- Design Name: 
-- Module Name: comparador - Behavioral
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

entity comparador is
    Generic (Nbit: integer :=8;
    End_Of_Screen: integer :=10;
    Start_Of_Pulse: integer :=20;
    End_Of_Pulse: integer := 30;
    End_Of_Line: integer := 40);
    Port ( O1 : out STD_LOGIC;
           O2 : out STD_LOGIC;
           O3 : out STD_LOGIC;
           reset : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
           clk : in STD_LOGIC);
end comparador;

architecture Behavioral of comparador is
signal p_uno,p_dos,p_tres : STD_LOGIC;
begin
sinc:process (clk,reset)
begin
    if (reset = '1') then
        O1 <='0';
        O2 <='0';
        O3 <='0';
    elsif (clk'event and clk='1') then
        O1<= p_uno;
        O2<=p_dos;
        O3<=p_tres;
    end if;
end process;
comb:process (data, p_uno,p_dos,p_tres)
begin
if(unsigned(data) > End_Of_Screen) then
    p_uno <= '1';
else
    p_uno <='0';
end if;
if(Start_Of_Pulse< unsigned(data) and unsigned (data)<End_Of_Pulse) then
    p_dos <= '0';
else
    p_dos <='1';
end if;
if(unsigned(data) = End_Of_Line) then
    p_tres <= '1';
else
    p_tres <='0';
end if;
end process;
end Behavioral;
