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

        cnt_max : integer := 5000000
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx_port : in std_logic;

        --output ports
        led : out std_logic

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

    -- otros
    signal caracter_recibido : character;
    --signal cadena_recibida : string (1 to 17);
    signal led_signal : std_logic := '1';

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------

    process (clk, reset, rx_done, dato)
        variable cnt_fin_cadena : integer := 0;
    begin
        if (reset = '0') then
            caracter_recibido <= 'a';
            --cnt_fin_cadena := 0;

        elsif rx_done = '1' then
            --cnt_fin_cadena := 0;
            caracter_recibido <= character'val(to_integer(unsigned(dato)));

        elsif (rising_edge(clk)) then
            if cnt_fin_cadena > 100 then
                --cnt_fin_cadena := 10;
            end if;
        end if;
    end process;

    process (caracter_recibido)
    begin

        case caracter_recibido is
            when e_char =>
                led_signal <= '0';

            when a_char =>
                led_signal <= '1';

            when others =>

        end case;
    end process;

    -- Logica de salida
    led <= led_signal;

end architecture;