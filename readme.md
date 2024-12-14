# Proyecto de Sistemas Electrónicos

<img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/89b84315-dcdf-4df9-81e4-f400764ca127.__CR0,0,2011,622_PT0_SX970_V1___.jpg" alt="Pac-Man Encabezado" width="100%" style="border-radius: 10px; box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.3);" />

<!-- <a href="https://github.com/lolahzc/FPGA_PacMan/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=lolahzc/FPGA_PacMan" alt="Contributors" />
</a> -->

![VHDL](https://img.shields.io/badge/VHDL-FPGA-blue?logo=verilog&logoColor=white)
![Vivado](https://img.shields.io/badge/Tool-Vivado-orange?logo=xilinx&logoColor=white)
![FPGA](https://img.shields.io/badge/Hardware-FPGA-green?logo=altiumdesigner&logoColor=white)
![Project Status](https://img.shields.io/badge/Status-In_Progress-yellow)
![Hardware](https://img.shields.io/badge/Board-Basys_3-blue?logo=chip&logoColor=white)
![Languages](https://img.shields.io/badge/Languages-VHDL-pink?logo=verilog&logoColor=white)
[![Contributors](https://img.shields.io/github/contributors/lolahzc/FPGA_PacMan)](https://github.com/lolahzc/FPGA_PacMan/graphs/contributors)

## Pac-Man en FPGA

Proyecto realizado para la asignatura de Sistemas Electrónicos del grado de Ingeniería Electrónica, Robótica y Mecatrónica.

Código programado en VHDL mediante la utilización de Vivado. 

- [Proyecto de Sistemas Electrónicos](#proyecto-de-sistemas-electrónicos)
  - [Pac-Man en FPGA](#pac-man-en-fpga)
  - [Guía de Uso](#guía-de-uso)
    - [Requisitos](#requisitos)
    - [Pasos para usar el Proyecto](#pasos-para-usar-el-proyecto)
  - [Archivos del Proyecto](#archivos-del-proyecto)
    - [Estructura de Top](#estructura-de-top)
      - [Descripción de los principales módulos](#descripción-de-los-principales-módulos)
    - [Estructura de Selector](#estructura-de-selector)
      - [Descripción del módulo:](#descripción-del-módulo)
    - [Estructura de movFantasma](#estructura-de-movfantasma)
      - [Descripción del módulo:](#descripción-del-módulo-1)
      - [Funcionamiento:](#funcionamiento)
    - [Estructura de LFSF\_Generator](#estructura-de-lfsf_generator)
      - [Descripción del módulo:](#descripción-del-módulo-2)
      - [Funcionamiento:](#funcionamiento-1)
      - [Características:](#características)
    - [Estructura de gestión botones](#estructura-de-gestión-botones)
      - [Descripción del módulo:](#descripción-del-módulo-3)
      - [Funcionamiento:](#funcionamiento-2)
    - [Estructura de MaqPACMAN](#estructura-de-maqpacman)
      - [Estados de la máquina](#estados-de-la-máquina)
      - [Lógica de transición de estados](#lógica-de-transición-de-estados)
    - [Estructura de Fantasma1](#estructura-de-fantasma1)
      - [Estados de la máquina](#estados-de-la-máquina-1)
      - [Lógica de transición](#lógica-de-transición)
      - [Funciones Adicionales](#funciones-adicionales)
    - [Estructura de dibuja](#estructura-de-dibuja)
      - [Funcionamiento](#funcionamiento-3)
    - [Estructura de VGA\_DRIVER](#estructura-de-vga_driver)
      - [Componentes del Módulo:](#componentes-del-módulo)
        - [1. FREC\_PIXEL:](#1-frec_pixel)
        - [2. CONTADOR:](#2-contador)
        - [3. COMPARADOR:](#3-comparador)
        - [4. GEN\_COLOR:](#4-gen_color)
      - [Funcionalidad del Sistema:](#funcionalidad-del-sistema)
      - [Comportamiento de las Señales:](#comportamiento-de-las-señales)

![Pacman and Ghosts](separador.png)

## Guía de Uso

Este proyecto implementa el clásico juego de **Pacman** en una FPGA, utilizando una **Basys3** como placa de desarrollo y un monitor **VGA** para la salida visual. A continuación, te explicaré los pasos necesarios para cargar el proyecto en tu FPGA, conectar la placa al monitor y entender cómo está configurado el archivo de restricciones.

### Requisitos

Antes de comenzar, asegúrate de tener los siguientes elementos:

- **Placa FPGA Basys3** (o cualquier otra compatible con los archivos de restricciones proporcionados).
- Un **cable USB** para conectar la Basys3 a tu computadora.
- Un **monitor VGA** con entrada VGA y el cable correspondiente para conectarlo a la Basys3.
- **Vivado** (o el software adecuado para tu FPGA) para cargar el archivo `.bit` en la placa.

### Pasos para usar el Proyecto

1. **Conectar la Placa FPGA al Monitor VGA**:
   
   - Conecta la **Basys3** a tu monitor VGA usando el cable VGA.
   - La **Basys3** tiene una salida VGA incorporada, por lo que solo necesitas conectar el cable VGA entre la placa y el monitor. Asegúrate de que el monitor esté configurado correctamente para recibir la señal VGA.

2. **Cargar el archivo `.bit` en la FPGA**:
   
   - Abre **Vivado** o el software que utilices para trabajar con tu FPGA.
   - Carga el proyecto en Vivado. El archivo `.bit` es el archivo de configuración para la FPGA, que contiene la implementación del diseño del juego de Pacman.
   - Conecta tu **Basys3** a la computadora mediante el cable USB.
   - Una vez que la FPGA esté conectada, utiliza Vivado para cargar el archivo `.bit` en la FPGA.
     - En Vivado, puedes ir a **Program and Configure** y seleccionar el archivo `.bit` que contiene tu diseño.
     - Haz clic en **Program Device** para cargar el diseño en la FPGA.

3. **Verifica la Configuración del Monitor**:
   
   - Una vez que el archivo `.bit` esté cargado en la FPGA, deberías ver el juego de Pacman en el monitor VGA.
   - Si no ves nada en el monitor, verifica que los cables estén correctamente conectados y que el monitor esté configurado en la entrada VGA.

4. **Revisar el Archivo de Restricciones**:

   El archivo de restricciones es importante porque define cómo los pines de la FPGA están conectados a los diferentes dispositivos externos, como el **monitor VGA**. En este proyecto, hemos configurado específicamente los pines de la **Basys3** para que estén listos para la salida VGA.


![Pacman and Ghosts](separador.png)


## Archivos del Proyecto

Aquí tienes un esquema de los archivos en mi proyecto de Vivado:

```plaintext
Proyecto_FPGA/
└── Top                        : Top (Table.vhd)
    ├── sel                    : Selector (Selector.vhd)
    ├── movF1                  : movfantasma (udlrFantasma.vhd)
    ├── generadorF1            : LF_SR_Random_Generator (random.vhd)
    ├── botones                : gestion_botones (botonescc.vhd)
    ├── comecos                : MaqPACMAN (fsmPacMan.vhd)
    ├── ghost1                 : Fantasma1 (Fantasma1.vhd)
    ├── memoria                : blk_mem_gen_0 (blk_mem_gen_0.xci)
    ├── muro                   : muro (muro.xci)
    ├── boli                   : bolita (bolita.xci)
    ├── cc_sprite              : pacman_sprite (pacman_sprite.xci)
    ├── cc_sprite2             : pacman_sprite2 (pacman_sprite2.xci)
    ├── fant_r1                : fantasmar_r (fantasma_r.xci)
    ├── pintor                 : dibuja (dibuja.vhd)
    └── driver                 : VGA_DRIVER (VGA_MONITOR.vhd)
```
### Estructura de Top

Este archivo VHDL implementa el módulo Top de un sistema basado en FPGA para un juego de PacMan. El diseño se organiza bajo una arquitectura Behavioral y contiene múltiples componentes que interactúan entre sí, como los controladores para los movimientos del jugador y los fantasmas, la gestión de memoria, la generación de gráficos en la pantalla, y el manejo de los botones del juego.

#### Descripción de los principales módulos

1. **Control de movimiento:** Los componentes `mov_fantasma` y `gestion_botones` gestionan el movimiento del PacMan y los fantasmas, respectivamente,
2. **Generación de gráficos:** Los módulos `VGA_Driver` y `dibuja` son responsables de generar la señal VGA para la salida a pantalla, incluyendo la representación de los sprites de todos los componentes del juego.
3. **Memoria:** En el código se encuentran distintos bloques del tipo `.xci`, los cuáles gestionan la memoria para almacenar los diferentes objetos, muros o incluso el mapa del juego.
4. **Lógica del juego:** Los módulos `MaqPACMAN` o `Fantasma1` son unos de los encargados de gestionar la lógica del juego, ya sea el movimiento, la recolección de las bolas o las interacciones entre el PacMan y los fantasmas.

Este diseño utiliza comunicación entre componentes a través de señales y es capaz de visualizarse en un monitor mediante una FPGA que genera una señal VGA, interactuando con el jugador a través de los botones físicos para mover a PacMan y los fantasmas.

![Pacman and Ghosts](separador.png)


### Estructura de Selector

Este archivo VHDL implementa el módulo `Selector` que es responsable de seleccionar y dirigir los datos correctos hacia la memoria dependiendo de la entidad activa en el juego, es decir, PacMan o el primer fantasma. El módulo utiliza señales de control para decidir cuál de los dos elementos (PacMan o Fantasma) debe ser procesado en cada ciclo de reloj.

#### Descripción del módulo:
  **`Selector`**: Este módulo recibe como entradas las direcciones, los datos y las señales de escritura de PacMan y del primer fantasma. Dependiendo de las señales de control (`PACMAN` y `GHOST1`), selecciona la dirección, los datos y las señales de escritura correspondientes. Estos valores seleccionados son enviados a la memoria para su procesamiento.
- **Entradas**: 
  - `addraInCC`, `dataCC`, `writeCC` para PacMan.
  - `addraInG1`, `dataG1`, `writeG1` para el primer fantasma.
  - `PACMAN` y `GHOST1` como señales de control que determinan cuál de los dos elementos es procesado.
- **Salidas**: 
  - `ADDRESS`, `DATA` y `WRITE`, que son enviados a la memoria según la entidad seleccionada.

Este módulo es esencial para gestionar las interacciones de memoria entre PacMan, el primer fantasma y otros elementos del sistema, permitiendo que cada uno controle su propia porción de la memoria sin interferencias.


![Pacman and Ghosts](separador.png)

### Estructura de movFantasma

Este archivo VHDL implementa el módulo **`mov_fantasma`**, que gestiona el movimiento de un fantasma en un sistema basado en un generador de números aleatorios. El módulo recibe un número aleatorio como entrada y genera una dirección de movimiento para el fantasma (arriba, abajo, izquierda, derecha, o sin movimiento). El movimiento se decide de acuerdo con los valores de este número aleatorio.

#### Descripción del módulo:
**`mov_fantasma`**: Este módulo recibe como entrada un número aleatorio de 5 bits, que se utiliza para determinar la dirección en la que debe moverse el fantasma. Las direcciones posibles son:
  - **Arriba**: Representada por `1000`.
  - **Abajo**: Representada por `0100`.
  - **Izquierda**: Representada por `0001`.
  - **Derecha**: Representada por `0010`.
  - **Sin movimiento**: Representada por `0000`.

- **Entradas**:
  - `clk`: Señal de reloj que sincroniza el proceso.
  - `random_number_in`: Un número aleatorio de 5 bits utilizado para determinar la dirección del fantasma.

- **Salidas**:
  - `udlr_ghost`: La dirección de movimiento generada para el fantasma. Esta salida está codificada en 4 bits, representando las direcciones mencionadas anteriormente.

#### Funcionamiento:
- El módulo utiliza un generador de números aleatorios para decidir la dirección del fantasma en cada ciclo de reloj. Dependiendo del valor del número aleatorio de entrada, el fantasma se moverá en una de las 4 direcciones (arriba, abajo, izquierda, derecha) o permanecerá en su lugar.
- El número aleatorio se divide en combinaciones específicas que corresponden a cada dirección, y el módulo actualiza la salida `udlr_ghost` para reflejar la dirección seleccionada.

Este módulo es útil en sistemas de videojuegos o simulaciones donde el movimiento de los fantasmas debe ser aleatorio para proporcionar una experiencia dinámica y no predecible.

![Pacman and Ghosts](separador.png)

### Estructura de LFSF_Generator

Este archivo VHDL implementa un generador de números pseudoaleatorios basado en un **LFSR (Linear Feedback Shift Register)** de 5 bits. El generador produce una secuencia de números aleatorios mediante el desplazamiento de bits en un registro de desplazamiento, con un cálculo de retroalimentación (feedback) mediante una operación XOR.

#### Descripción del módulo:
  **`LFSR_Random_Generator`**: Este módulo genera números pseudoaleatorios de 5 bits basados en un registro de desplazamiento de retroalimentación lineal. Los números generados se utilizan como una secuencia aleatoria para ser empleados en diversos procesos, como la generación de movimientos aleatorios en un juego.

- **Entradas**:
  - `clk`: Señal de reloj para sincronizar la generación de números aleatorios.
  - `refresh`: Señal de activación para recargar la semilla inicial y reiniciar el contador de ciclos.
  
- **Salidas**:
  - `random_number_out`: Un número pseudoaleatorio de 5 bits, generado por el registro LFSR.

#### Funcionamiento:
- El generador LFSR utiliza un registro de 5 bits y una semilla inicial (`"10101"`) para comenzar el proceso. En cada flanco de subida del reloj, el valor del registro se actualiza mediante un cálculo de retroalimentación XOR entre los bits en las posiciones especificadas.
  
- El contador `cont` se utiliza para manejar los ciclos de la generación de números aleatorios. Después de un número predefinido de ciclos, el generador puede recargar una nueva semilla inicial para generar una nueva secuencia aleatoria.

- El proceso también incluye una función de "refresh" que recarga la semilla inicial y permite reiniciar la generación de números aleatorios desde un punto conocido, lo que es útil en sistemas que requieren reiniciar la secuencia aleatoria en algún punto del proceso.

#### Características:
- **Semilla inicial**: `"10101"` (y otras configuraciones posibles, como `"10100"`, `"10010"`, `"00111"`, `"10111"` dependiendo del contador).
- **Operación XOR**: El feedback se calcula mediante una operación XOR entre los bits en las posiciones 4 y 1 del registro.
- **Contadores**: Se utilizan contadores para controlar los ciclos de generación y la recarga de la semilla.

Este módulo es útil en sistemas que requieren la generación de secuencias de números aleatorios, como juegos, simulaciones o algoritmos que necesiten generar números impredecibles de manera eficiente.

![Pacman and Ghosts](separador.png)

### Estructura de gestión botones
Este archivo VHDL implementa un módulo de gestión de botones para un sistema de control basado en las teclas **up**, **down**, **left**, y **right**. El módulo detecta la pulsación de cada botón y genera una señal de movimiento (`move`) y una salida que indica la dirección correspondiente en un vector de 4 bits (`udlrcc`).

#### Descripción del módulo:
  **`gestion_botones`**: Módulo encargado de gestionar las señales de los botones de dirección (arriba, abajo, izquierda, derecha) y generar una señal de movimiento.

- **Entradas**:
  - `clk`: Señal de reloj.
  - `reset`: Señal de reinicio para restablecer el estado de los botones.
  - `up`, `down`, `left`, `right`: Señales de entrada para los botones de dirección.

- **Salidas**:
  - `move`: Señal de movimiento activada cuando un botón es presionado.
  - `udlrcc`: Salida de 4 bits que indica la dirección correspondiente (up = "1000", down = "0100", left = "0010", right = "0001").

#### Funcionamiento:
- El proceso sincronizado con el reloj y el reset gestiona el valor del vector `udlr`, que refleja la dirección del último botón presionado.
- El proceso combinado examina la señal de entrada (`udlr_in`) y activa la señal `move` cuando un botón es presionado.
- El estado de los botones se almacena en un registro `udlr`, y la dirección seleccionada se refleja en la salida `udlrcc`.

Este módulo es útil en sistemas de control donde se necesitan detectar pulsaciones de botones para mover un objeto o realizar alguna acción basada en direcciones.

![Pacman and Ghosts](separador.png)

### Estructura de MaqPACMAN

Este proyecto implementa una máquina de estados finitos (FSM) en VHDL que gestiona el control del personaje de **Pac-Man** en un entorno de juego. La FSM se encarga de controlar los movimientos de Pac-Man, detectar colisiones, y gestionar las interacciones con el entorno.

#### Estados de la máquina
La máquina de estados consta de varios estados que controlan el comportamiento de Pac-Man:

1. **reposo**: Estado inicial en el que Pac-Man se encuentra en su posición predeterminada.
2. **espera**: Pac-Man espera la señal de inicio o verifica si ha ocurrido una colisión o muerte.
3. **botonDireccion**: Pac-Man recibe la entrada del usuario sobre la dirección en la que se debe mover.
4. **movimiento**: Pac-Man intenta moverse en la dirección seleccionada.
5. **comprueboDireccion**: Verifica si la dirección deseada es válida, es decir, si no hay obstáculos.
6. **confirmoDireccion**: Si la dirección es válida, Pac-Man se mueve; si no, vuelve a la posición anterior.
7. **pintaPacman**: Se actualiza la pantalla para reflejar la nueva posición de Pac-Man.

La FSM se activa en cada ciclo de reloj (`clk`) y utiliza una señal de reinicio (`reset`) para restablecer su estado. En función del estado actual, la máquina actualiza la posición de Pac-Man, verifica si ha colisionado con un obstáculo, y controla si Pac-Man debe moverse, esperar o finalizar el juego.

#### Lógica de transición de estados

- **reposo**: Pac-Man comienza en una posición predeterminada.
- **espera**: Pac-Man espera la señal de inicio o verifica si ha muerto o colisionado.
- **botonDireccion**: Pac-Man lee la dirección del movimiento del usuario.
- **movimiento**: Pac-Man intenta moverse en la dirección seleccionada.
- **comprueboDireccion**: Pac-Man verifica si la dirección deseada es válida.
- **confirmoDireccion**: Si la dirección es válida, Pac-Man se mueve; si no, vuelve a la posición anterior.
- **pintaPacman**: Se actualiza la posición de Pac-Man en la pantalla.

![Pacman and Ghosts](separador.png)

### Estructura de Fantasma1

Este código implementa una máquina de estados finitos (FSM) en VHDL para controlar el comportamiento de un **fantasma** en el juego Pac-Man. El código gestiona la posición del fantasma, su movimiento y las interacciones con el entorno, como las paredes y las bolas. A continuación se describe brevemente el flujo del código:

#### Estados de la máquina

La máquina de estados tiene los siguientes estados:

1. **reposo**: El fantasma está en su posición inicial.
2. **espera**: El sistema espera la señal de inicio del juego.
3. **botonDireccion**: Se captura la dirección de movimiento del fantasma.
4. **movimiento**: El fantasma intenta moverse según la dirección indicada.
5. **comprueboDireccion**: Verifica si la nueva dirección es válida.
6. **confirmoDireccion**: Si la dirección es válida, el fantasma se mueve; si no, vuelve a la posición anterior.
7. **pintaPacman**: Se actualiza la posición del fantasma en la pantalla.


#### Lógica de transición 
- El **fantasma** comienza en el estado `reposo`, donde se establece su posición inicial.
- En el estado `espera`, se espera a que se inicie el juego.
- En el estado `botonDireccion`, se recibe la dirección de movimiento del fantasma y se verifica si hay bolas o muros.
- Si no hay obstáculos, el fantasma se mueve en la dirección indicada.
- En `movimiento`, se actualiza la dirección y se verifica si el movimiento es válido.
- Finalmente, el estado `pintaPacman` actualiza la pantalla con la nueva posición del fantasma.
  
#### Funciones Adicionales

- El código también incluye la gestión de las **colisiones** con muros y bolas. Si el fantasma se encuentra con un muro, su dirección se ajusta.
- Si el fantasma entra en contacto con Pac-Man, se activa la señal `killghost`, indicando que el fantasma ha sido "matado".

![Pacman and Ghosts](separador.png)

### Estructura de dibuja

Este código implementa un módulo en VHDL que se encarga de **dibujar** diferentes elementos en una pantalla. Los elementos incluyen **muros**, **bolas**, **Pac-Man** y **fantasmas**. El módulo recibe las coordenadas `eje_x` y `eje_y`, así como un código de color para determinar qué se debe dibujar en cada posición.

#### Funcionamiento

1. **Temporizador para Alternar los Sprites de Pac-Man:**
   Un contador de 26 bits (`cuenta_pacman`) se usa para alternar entre dos sprites de Pac-Man cada segundo. Esto se logra al incrementar el contador en cada ciclo de reloj y cambiar el valor del sprite cuando el contador alcanza el valor `49999999`.

2. **Proceso de Dibujo:**
   Este proceso evalúa las coordenadas `eje_x` y `eje_y` para determinar qué se debe dibujar en esas posiciones. Según el valor de `codigo_color`, el proceso realiza las siguientes acciones:
   
   - **Vacío (codigo_color = "000")**: Pinta el fondo de color negro.
   - **Muros (codigo_color = "001")**: Dibuja los muros con el color especificado en `data_muro`.
   - **Bolas (codigo_color = "010")**: Dibuja las bolas con el color especificado en `data_bolita`.
   - **Pac-Man (codigo_color = "011")**: Dibuja el sprite de Pac-Man, alternando entre dos versiones del sprite dependiendo del valor de `pacman_sprite`.
   - **Fantasmas (codigo_color = "100")**: Dibuja el fantasma con el color especificado en `data_fant_r`.
   
3. **Valores fuera del rango (eje_x y eje_y fuera del rango 0-511 y 0-255)**:
   Si las coordenadas están fuera del rango válido, se asignan colores por defecto (blanco), y las direcciones de memoria también se configuran a valores predeterminados.

4. **Cálculo de Fila y Columna:**
   Las coordenadas `eje_x` y `eje_y` se dividen en dos partes para determinar la fila y la columna en la pantalla. La fila es calculada a partir de los bits 7 a 4 de `eje_y`, y la columna de los bits 8 a 4 de `eje_x`.

5. **Generación del Valor RGB:**
   Finalmente, los valores de color (rojo, verde y azul) se combinan para formar la salida final `RGB`, que se usará para dibujar el pixel en la pantalla.

![Pacman and Ghosts](separador.png)

### Estructura de VGA_DRIVER

Este es un módulo en VHDL para controlar un **monitor VGA**, específicamente encargado de generar las señales de sincronización horizontal (HS) y vertical (VS), así como manejar la asignación de píxeles en pantalla. El módulo también incluye componentes adicionales para el contador de píxeles y la generación de color.

#### Componentes del Módulo:

##### 1. FREC_PIXEL:
   - Este componente genera una señal (`sat`) para indicar cuando un nuevo píxel debe ser procesado en el reloj.

##### 2. CONTADOR:
   - Se utilizan dos instancias de este componente para contar los píxeles horizontales (`ejx`) y verticales (`ejy`). El contador de píxeles se incrementa en función de la señal `sat`, lo que asegura que el dibujo en pantalla se realice correctamente.

##### 3. COMPARADOR:
   - Dos comparadores (uno para la dirección horizontal y otro para la vertical) se utilizan para generar las señales de sincronización (HS y VS). Estas señales indican cuándo deben comenzar y finalizar las líneas de píxeles (en el eje X y Y) para cada fotograma.
   - **Comparador Horizontal**: Controla el inicio y final de la línea en el eje X.
   - **Comparador Vertical**: Controla el inicio y final de las líneas en el eje Y.

##### 4. GEN_COLOR:
   - Este componente genera el color del píxel, tomando en cuenta si el píxel está dentro del área visible o en el borde (sin mostrar nada). Combina las señales de entrada `RGBin` (que contiene el valor de color para cada píxel) y las señales de vacío (`blank_h` y `blank_v`) para decidir si mostrar un color o mantener el píxel en blanco.

#### Funcionalidad del Sistema:

1. **Contadores (ejx, ejy)**:
   - Los contadores (`ejx` y `ejy`) llevan el conteo de los píxeles en los ejes X e Y respectivamente.
   - El contador en el eje X cuenta de 0 a 639 (ancho de la pantalla) y el contador en el eje Y cuenta de 0 a 479 (alto de la pantalla).

2. **Sincronización**:
   - La señal de sincronización horizontal (HS) y vertical (VS) son generadas por los comparadores, basándose en los valores de los contadores `ejx` y `ejy`. Estas señales se utilizan para indicar el inicio y fin de las líneas y la actualización de la pantalla.
   - **HS**: Se activa cuando la coordenada `ejx` está en el rango de 655 a 751, señalando el final de cada línea horizontal.
   - **VS**: Se activa cuando `ejy` está en el rango de 489 a 491, señalando el final de un fotograma.

3. **Generación de Color**:
   - Si las coordenadas del píxel están dentro de los límites de la pantalla (basado en los contadores), el componente `gen_color` toma el valor de color de `RGBin` y lo asigna a las señales de salida `RGB` (en formato de 12 bits).
   - Si el píxel está fuera del área visible (en la frontera de la pantalla), se genera un píxel en blanco, no mostrando ningún color.

4. **Señal de Actualización (refresh)**:
   - La señal `refresh` se activa cuando se alcanza el final de la línea (por `s3`), indicando que el sistema debe actualizar la pantalla con los nuevos valores de color.

#### Comportamiento de las Señales:
- **HS**: Se activa cuando se llega al final de una línea (en función de las coordenadas X) y se desactiva en el inicio de la siguiente línea.
- **VS**: Se activa cuando se alcanza el final de la pantalla vertical (en función de las coordenadas Y).
- **RGB**: Es la salida final que combina los colores de los píxeles, basándose en las coordenadas y las señales de sincronización.
