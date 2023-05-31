-- VHDL file
--
-- Autor: Jassan, Joel
-- Date: (May/2023)
-- 
-- Proyect Explanation: Testbench del receptor UART con ROM.
--
--
-- Copyright 2023, Joel Jassan <joeljassan@hotmail.com>
-- All rights reserved.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rx_uart_tb is
end entity;

architecture a_rx_uart_tb of rx_uart_tb is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------
    constant simulation_time : integer := 5000; --esto no funciona

    constant nbits       : integer := 9;
    constant cnt_max     : integer := 325;
    constant data_lenght : integer := 8;

    ----- Simulation ------------------------------------------------------------------------------

    ----- Signals (i: entrada, o:salida, s:señal intermedia) --------------------------------------
    signal clk_i, rst_i, enable_i : std_logic;

    --component inputs
    signal rx_i : std_logic;
    --component outputs
    signal rx_done_o : std_logic;
    signal dato_o    : std_logic_vector(7 downto 0);

begin
    ----- Component to validate -------------------------------------------------------------------
    receptor : entity work.rx_uart
        generic map(nbits, cnt_max, data_lenght)
        port map(clk_i, rst_i, rx_i, rx_done_o, dato_o);
    ----- Code ------------------------------------------------------------------------------------

    -- clock stimulus
    reloj : process
    begin
        clk_i <= '0';
        wait for 10 ns;
        clk_i <= '1';
        wait for 10 ns;
    end process;

    -- reset stimulus
    reset : process
    begin
        rst_i <= '0';
        wait for 80 ns;
        rst_i <= '1';
        wait;
    end process;

    -- enable stimulus
    enable : process
    begin
        enable_i <= '0';
        wait for 100 ns; --espera habilitacion del reset
        enable_i <= '1';
        wait;
    end process;

    -- component to validate stimulus ---------------------
    ejecucion : process
    begin
        rx_i <= '1';
        wait for 40 us;
        rx_i <= '0';
        wait for 160 us;
        rx_i <= '1';
        wait;
    end process;
    -------------------------------------------------------

    -- End of test
    stop : process
    begin
        wait;
        --wait for 5000 ns; --tiempo total de
        --std.env.stop;
    end process;

    -- Data Verify
    -- aqui irian los note, warning, etc.

end architecture;