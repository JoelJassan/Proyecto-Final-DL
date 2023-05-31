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
        data_lenght_rx : integer := 8 --la mef de tx y rx no estan preparadas para cambiar cantidad
    );

    port (
        --input ports
        clk   : in std_logic;
        reset : in std_logic;

        rx_UART_port : in std_logic
        --output ports

    );

end entity;

architecture a_lectura of lectura is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------

    ----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------
    -- receptor uart
    signal rx_done : std_logic;
    signal dato    : std_logic_vector(data_lenght_rx - 1 downto 0);

    signal cadena : string (1 to 80);

begin
    ----- Components ------------------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx)
        port map(clk, reset, rx_UART_port, rx_done, dato);
    ----- Codigo ----------------------------------------------------------------------------------

    -- Logica Estado Siguiente
    process (rx_done)
        variable cnt : integer := 0;
    begin
        if (rising_edge(rx_done)) then
            cnt := cnt + 1;
        end if;
    end process;
    -- Logica Salida
end architecture;