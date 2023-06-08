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

        cantidad_caracteres : integer := 4
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx_UART_port : in std_logic;
        --output ports
        led          : out std_logic;
        tx_UART_port : out std_logic

    );

end entity;

architecture a_control_lectura of control_lectura is

    ----- Typedefs --------------------------------------------------------------------------------
    type data_action is (a, e, r, aux);
    type display_refresh is (carga_char, rst0, rst1, reposo);
    ----- Constants -------------------------------------------------------------------------------
    constant e_char : character := 'e';
    constant a_char : character := 'a';
    constant r_char : character := 'r';

    constant cadena_e : string := "Motor:ON   ;";
    constant cadena_a : string := "Motor:OFF  ;";

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    --otros
    signal caracter_recibido : character;
    signal led_signal : std_logic := '1';

    signal refresh : display_refresh;

    -- test
    signal cadena     : string (1 to 12);

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_UART_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------
    led <= led_signal;

    -- Logica Estado Siguiente
    process (reset, rx_done, dato)
    begin
        if (reset = '0') then
            caracter_recibido <= 'a';

        elsif rx_done = '1' then
            caracter_recibido <= character'val(to_integer(unsigned(dato)));

        end if;
    end process;

    process (caracter_recibido)
    begin

        case caracter_recibido is
            when e_char =>
                led_signal <= '0';
                cadena     <= cadena_e;

            when a_char =>
                led_signal <= '1';
                cadena     <= cadena_a;

            when r_char => --aqui activaria un flag para que transmita
            when others =>
        end case;
    end process;
end architecture;