-- VHDL file
--
-- Autor: Jassan, Joel
-- Date: (May/2023)
-- 
-- Proyect Explanation: Testbench del transmisor UART
--
--
-- Copyright 2023, Joel Jassan <joeljassan@hotmail.com>
-- All rights reserved.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tx_uart_tb is
end entity;

architecture a_tx_uart_tb of tx_uart_tb is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------
    constant nbits       : integer := 13;
    constant cnt_max     : integer := 5209;
    constant data_lenght : integer := 8;

    ----- Simulation ------------------------------------------------------------------------------
    constant simulation_time : integer := 5000; --esto no funciona

    ----- Signals (i: entrada, o:salida, s:señal intermedia) --------------------------------------
    signal clk_i, rst_i, enable_i : std_logic;

    --component inputs
    --component outputs
    signal dato_i : std_logic_vector(7 downto 0);
    signal send_i : std_logic;
    signal tx_o   : std_logic;

begin
    ----- Component to validate -------------------------------------------------------------------
    transmisor : entity work.tx_uart
        generic map(nbits, cnt_max, data_lenght)
        port map(clk_i, rst_i, send_i, dato_i, tx_o);
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
        dato_i <= x"F0";
        wait for 800 ns;
        send_i <= '1';
        wait for 55 us;
        send_i <= '0';
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