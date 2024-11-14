----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2024 13:16:35
-- Design Name: 
-- Module Name: toptransmision - Behavioral
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

entity Top is
Port ( 
    clk : in STD_LOGIC; 
    reset : in STD_LOGIC; 
    up,down,left,right : in STD_LOGIC;
    RGB:out std_logic_vector(11 downto 0);
    HS: out std_logic;
    VS: out std_logic
    );
end Top;

architecture Behavioral of Top is

    signal refreshAux,move,enableComecocos: STD_LOGIC;
    signal writeComeCocos : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addraIn,addrbIn: STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal dataIn,datbIn:STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal dataOut,datbOut:STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal ejx,ejy,udlr :STD_LOGIC_VECTOR(9 DOWNTO 0);
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

    component dibuja is
    Port ( 
                eje_x : in STD_LOGIC_VECTOR (9 downto 0);
                eje_y : in STD_LOGIC_VECTOR (9 downto 0);
           
                codigo_color : in std_logic_vector (2 downto 0);
                direccion : out STD_LOGIC_VECTOR (8 downto 0);
                RGB : out STD_LOGIC_VECTOR (11 downto 0));
end component;


    component VGA_DRIVER is
    Port(
     clk : in STD_LOGIC; 
     reset : in STD_LOGIC; 
     RGBin : in STD_LOGIC_VECTOR (11 downto 0);
     VS : out STD_LOGIC; 
     HS : out STD_LOGIC;
     refresh : out STD_LOGIC;  
     eje_x : out STD_LOGIC_VECTOR (9 downto 0);
     eje_y : out STD_LOGIC_VECTOR (9 downto 0); 
     RGB : out STD_LOGIC_VECTOR (11 downto 0));
    end  component;
    
    component MaqPACMAN is
        Port(
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
        end component;
      component gestion_botones  is 
      Port ( up : in std_logic;
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
        reset  => reset,      
        refresh  => refreshAux,    
        move => move  ,      
        udlrIn  => udlr,     
        addressAIn  =>open ,
        addressAOut  =>addraIn,
        dAIn     =>dataOut,    
        dAOut       =>dataIn, 
        enableMem    =>enableComecocos,
        done         =>open,
        write        => std_logic(writeComeCocos)
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
pintor : dibuja
  port map(
           eje_x => ejx,
           eje_y =>ejy,
           
           codigo_color => datbOut,
           direccion => addrbIn,
           
          RGB => RGBaux
    );
 driver: VGA_DRIVER
   port map(
     clk => clk, 
     reset=> reset, 
     RGBin=> RGBaux,
     VS =>VS, 
     HS =>HS,  
     eje_x =>ejx,
     eje_y =>ejy, 
     RGB =>RGBOutaux,
     refresh => refreshAux
    );
 RGB<=RGBOutaux;
end Behavioral;
