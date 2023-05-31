-- VHDL file
--
-- Autor: Jassan, Joel
-- Date: (may/YYYY)
-- 
-- Proyect Explanation: Modulo de union entre el contador y la rx_mef de la ingeniera
--
--
-- Copyright 2023, Joel Jassan <joeljassan@hotmail.com>
-- All rights reserved.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rx_uart is

    generic (
        nbits       : integer := 9;
        cnt_max     : integer := 325;
        data_lenght : integer := 8 --la mef de tx y rx no estan preparadas para cambiar cantidad
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx : in std_logic;

        --output ports
        rx_done : out std_logic;
        dato    : out std_logic_vector (data_lenght - 1 downto 0)
    );

end entity;

architecture a_rx_uart of rx_uart is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------

    -- reloj (clk lento)
    signal clk_9600 : std_logic;

    -- mef uart

begin
    ----- Components ------------------------------------------------------------------------------

    clk9600 : entity work.contador_binario
        generic map(nbits, cnt_max)
        port map(clk, reset, clk_9600, open);

    receptor : entity work.rx_uart_mef
        port map(clk_9600, reset, rx, rx_done, dato);

    ----- Codigo ----------------------------------------------------------------------------------

    -- Logica Estado Siguiente

    -- Logica Salida

end architecture;