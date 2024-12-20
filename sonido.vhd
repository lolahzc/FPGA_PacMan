library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PacMan_Sound is
    Port (
        reset : in STD_LOGIC;
        CLK_IN    : in  STD_LOGIC;  -- Reloj 100 MHz
        muerteSound : in STD_LOGIC;
        AUDIO_OUT : out STD_LOGIC   -- Salida de audio (onda cuadrada)
    );
end PacMan_Sound;

architecture Behavioral of PacMan_Sound is
    -- Frecuencia del reloj
    constant CLK_FREQ : integer := 100_000_000;  -- 100 MHz

    -- Frecuencias elegidas para imitar el "waka-waka" de Pac-Man:
    -- A5 = 880 Hz y C6 ? 1046 Hz
    constant FREQ_LOW  : integer := 900;
    constant FREQ_HIGH : integer := 1046;

    -- C�lculo del semiper�odo para cada frecuencia
    constant HALF_PERIOD_LOW  : integer := CLK_FREQ / (2 * FREQ_LOW);
    constant HALF_PERIOD_HIGH : integer := CLK_FREQ / (2 * FREQ_HIGH);

    -- Duraci�n de cada nota ~80 ms (ajustar seg�n gusto)
    constant NOTE_DURATION_MS : integer := 130; 
    constant NOTE_DURATION    : integer := (CLK_FREQ / 1000) * NOTE_DURATION_MS;
    type estados is (muerte, vivo);
    type STATE_TYPE is (S_LOW, S_HIGH);
    signal state    : STATE_TYPE := S_LOW;

    signal counter  : integer := 0;  
    signal tone_cnt : integer := 0;  
    signal half_per : integer := HALF_PERIOD_LOW;
    signal audio_sig: STD_LOGIC := '0';
    signal estado,p_estado : estados;

begin

    process(CLK_IN,reset)
    begin
    if(reset = '1') then
     audio_sig <= '0';
        elsif rising_edge(CLK_IN) then
            -- Controla el tiempo que se mantiene cada nota
            
            if(muerteSound = '1') then
            if counter < NOTE_DURATION then
                counter <= counter + 1;
            else
                counter <= 0;
                -- Alterna entre nota baja y alta para crear el "waka-waka"
                if state = S_LOW then
                    state    <= S_HIGH;
                    half_per <= HALF_PERIOD_HIGH;
                else
                    state    <= S_LOW;
                    half_per <= HALF_PERIOD_LOW;
                end if;
            end if;

            -- Genera la onda cuadrada a la frecuencia seleccionada
            if tone_cnt < half_per then
                tone_cnt <= tone_cnt + 1;
            else
                tone_cnt <= 0;
                audio_sig <= not audio_sig;
            end if;
        end if;
        end if;
    end process;

    AUDIO_OUT <= audio_sig;

end Behavioral;