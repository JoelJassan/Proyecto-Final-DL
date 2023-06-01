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

entity lectura is

    generic (
        nbits_rx       : integer := 9;
        cnt_max_rx     : integer := 325;
        data_lenght_rx : integer := 8; --la mef de tx y rx no estan preparadas para cambiar cantidad

        cantidad_caracteres : integer := 4
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx_UART_port : in std_logic;
        led          : out std_logic;
        --output ports
        lcd_data                   : out std_logic_vector (7 downto 0);
        lcd_enable, lcd_rw, lcd_rs : out std_logic
        --dato_test : out std_logic_vector(data_lenght_rx - 1 downto 0)

    );

end entity;

architecture a_lectura of lectura is

    ----- Typedefs --------------------------------------------------------------------------------
    type data_action is (a, e, r, aux);
    type display_refresh is (carga_char, rst0, rst1, reposo);
    ----- Constants -------------------------------------------------------------------------------
    constant e_char : character := 'e';
    constant a_char : character := 'a';
    constant r_char : character := 'r';

    constant cadena_e : string := "ON   ;";
    constant cadena_a : string := "OFF  ;";

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    --otros
    signal caracter_recibido : character;
    signal caracter          : character;

    signal led_signal : std_logic := '1';

    --signal dato_mef          : data_action;
    signal refresh : display_refresh;

    -- auxiliares
    signal refresh_reset   : std_logic;
    signal clk_auxiliar    : std_logic;
    signal cadena_anterior : string (1 to 6);
    signal led_anterior    : std_logic;
    -- test
    signal slv_signal : std_logic_vector(data_lenght_rx - 1 downto 0);
    signal cadena     : string (1 to 6);

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_UART_port, rx_done, dato);

    display : entity work.LCD_String
        generic map(cadena_e, cadena_a)
        port map(clk, reset, led_signal, lcd_data, lcd_enable, lcd_rw, lcd_rs);

    --contador_auxiliar : entity work.conta
    --    generic map(0, 50000) --necesito un clk lento
    --    port map(clk, reset, '1', clk_auxiliar, open);
    ----- Codigo ----------------------------------------------------------------------------------
    led <= led_signal;

    -- Logica Estado Siguiente
    process (reset, rx_done, dato)
    begin
        if (reset = '0') then
            caracter_recibido <= 'e';

        elsif rx_done = '1' then
            caracter_recibido <= character'val(to_integer(unsigned(dato)));
            ----------------------------------------------- tb
            --slv_signal <= std_logic_vector(to_unsigned(character'pos(caracter_recibido), slv_signal'length));
            ----------------------------------------------- tb
        end if;
    end process;

    process (caracter_recibido)
    begin
        case caracter_recibido is
            when e_char =>
                led_signal <= '0';
            when a_char =>
                led_signal <= '1';
            when r_char => --aqui activaria un flag para que transmita
            when others =>
        end case;
    end process;

    --process (clk_auxiliar)
    --begin
    --    case refresh is
    --        when reposo =>
    --            if cadena_anterior = cadena then
    --                refresh <= reposo;
    --            else
    --                refresh <= carga_char;
    --            end if;
    --        when carga_char =>
    --            refresh         <= rst0;
    --            cadena_anterior <= cadena;
    --        when rst0 =>
    --            refresh       <= rst1;
    --            refresh_reset <= '0';
    --        when rst1 =>
    --            refresh       <= reposo;
    --            refresh_reset <= '1';
    --when others     => refresh     <= reposo;
    --end case;
    --end process;
end architecture;