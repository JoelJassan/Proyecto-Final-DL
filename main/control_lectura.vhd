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
        led     : out std_logic;
        led_end : out std_logic

    );

end entity;

architecture a_control_lectura of control_lectura is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------
    constant cadena_e : string := "encendiDA"; -- DA lo manda la aplicacion
    constant cadena_a : string := "apagadoDA"; -- DA lo manda la aplicacion
    constant led_1    : string := "led 1DA";
    constant led_2    : string := "led 2DA";
    constant led_3    : string := "led 3DA";
    constant led_4    : string := "led 4DA";

    constant bits_final_trama : integer := 2;
    --constant longitud_cadena  : integer := cadena_e'length - bits_final_trama;
    constant longitud_cadena : integer := led_1'length - bits_final_trama;

    ----- Signals ---------------------------------------------------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    -- procesamiento
    signal cadena_recibida : string (1 to longitud_cadena + bits_final_trama);

    signal led_s     : std_logic := '1';
    signal led_end_s : std_logic := '1';

    -- contadores
    signal contador_fin_cadena : integer range 0 to cnt_max;
    signal caracter_cadena     : integer := longitud_cadena + bits_final_trama;

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------

    process (clk, reset)
    begin

        if reset = '0' then
            contador_fin_cadena <= 0;
            cadena_recibida     <= cadena_a;
            led_end_s           <= '1';

        elsif (rising_edge(clk)) then

            cadena_recibida (caracter_cadena) <= character'val(to_integer(unsigned(dato)));

            -- contador fin de cadena
            if rx_done = '1' then
                contador_fin_cadena <= 0;
                led_end_s           <= '1';
            elsif contador_fin_cadena < cnt_max then
                contador_fin_cadena <= contador_fin_cadena + 1;
                led_end_s           <= '1';
            else
                led_end_s <= '0';

            end if;

        end if;

    end process;

    --LED on/off
    process (cadena_recibida)
    begin

        if cadena_recibida (1 to longitud_cadena) = led_1 (1 to longitud_cadena) then
            led_s <= not led_s;
            --elsif cadena_recibida (1 to longitud_cadena) = cadena_a (1 to longitud_cadena) then
            --    led_s <= '1';
        else
        end if;

        --if cadena_recibida (1 to longitud_cadena) = cadena_e (1 to longitud_cadena) then
        --    led_s <= '0';
        --elsif cadena_recibida (1 to longitud_cadena) = cadena_a (1 to longitud_cadena) then
        --    led_s <= '1';
        --else
        --end if;
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
    led     <= led_s;
    led_end <= led_end_s;

end architecture;