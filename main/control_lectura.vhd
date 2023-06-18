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

        cnt_max : integer := 50000000
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
    constant e_char : character := 'e';
    constant a_char : character := 'a';
    constant r_char : character := 'r';

    -- constant cadena_e : string := "Motor:ON       ;";
    -- constant cadena_a : string := "Motor:OFF      ;";

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    -- procesamiento
    signal caracter_recibido   : character;
    signal caracter_recibido_s : character;
    --signal cadena_recibida   : string (1 to 17);
    --signal cadena_recibida_s : string (1 to 17);
    signal led_s     : std_logic := '1';
    signal led_end_s : std_logic := '1';

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------

    -- Entradas
    process (rx_done, dato)
    begin
        if rx_done = '0' then
            caracter_recibido_s <= character'val(to_integer(unsigned(dato)));
        end if;
    end process;

    -- Logica de salida
    process (clk, reset)
        variable cnt_fin_cadena : integer range 0 to cnt_max;
    begin

        if reset = '0' then
            cnt_fin_cadena := 0;
            caracter_recibido <= 'a';

        elsif (rising_edge(clk)) then

            caracter_recibido <= caracter_recibido_s;

            -- LED on/off
            if caracter_recibido = e_char then
                led_s <= '0';
            elsif caracter_recibido = a_char then
                led_s <= '1';
            end if;

            -- Fin cadena
            if rx_done = '1' then
                cnt_fin_cadena := 0;

            elsif cnt_fin_cadena < cnt_max then
                cnt_fin_cadena := cnt_fin_cadena + 1;
                led_end_s <= '1';

            else
                led_end_s <= '0';
            end if;

        end if;

    end process;

    led     <= led_s;
    led_end <= led_end_s;

end architecture;