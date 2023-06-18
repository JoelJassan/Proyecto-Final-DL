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
    constant cadena_e : string := "on1";
    constant cadena_a : string := "of1";

    ----- Signals ---------------------------------------------------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    -- procesamiento
    signal caracter_recibido   : character;
    signal caracter_recibido_s : character;

    signal cadena_recibida   : string (1 to cadena_e'length);
    signal cadena_recibida_s : string (1 to cadena_e'length);

    signal led_s : std_logic := '1';
    --signal led_end_s : std_logic := '1';

    -- contadores
    --signal cnt_fin_cadena  : integer range 0 to cnt_max;
    signal caracter_cadena : integer := cadena_e'length;

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------

    process (clk, reset)
    begin

        if reset = '0' then
            cadena_recibida <= cadena_a;
        elsif (rising_edge(clk)) then
            cadena_recibida (caracter_cadena) <= character'val(to_integer(unsigned(dato)));
            --cadena_recibida <= cadena_recibida_s;
        end if;
    end process;

    --LED on/off
    process (cadena_recibida)
    begin
        if cadena_recibida = cadena_e then
            led_s <= '0';
        elsif cadena_recibida = cadena_a then
            led_s <= '1';
        else
        end if;
    end process;

    process (rx_done)
    begin

        if rx_done = '1' then --debe estar con 1, porque falla
            if (caracter_cadena < (cadena_recibida'length)) then
                caracter_cadena <= caracter_cadena + 1;
            else
                caracter_cadena <= 1;
                --cadena_recibida <= cadena_recibida_s;
            end if;
        end if;

        --cadena_recibida_s (caracter_cadena) <= character'val(to_integer(unsigned(dato)));

    end process;

    -- Conexion de señales
    led     <= led_s;
    led_end <= '1';--led_end_s;

end architecture;