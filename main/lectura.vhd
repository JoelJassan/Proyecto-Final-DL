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

        rx_UART_port         : in std_logic;
        cadenas_iguales_test : out std_logic
        --output ports
        --dato_test : out std_logic_vector(data_lenght_rx - 1 downto 0)

    );

end entity;

architecture a_lectura of lectura is

    ----- Typedefs --------------------------------------------------------------------------------

    type t_arreglo is array (0 to cantidad_caracteres - 1) of character;

    ----- Constants -------------------------------------------------------------------------------

    constant texto_esperado : t_arreglo := ('H', 'O', 'L', 'A');

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    signal arreglo_recibido : t_arreglo;
    signal cadenas_iguales  : std_logic;

    signal cnt : integer := 0;

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_UART_port, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------
    --dato_test            <= dato;
    cadenas_iguales_test <= cadenas_iguales;

    -- Logica Estado Siguiente
    process (reset, rx_done)
    begin
        if (reset = '0') then
            cnt <= 0;

        elsif (rising_edge(rx_done)) then
            cnt                   <= cnt + 1;
            arreglo_recibido(cnt) <= character'val(to_integer(unsigned(dato)));
        end if;

    end process;

    -- Logica Salida
    process (cnt)
    begin
        if cnt = 0 then
            cadenas_iguales <= '0';

        elsif cnt = 4 then
            if (arreglo_recibido = texto_esperado) then
                cadenas_iguales <= '1';
            end if;
        end if;
    end process;

end architecture;