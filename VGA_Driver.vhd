----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2024 13:18:12
-- Design Name: 
-- Module Name: gen_color - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Driver is 
Port ( 
blank_h : in STD_LOGIC; 
blank_v : in STD_LOGIC; 
RED_in : in STD_LOGIC_VECTOR (3 downto 0); 
GRN_in : in STD_LOGIC_VECTOR (3 downto 0); 
BLU_in : in STD_LOGIC_VECTOR (3 downto 0); 
RED : out STD_LOGIC_VECTOR (3 downto 0); 
GRN : out STD_LOGIC_VECTOR (3 downto 0); 
BLU : out STD_LOGIC_VECTOR (3 downto 0)); 
end VGA_Driver;

architecture Behavioral of VGA_Driver is
begin
gen_color:process(blank_h, blank_v, red_in, grn_in, blu_in)
begin
    if (blank_h ='1' or blank_v ='1') then
        red<=(others => '0');
        grn<=(others => '0');
        blu<=(others => '0');
    else
        red<=red_in;
        grn<=grn_in;
        blu<=blu_in;
    end if;
end process;
end Behavioral;