----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2024 00:52:52
-- Design Name: 
-- Module Name: PACMEM - Behavioral
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

entity PACMEM is
Port(
    clk : in STD_LOGIC; 
    reset : in STD_LOGIC; 
    empieza:in STD_LOGIC;
    up,down,left,right : in STD_LOGIC;
    refresh : in std_logic);
    
end PACMEM;

architecture Behavioral of PACMEM is
   signal refreshAux,move,enableComecocos: STD_LOGIC;
    signal writeComeCocos : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addraIn,addrbIn: STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal dataIn,datbIn:STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal dataOut,datbOut:STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal udlr:STD_LOGIC_VECTOR(3 DOWNTO 0); 
    signal ejx,ejy :STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal RGBaux,RGBOutaux :STD_LOGIC_VECTOR(11 DOWNTO 0);
component blk_mem_gen_0 is
         PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
  );
end component;
  component MaqPACMAN is
        Port(
        clk          : in STD_LOGIC;
        empieza      : in std_logic;
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
        write        : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
        end component;
          component gestion_botones  is 
      Port (
      
            clk : in std_logic;
            reset : in std_logic;
             up : in std_logic;
            down : in std_logic;
            left : in std_logic;
            right : in std_logic;
            move : out std_logic;
            udlrcc : out std_logic_vector(3 downto 0)
            );
       end component;
       
begin
botones : gestion_botones 
    port map(
    clk => clk,
    reset => reset,
    up => up,
    down => down,
    left => left,
    right => right,
    move => move,
    udlrcc => udlr
    );
    comecocos :  MaqPACMAN
    port map
    (
        clk => clk,  
        empieza => empieza,       
        reset  => reset,      
        refresh  => refresh,    
        move => move  ,      
        udlrIn  => udlr,     
        addressAIn  =>"000000000" ,
        addressAOut  =>addraIn,
        dAIn     =>dataOut,    
        dAOut       =>dataIn, 
        enableMem    =>enableComecocos,
        done         =>open,
        write        => writeComeCocos
        );
        memoria :  blk_mem_gen_0 
    port map(
        ena =>'1',
        wea =>writeComeCocos,
        web=>"0",
        addra =>addraIn,
        dina=>dataIn,
        douta=>dataOut,
        enb=>'1',
        clka => clk,
        clkb =>clk,
        addrb =>addrbIn,
        dinb => (others =>'0'),
        doutb =>datbOut  
    );

end Behavioral;
