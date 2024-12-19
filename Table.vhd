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
use IEEE.NUMERIC_STD.ALL;

entity Top is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        up,down,left,right : in STD_LOGIC;
        RGB:out std_logic_vector(11 downto 0);
        HS: out std_logic;
        AUDIO_OUT: out std_logic;
        VS: out std_logic;
        A : out STD_LOGIC; B : out STD_LOGIC; C : out STD_LOGIC; D : out STD_LOGIC; E : out STD_LOGIC; F : out STD_LOGIC; G : out STD_LOGIC; DP : out STD_LOGIC; 
        AN : out STD_LOGIC_VECTOR (3 downto 0)
    );
end Top;

architecture Behavioral of Top is

    signal refreshAux,move,enableComecocos,enableGhost1,enableGhost2,enableGhost3,enableGhost4, doneCC,doneG1,doneG2,doneG3,doneG4, muertoghost,muertoghost1,muertoghost2,muertoghost3,puntosEnable,sonidoMuerte,muertoghost4,choquePacman,gameover: STD_LOGIC;
    signal writeComeCocos,writeGhost1,writeGhost2,writeGhost3,writeGhost4,write : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addraIn,addraIn2,addrbIn,addraInCC,addraInG1,addraInG2,addraInG3,addraInG4: STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal dataIn,datbIn,dataInCC,dataInG1,dataInG2,dataInG3,dataInG4:STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal dataOut,datbOut,dataReset,dataGameOver:STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal udlr,udlr_ghost1,udlr_ghost2,udlr_ghost3,udlr_ghost4:STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal random1,random2,random3,random4 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal ejx,ejy :STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal puntos : std_logic_vector(6 downto 0);
    signal RGBaux,RGBOutaux, aux_douta_muro, aux_douta_bolita :STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal aux_addra_muro, aux_addra_bolita : std_logic_vector (7 downto 0);

    -- Señales auxiliares sprites del comecocos
    signal aux_addra_cc_abi_der, aux_addra_cc_abi_izq, aux_addra_cc_abi_arr, aux_addra_cc_abi_aba: std_logic_vector (7 downto 0);
    signal aux_douta_cc_abi_der, aux_douta_cc_abi_izq, aux_douta_cc_abi_arr, aux_douta_cc_abi_aba: std_logic_vector (11 downto 0);
    signal aux_addra_cc_cer_der, aux_addra_cc_cer_izq, aux_addra_cc_cer_arr, aux_addra_cc_cer_aba: std_logic_vector (7 downto 0);
    signal aux_douta_cc_cer_der, aux_douta_cc_cer_izq, aux_douta_cc_cer_arr, aux_douta_cc_cer_aba: std_logic_vector (11 downto 0);
    signal aux_last_udlr_cc : std_logic_vector (3 downto 0);

    -- Señales auxiliares sprites de los fantasmas
    signal aux_addra_fant_ver_der, aux_addra_fant_ver_izq, aux_addra_fant_ver_arr, aux_addra_fant_ver_aba : std_logic_vector (7 downto 0);
    signal aux_douta_fant_ver_der, aux_douta_fant_ver_izq, aux_douta_fant_ver_arr, aux_douta_fant_ver_aba : std_logic_vector (11 downto 0);
    signal aux_addra_fant_azu_der, aux_addra_fant_azu_izq, aux_addra_fant_azu_arr, aux_addra_fant_azu_aba : std_logic_vector (7 downto 0);
    signal aux_douta_fant_azu_der, aux_douta_fant_azu_izq, aux_douta_fant_azu_arr, aux_douta_fant_azu_aba : std_logic_vector (11 downto 0);
    signal aux_addra_fant_mar_der, aux_addra_fant_mar_izq, aux_addra_fant_mar_arr, aux_addra_fant_mar_aba : std_logic_vector (7 downto 0);
    signal aux_douta_fant_mar_der, aux_douta_fant_mar_izq, aux_douta_fant_mar_arr, aux_douta_fant_mar_aba : std_logic_vector (11 downto 0);
    signal aux_addra_fant_roj_der, aux_addra_fant_roj_izq, aux_addra_fant_roj_arr, aux_addra_fant_roj_aba : std_logic_vector (7 downto 0);
    signal aux_douta_fant_roj_der, aux_douta_fant_roj_izq, aux_douta_fant_roj_arr, aux_douta_fant_roj_aba : std_logic_vector (11 downto 0);
    signal aux_addra_corazon_empty : std_logic_vector (7 downto 0);
    signal aux_douta_corazon_empty : std_logic_vector (11 downto 0);
    signal aux_addra_corazon_full : std_logic_vector (7 downto 0);
    signal aux_douta_corazon_full : std_logic_vector (11 downto 0);

    component blk_mem_gen_0 is
        port (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            clkb : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            dinb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    component blk_mem_gen_1 IS
        port (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;
    
        component blk_mem_gen_2 IS
        port (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    end component;

    component PacMan_Sound is
        port (
            CLK_IN    : in  STD_LOGIC;  -- Reloj 100 MHz
            muerteSound : in STD_LOGIC;
            reset : in STD_LOGIC;
            AUDIO_OUT : out STD_LOGIC   -- Salida de audio (onda cuadrada)
        );
    end component;

    component muro is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component bolita is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_abi_der is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_cer_der is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_abi_izq is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_cer_izq is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_abi_arr is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_cer_arr is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_abi_aba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    component cc_cer_aba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    -- FANTASMA VERDE
    component fv_derecha is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fv_izquierda is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fv_arriba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fv_abajo is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    -- FANTASMA AZUL                
    component fa_derecha is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fa_izquierda is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fa_arriba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fa_abajo is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    -- FANTASMA MARRÓN 
    component fm_derecha is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fm_izquierda is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fm_arriba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fm_abajo is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;

    -- FANTASMA ROJO
    component fr_derecha is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fr_izquierda is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fr_arriba is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    component fr_abajo is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    
    --CORAZONES
    
    component corazon_lleno is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    
    component corazon_vacio is
        port (
            clka: in std_logic ;
            addra: in std_logic_vector (7 downto 0);
            douta : out std_logic_vector (11 downto 0));
    end component ;
    
    component ControlDisplayp2 is
        Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable: in STD_LOGIC;
        vel : in std_logic_vector(1 downto 0);
        updown : in std_logic;
        A : out STD_LOGIC; B : out STD_LOGIC; C : out STD_LOGIC; D : out STD_LOGIC; E : out STD_LOGIC; F : out STD_LOGIC; G : out STD_LOGIC; DP : out STD_LOGIC; 
        AN : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component dibuja is
        port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            eje_x : in STD_LOGIC_VECTOR (9 downto 0);
            eje_y : in STD_LOGIC_VECTOR (9 downto 0);

            udlrIn : in std_logic_vector (3 downto 0);
            udlrF1, udlrF2, udlrF3, udlrF4 : in std_logic_vector (3 downto 0);
            codigo_color : in std_logic_vector (3 downto 0);
            direccion : out STD_LOGIC_VECTOR (8 downto 0);
            RGB : out STD_LOGIC_VECTOR (11 downto 0);

            data_muro : in std_logic_vector (11 downto 0);
            dir_muro : out std_logic_vector (7 downto 0);

            data_bolita : in std_logic_vector (11 downto 0);
            dir_bolita: out std_logic_vector (7 downto 0);

            -- Señales comecocos
            data_cc_abi_der, data_cc_abi_izq, data_cc_abi_arr, data_cc_abi_aba : in std_logic_vector (11 downto 0);
            dir_cc_abi_der, dir_cc_abi_izq, dir_cc_abi_arr, dir_cc_abi_aba: out std_logic_vector (7 downto 0);

            data_cc_cer_der, data_cc_cer_izq, data_cc_cer_arr, data_cc_cer_aba : in std_logic_vector (11 downto 0);
            dir_cc_cer_der, dir_cc_cer_izq, dir_cc_cer_arr, dir_cc_cer_aba : out std_logic_vector (7 downto 0);

            -- Señales fantasmas            
            data_fant_ver_der, data_fant_ver_izq, data_fant_ver_arr, data_fant_ver_aba : in std_logic_vector (11 downto 0);
            dir_fant_ver_der, dir_fant_ver_izq, dir_fant_ver_arr, dir_fant_ver_aba : out std_logic_vector (7 downto 0);

            data_fant_azu_der, data_fant_azu_izq, data_fant_azu_arr, data_fant_azu_aba : in std_logic_vector (11 downto 0);
            dir_fant_azu_der, dir_fant_azu_izq, dir_fant_azu_arr, dir_fant_azu_aba : out std_logic_vector (7 downto 0);

            data_fant_mar_der, data_fant_mar_izq, data_fant_mar_arr, data_fant_mar_aba : in std_logic_vector (11 downto 0);
            dir_fant_mar_der, dir_fant_mar_izq, dir_fant_mar_arr, dir_fant_mar_aba : out std_logic_vector (7 downto 0);

            data_fant_roj_der, data_fant_roj_izq, data_fant_roj_arr, data_fant_roj_aba : in std_logic_vector (11 downto 0);
            dir_fant_roj_der, dir_fant_roj_izq, dir_fant_roj_arr, dir_fant_roj_aba : out std_logic_vector (7 downto 0);
            
            -- Señales corazones
            data_corazon_empty : in std_logic_vector (11 downto 0);
            dir_corazon_empty : out std_logic_vector (7 downto 0);
            
            data_corazon_full : in std_logic_vector (11 downto 0);
            dir_corazon_full : out std_logic_vector (7 downto 0));
            
            

    end component;

    component VGA_DRIVER is
        port(
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
        port(

            clk          : in STD_LOGIC;
            reset        : in STD_LOGIC;
            refresh      : in STD_LOGIC;
            empieza      : in std_logic;
            udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
            addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
            dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            enableMem    : out STD_LOGIC;
            done         : out STD_LOGIC;
            muerte       : in STD_LOGIC;
            GameOverOut  : out STD_LOGIC;
            puntosOut    : out STD_LOGIC_VECTOR(6 downto 0);
            puntosEnable : out STD_LOGIC;
            write        : out STD_LOGIC_VECTOR(0 DOWNTO 0);
            cc_udlr      : out std_logic_vector (3 downto 0);
            choqueOut    : out STD_LOGIC

        );
    end component;

    component Fantasma1 is
        port(
            clk          : in STD_LOGIC;
            reset        : in STD_LOGIC;
            refresh      : in STD_LOGIC;
            move         : in STD_LOGIC;
            empieza      : in std_logic;
            udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
            addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
            dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            enableMem    : out STD_LOGIC;
            done         : out STD_LOGIC;
            killghost    : out STD_LOGIC;
            write        : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

    component fantasma2 is
        port(
            clk          : in STD_LOGIC;
            reset        : in STD_LOGIC;
            refresh      : in STD_LOGIC;
            move         : in STD_LOGIC;
            empieza      : in std_logic;
            udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
            addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
            dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            enableMem    : out STD_LOGIC;
            done         : out STD_LOGIC;
            killghost    : out STD_LOGIC;
            write        : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

    component Fantasma3 is
        port(
            clk          : in STD_LOGIC;
            reset        : in STD_LOGIC;
            refresh      : in STD_LOGIC;
            move         : in STD_LOGIC;
            empieza      : in std_logic;
            udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
            addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
            dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            enableMem    : out STD_LOGIC;
            done         : out STD_LOGIC;
            killghost    : out STD_LOGIC;
            write        : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

    component Fantasma4 is
        port(
            clk          : in STD_LOGIC;
            reset        : in STD_LOGIC;
            refresh      : in STD_LOGIC;
            move         : in STD_LOGIC;
            empieza      : in std_logic;
            udlrIn       : in STD_LOGIC_VECTOR(3 downto 0);
            addressAOut  : out STD_LOGIC_VECTOR(8 DOWNTO 0);
            dAIn         : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            dAOut        : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            enableMem    : out STD_LOGIC;
            done         : out STD_LOGIC;
            killghost    : out STD_LOGIC;
            write        : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

    component gestion_botones  is
        port (

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

    component mov_fantasma is
        port (
            clk :in std_logic;
            random_number_in : in std_logic_vector (4 downto 0);
            udlr_ghost : out std_logic_vector(3 downto 0)
        );
    end component;

    component LFSR_Random_Generator is
        port ( clk               : in std_logic;               -- Reloj de entrada
             refresh             : in std_logic;               -- Reset
             seed                : in std_logic_vector(4 downto 0);
             random_number_out : out std_logic_vector(4 downto 0)  -- Salida de 5 bits
            );
    end component;

    component  Selector is
        port (
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
            dataGameOver: in STD_LOGIC_VECTOR(3 DOWNTO 0);


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
            WRITE      : out STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    end component;

begin
    rom : blk_mem_gen_1
        port map(
            clka => clk,
            addra =>addraIn,
            douta => dataReset
        );
        
     gameover_memory : blk_mem_gen_2
        port map(
            clka => clk,
            addra =>addraIn,
            douta => dataGameOver
      );

    sel : Selector
        port map
(
            eje_x =>ejx,
            eje_y => ejy,
            reset => reset,
            dataReset =>dataReset,
            dataGameOver => dataGameOver,
            gameOverIn => gameover,

            writeCC=>writeComeCocos,
            writeG1=>writeGhost1,
            writeG2=>writeGhost2,
            writeG3=>writeGhost3,
            writeG4=>writeGhost4,

            dataCC=>dataInCC,
            dataG1=>dataInG1,
            dataG2=>dataInG2,
            dataG3=>dataInG3,
            dataG4=>dataInG4,

            clk => clk,

            addraInCC =>addraInCC,
            addraInG1=>addraInG1,
            addraInG2=>addraInG2,
            addraInG3=>addraInG3,
            addraInG4=>addraInG4,

            PACMAN => enableComecocos,
            ghost1 => enableGhost1,
            ghost2 => enableGhost2,
            ghost3 => enableGhost3,
            ghost4 => enableGhost4,

            ADDRESS => addraIn,
            DATA =>dataIn,
            WRITE =>write
        );

    contador : ControlDisplayp2
        port map( 
            clk => clk,
            reset => reset,
            enable => puntosEnable,
            vel => "00",
            updown =>'0',
            A => A, 
            B => B,
            C => C,
            D => D,
            E => E,
            F => F,
            G => G,
            DP => DP, 
            AN => AN
         );
        
    sonidoPacman : PacMan_Sound
        port map(
            clk_IN => clk, AUDIO_OUT => AUDIO_OUT, muerteSound => gameover, reset => reset
        );

    movF1 : mov_fantasma
        port map(
            clk => clk, random_number_in => random1, udlr_ghost=>udlr_ghost1
        );

    movF2 : mov_fantasma
        port map(
            clk => clk, random_number_in => random2, udlr_ghost=>udlr_ghost2
        );

    movF3 : mov_fantasma
        port map(
            clk => clk, random_number_in => random3, udlr_ghost=>udlr_ghost3
        );

    movF4 : mov_fantasma
        port map(
            clk => clk, random_number_in => random4, udlr_ghost=>udlr_ghost4
        );

    generadorF1 :LFSR_Random_Generator
        port map (
            clk => clk,
            refresh => refreshAux,
            seed => "10100",
            random_number_out => random1
        );

    generadorF2 :LFSR_Random_Generator
        port map (
            clk => clk,
            refresh => refreshAux,
            seed => "10001",
            random_number_out => random2
        );

    generadorF3 :LFSR_Random_Generator
        port map (
            clk => clk,
            refresh => refreshAux,
            seed => "11110",
            random_number_out => random3
        );

    generadorF4 :LFSR_Random_Generator
        port map (
            clk => clk,
            refresh => refreshAux,
            seed => "10110",
            random_number_out => random4
        );

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
        port map(
            clk => clk,
            reset  => reset,
            refresh  => refreshAux,
            empieza =>doneG4,
            udlrIn  => udlr,
            addressAOut  =>addraInCC,
            dAIn     =>dataOut,
            dAOut       =>dataInCC,
            enableMem    =>enableComecocos,
            done         =>doneCC,
            puntosOut => puntos, 
            puntosEnable => puntosEnable, 
            write        => writeComeCocos,
            muerte => muertoghost,
            choqueOut => choquePacman,
            GameOverOut=> gameover,
            cc_udlr => aux_last_udlr_cc
        );

    ghost1 :  Fantasma1
        port map(
            empieza => doneCC,
            clk => clk,
            reset  => reset,
            refresh  => refreshAux,
            move => move  ,
            udlrIn  => udlr_ghost1,
            addressAOut  =>addraInG1,
            dAIn     =>dataOut,
            dAOut       =>dataInG1,
            enableMem    =>enableGhost1,
            done         =>doneG1,
            write        => writeGhost1,
            killghost    => muertoghost1
        );

    ghost2 :  fantasma2
        port map(
            empieza => doneG1,
            clk => clk,
            reset  => reset,
            refresh  => refreshAux,
            move => move  ,
            udlrIn  => udlr_ghost2,
            addressAOut  =>addraInG2,
            dAIn     =>dataOut,
            dAOut       =>dataInG2,
            enableMem    =>enableGhost2,
            done         =>doneG2,
            write        => writeGhost2,
            killghost    => muertoghost2
        );

    ghost3 :  Fantasma3
        port map(
            empieza => doneG2,
            clk => clk,
            reset  => reset,
            refresh  => refreshAux,
            move => move  ,
            udlrIn  => udlr_ghost3,
            addressAOut  =>addraInG3,
            dAIn     =>dataOut,
            dAOut       =>dataInG3,
            enableMem    =>enableGhost3,
            done         =>doneG3,
            write        => writeGhost3,
            killghost    => muertoghost3
        );

    ghost4 :  Fantasma4
        port map(
            empieza => doneG3,
            clk => clk,
            reset  => reset,
            refresh  => refreshAux,
            move => move  ,
            udlrIn  => udlr_ghost4,
            addressAOut  =>addraInG4,
            dAIn     =>dataOut,
            dAOut       =>dataInG4,
            enableMem    =>enableGhost4,
            done         =>doneG4,
            write        => writeGhost4,
            killghost    => muertoghost4
        );

    memoria :  blk_mem_gen_0
        port map(
            ena =>'1',
            wea =>write,
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

    murete : muro
        port map(
            clka =>clk,
            addra => aux_addra_muro,
            douta => aux_douta_muro
        );

    boli : bolita
        port map(
            clka =>clk,
            addra => aux_addra_bolita,
            douta => aux_douta_bolita
        );

    -- SPRITES PACMANS
    pacman_abi_der : cc_abi_der
        port map(
            clka =>clk,
            addra => aux_addra_cc_abi_der ,
            douta => aux_douta_cc_abi_der
        );

    pacman_cer_der : cc_cer_der
        port map(
            clka =>clk,
            addra => aux_addra_cc_cer_der ,
            douta => aux_douta_cc_cer_der
        );

    pacman_abi_izq : cc_abi_izq
        port map(
            clka =>clk,
            addra => aux_addra_cc_abi_izq ,
            douta => aux_douta_cc_abi_izq
        );

    corazon_full : corazon_lleno
        port map(
            clka =>clk,
            addra => aux_addra_corazon_full ,
            douta => aux_douta_corazon_full
        );
        
     corazon_empty : corazon_vacio
        port map(
            clka =>clk,
            addra => aux_addra_corazon_empty ,
            douta => aux_douta_corazon_empty
        );

    pacman_cer_izq : cc_cer_izq
        port map(
            clka =>clk,
            addra => aux_addra_cc_cer_izq ,
            douta => aux_douta_cc_cer_izq
        );

    pacman_abi_arr : cc_abi_arr
        port map(
            clka =>clk,
            addra => aux_addra_cc_abi_arr ,
            douta => aux_douta_cc_abi_arr
        );

    pacman_cer_arr : cc_cer_arr
        port map(
            clka =>clk,
            addra => aux_addra_cc_cer_arr ,
            douta => aux_douta_cc_cer_arr
        );

    pacman_abi_aba : cc_abi_aba
        port map(
            clka =>clk,
            addra => aux_addra_cc_abi_aba ,
            douta => aux_douta_cc_abi_aba
        );

    pacman_cer_aba : cc_cer_aba
        port map(
            clka =>clk,
            addra => aux_addra_cc_cer_aba ,
            douta => aux_douta_cc_cer_aba
        );


    -- SPRITES FANTASMAS        
    fant_ver_der : fv_derecha
        port map(
            clka => clk,
            addra => aux_addra_fant_ver_der,
            douta => aux_douta_fant_ver_der
        );
    fant_ver_izq : fv_izquierda
        port map(
            clka => clk,
            addra => aux_addra_fant_ver_izq,
            douta => aux_douta_fant_ver_izq
        );
    fant_ver_arr : fv_arriba
        port map(
            clka => clk,
            addra => aux_addra_fant_ver_arr,
            douta => aux_douta_fant_ver_arr
        );
    fant_ver_aba : fv_abajo
        port map(
            clka => clk,
            addra => aux_addra_fant_ver_aba,
            douta => aux_douta_fant_ver_aba
        );

    fant_azu_der : fa_derecha
        port map(
            clka => clk,
            addra => aux_addra_fant_azu_der,
            douta => aux_douta_fant_azu_der
        );
    fant_azu_izq : fa_izquierda
        port map(
            clka => clk,
            addra => aux_addra_fant_azu_izq,
            douta => aux_douta_fant_azu_izq
        );
    fant_azu_arr : fa_arriba
        port map(
            clka => clk,
            addra => aux_addra_fant_azu_arr,
            douta => aux_douta_fant_azu_arr
        );
    fant_azu_aba : fa_abajo
        port map(
            clka => clk,
            addra => aux_addra_fant_azu_aba,
            douta => aux_douta_fant_azu_aba
        );

    fant_mar_der : fm_derecha
        port map(
            clka => clk,
            addra => aux_addra_fant_mar_der,
            douta => aux_douta_fant_mar_der
        );
    fant_mar_izq : fm_izquierda
        port map(
            clka => clk,
            addra => aux_addra_fant_mar_izq,
            douta => aux_douta_fant_mar_izq
        );
    fant_mar_arr : fm_arriba
        port map(
            clka => clk,
            addra => aux_addra_fant_mar_arr,
            douta => aux_douta_fant_mar_arr
        );
    fant_mar_aba : fm_abajo
        port map(
            clka => clk,
            addra => aux_addra_fant_mar_aba,
            douta => aux_douta_fant_mar_aba
        );

    fant_roj_der : fr_derecha
        port map(
            clka => clk,
            addra => aux_addra_fant_roj_der,
            douta => aux_douta_fant_roj_der
        );
    fant_roj_izq : fr_izquierda
        port map(
            clka => clk,
            addra => aux_addra_fant_roj_izq,
            douta => aux_douta_fant_roj_izq
        );
    fant_roj_arr : fr_arriba
        port map(
            clka => clk,
            addra => aux_addra_fant_roj_arr,
            douta => aux_douta_fant_roj_arr
        );
    fant_roj_aba : fr_abajo
        port map(
            clka => clk,
            addra => aux_addra_fant_roj_aba,
            douta => aux_douta_fant_roj_aba
        );


    pintor : dibuja
        port map(
            clk => clk,
            reset => reset,
            eje_x => ejx,
            eje_y =>ejy,

            udlrIn => aux_last_udlr_cc ,
            udlrF1 => udlr_ghost1 ,
            udlrF2 => udlr_ghost2 ,
            udlrF3 => udlr_ghost3 ,
            udlrF4 => udlr_ghost4 ,
            codigo_color => datbOut,
            direccion => addrbIn,

            data_muro => aux_douta_muro,
            dir_muro => aux_addra_muro,

            data_bolita => aux_douta_bolita,
            dir_bolita => aux_addra_bolita,

            -- Señales comecocos
            data_cc_abi_der => aux_douta_cc_abi_der  ,
            dir_cc_abi_der => aux_addra_cc_abi_der  ,
            data_cc_cer_der => aux_douta_cc_cer_der  ,
            dir_cc_cer_der => aux_addra_cc_cer_der  ,

            data_cc_abi_izq => aux_douta_cc_abi_izq  ,
            dir_cc_abi_izq => aux_addra_cc_abi_izq  ,
            data_cc_cer_izq => aux_douta_cc_cer_izq  ,
            dir_cc_cer_izq => aux_addra_cc_cer_izq  ,

            data_cc_abi_arr => aux_douta_cc_abi_arr  ,
            dir_cc_abi_arr => aux_addra_cc_abi_arr  ,
            data_cc_cer_arr => aux_douta_cc_cer_arr  ,
            dir_cc_cer_arr => aux_addra_cc_cer_arr  ,

            data_cc_abi_aba => aux_douta_cc_abi_aba  ,
            dir_cc_abi_aba => aux_addra_cc_abi_aba  ,
            data_cc_cer_aba => aux_douta_cc_cer_aba  ,
            dir_cc_cer_aba => aux_addra_cc_cer_aba  ,

            -- Señales fantasmas
            data_fant_ver_der => aux_douta_fant_ver_der ,
            dir_fant_ver_der => aux_addra_fant_ver_der ,
            data_fant_ver_izq => aux_douta_fant_ver_izq ,
            dir_fant_ver_izq => aux_addra_fant_ver_izq ,
            data_fant_ver_arr => aux_douta_fant_ver_arr ,
            dir_fant_ver_arr => aux_addra_fant_ver_arr ,
            data_fant_ver_aba => aux_douta_fant_ver_aba ,
            dir_fant_ver_aba => aux_addra_fant_ver_aba ,

            data_fant_azu_der => aux_douta_fant_azu_der ,
            dir_fant_azu_der => aux_addra_fant_azu_der ,
            data_fant_azu_izq => aux_douta_fant_azu_izq ,
            dir_fant_azu_izq => aux_addra_fant_azu_izq ,
            data_fant_azu_arr => aux_douta_fant_azu_arr ,
            dir_fant_azu_arr => aux_addra_fant_azu_arr ,
            data_fant_azu_aba => aux_douta_fant_azu_aba ,
            dir_fant_azu_aba => aux_addra_fant_azu_aba ,

            data_fant_mar_der => aux_douta_fant_mar_der ,
            dir_fant_mar_der => aux_addra_fant_mar_der ,
            data_fant_mar_izq => aux_douta_fant_mar_izq ,
            dir_fant_mar_izq => aux_addra_fant_mar_izq ,
            data_fant_mar_arr => aux_douta_fant_mar_arr ,
            dir_fant_mar_arr => aux_addra_fant_mar_arr ,
            data_fant_mar_aba => aux_douta_fant_mar_aba ,
            dir_fant_mar_aba => aux_addra_fant_mar_aba ,

            data_fant_roj_der => aux_douta_fant_roj_der ,
            dir_fant_roj_der => aux_addra_fant_roj_der ,
            data_fant_roj_izq => aux_douta_fant_roj_izq ,
            dir_fant_roj_izq => aux_addra_fant_roj_izq ,
            data_fant_roj_arr => aux_douta_fant_roj_arr ,
            dir_fant_roj_arr => aux_addra_fant_roj_arr ,
            data_fant_roj_aba => aux_douta_fant_roj_aba ,
            dir_fant_roj_aba => aux_addra_fant_roj_aba ,
            
            data_corazon_empty => aux_douta_corazon_empty ,
            dir_corazon_empty => aux_addra_corazon_empty ,
            data_corazon_full => aux_douta_corazon_full ,
            dir_corazon_full => aux_addra_corazon_full ,

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
    sonidoMuerte <= choquePacman OR muertoghost;
    muertoghost <= muertoghost1 OR muertoghost2 OR muertoghost3 OR muertoghost4;
end Behavioral;