-- VHDL file
--
-- Autor: Jassan, Joel
-- Date: (jun/2023)
-- 
-- Proyect Explanation:
--
--
-- Copyright 2023, Joel Jassan <joeljassan@hotmail.com>
-- All rights reserved.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_lectura is

    generic (
        nbits_rx       : integer := 9;
        cnt_max_rx     : integer := 325;
        data_lenght_rx : integer := 8; --la mef de tx y rx no estan preparadas para cambiar cantidad

        cnt_max : integer := 1000000
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx_port : in std_logic;

        --output ports
        lcd_data                   : out std_logic_vector (7 downto 0);
        lcd_enable, lcd_rw, lcd_rs : out std_logic;

        led_end  : out std_logic;
        buzzer   : out std_logic;
        digito_1 : out std_logic;

        led_1 : out std_logic;
        led_2 : out std_logic;
        led_3 : out std_logic;
        led_4 : out std_logic

    );

end entity;

architecture a_control_lectura of control_lectura is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------
    constant led_1_on     : string := "led 1 onDA";
    constant led_1_off    : string := "led 1 ofDA";
    constant led_2_on     : string := "led 2 onDA";
    constant led_2_off    : string := "led 2 ofDA";
    constant led_3_on     : string := "led 3 onDA";
    constant led_3_off    : string := "led 3 ofDA";
    constant led_4_on     : string := "led 4 onDA";
    constant led_4_off    : string := "led 4 ofDA";
    constant All_leds_On  : string := "AlledsOnDA";
    constant All_leds_Off : string := "AlledsOfDA";

    constant bits_final_trama : integer := 2;
    constant longitud_cadena  : integer := (led_1_on'length - bits_final_trama);

    ----- Signals ---------------------------------------------------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    -- procesamiento
    signal cadena_recibida : string (1 to (longitud_cadena + bits_final_trama));

    signal led_s     : std_logic := '1';
    signal led_end_s : std_logic := '1';

    -- display lcd

    -- contadores
    signal contador_fin_cadena : integer range 0 to cnt_max;
    signal caracter_cadena     : integer := (longitud_cadena + bits_final_trama);

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_port, rx_done, dato);

    lcd : entity work.LCD_String
        generic map(longitud_cadena + bits_final_trama)
        port map(clk, reset, cadena_recibida, lcd_data, lcd_enable, lcd_rw, lcd_rs);

    ----- Codigo ----------------------------------------------------------------------------------

    process (clk, reset)
    begin

        if reset = '0' then
            contador_fin_cadena <= 0;
            cadena_recibida     <= All_leds_Off;
            led_end_s           <= '1';

        elsif (rising_edge(clk)) then

            cadena_recibida (caracter_cadena) <= character'val(to_integer(unsigned(dato)));

            -- contador fin de cadena
            if rx_done = '1' then
                contador_fin_cadena <= 0;
                led_end_s           <= '1';
                buzzer              <= '1';
            elsif contador_fin_cadena < cnt_max then
                contador_fin_cadena <= contador_fin_cadena + 1;
                led_end_s           <= '1';
                buzzer              <= '1';
            else
                led_end_s <= '0';
                buzzer    <= '0';

            end if;
        end if;
    end process;

    --LED on/off
    process (cadena_recibida)
    begin

        if cadena_recibida (1 to longitud_cadena) = All_leds_Off (1 to longitud_cadena) then
            led_1 <= '1';
            led_2 <= '1';
            led_3 <= '1';
            led_4 <= '1';
            -- Apago Todos

        elsif cadena_recibida (1 to longitud_cadena) = All_leds_On (1 to longitud_cadena) then
            led_1 <= '0';
            led_2 <= '0';
            led_3 <= '0';
            led_4 <= '0';
            -- Enciendo Todos

        elsif cadena_recibida (1 to longitud_cadena) = led_1_on (1 to longitud_cadena) then
            led_1 <= '0';
        elsif cadena_recibida (1 to longitud_cadena) = led_1_off (1 to longitud_cadena) then
            led_1 <= '1';

        elsif cadena_recibida (1 to longitud_cadena) = led_2_on (1 to longitud_cadena) then
            led_2 <= '0';
        elsif cadena_recibida (1 to longitud_cadena) = led_2_off (1 to longitud_cadena) then
            led_2 <= '1';

        elsif cadena_recibida (1 to longitud_cadena) = led_3_on (1 to longitud_cadena) then
            led_3 <= '0';
        elsif cadena_recibida (1 to longitud_cadena) = led_3_off (1 to longitud_cadena) then
            led_3 <= '1';

        elsif cadena_recibida (1 to longitud_cadena) = led_4_on (1 to longitud_cadena) then
            led_4 <= '0';
        elsif cadena_recibida (1 to longitud_cadena) = led_4_off (1 to longitud_cadena) then
            led_4 <= '1';

        end if;
    end process;

    --contador longitud de cadena
    process (rx_done)
    begin

        if rx_done = '1' then -- debe estar con 1, porque falla en placa
            caracter_cadena <= caracter_cadena + 1;
            if (caracter_cadena >= (cadena_recibida'length)) then
                caracter_cadena <= 1;

            end if;
        end if;
    end process;

    -- Conexion de señales
    led_end  <= led_end_s;
    digito_1 <= '0';

end architecture;