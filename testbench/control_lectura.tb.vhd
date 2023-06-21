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

entity control_lectura_tb is
end entity;

architecture a_control_lectura_tb of control_lectura_tb is

    ----- Typedefs --------------------------------------------------------------------------------

    ----- Constants -------------------------------------------------------------------------------

    constant nbits_rx       : integer := 9;
    constant cnt_max_rx     : integer := 325;
    constant data_lenght_rx : integer := 8; --la mef de tx y rx no estan preparadas para cambiar cantidad
    constant cnt_max        : integer := 100000;
    ----- Simulation ------------------------------------------------------------------------------

    constant simulation_time : time := 50 ms;

    constant clk_period      : time := 10 ns;
    constant reset_off_time  : time := 80 ns;
    constant enable_off_time : time := 100 ns;

    constant tiempo_de_pulso : time := 103.958 us;

    ----- Signals (i: entrada, o:salida, s:señal intermedia) --------------------------------------

    signal clk_i, rst_i, enable_i : std_logic;

    --component inputs
    signal rx_port : std_logic;

    --component outputs
    signal led_end : std_logic;

    signal lcd_data                   : std_logic_vector (7 downto 0);
    signal lcd_enable, lcd_rw, lcd_rs : std_logic;
    signal buzzer, digito_1           : std_logic;
    signal led_1, led_2, led_3, led_4 : std_logic;
begin
    ----- Component to validate -------------------------------------------------------------------
    leer : entity work.control_lectura
        generic map(nbits_rx, cnt_max_rx, data_lenght_rx, cnt_max)
        port map(clk_i, rst_i, rx_port, lcd_data, lcd_enable, lcd_rw, lcd_rs, led_end, buzzer, digito_1, led_1, led_2, led_3, led_4);
    ----- Code ------------------------------------------------------------------------------------

    -- clock stimulus
    reloj : process
    begin
        clk_i <= '0';
        wait for clk_period;
        clk_i <= '1';
        wait for clk_period;
    end process;

    -- reset stimulus
    reset : process
    begin
        rst_i <= '0';
        wait for reset_off_time;
        rst_i <= '1';
        wait for 4 ms;
        --rst_i <= '0';
        wait;
    end process;

    -- enable stimulus
    enable : process
    begin
        wait for enable_off_time;
        enable_i <= '1';
        wait;
    end process;

    -- component to validate stimulus
    --
    --
    ejecucion : process
        variable start_time   : time;
        variable current_time : time;

        variable data : std_logic_vector (7 downto 0) := "11111111";
    begin
        start_time := now; --obtengo tiempo de inicio
        --
        --
        --
        --- INICIO DE encendido

        -- dato 1
        data := x"6C";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 2
        data := x"65";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 3
        data := x"64";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 4
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 5
        data := x"31";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 6
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 7
        data := x"6F";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 8
        data := x"6E";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- retorno de carry
        data := x"0D";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- avance de linea
        data := x"0A";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        wait;

        current_time := now; --obtengo tiempo actual
        report "Tiempo transcurrido: " & time'image(current_time - start_time);
        while now < 9 ms loop
            wait for 1 ns;
        end loop; -- espero hasta 9 ms

        --
        --
        --
        --- INICIO DE apagado

        -- dato 1
        data := x"6C";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 2
        data := x"65";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 3
        data := x"64";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 4
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 5
        data := x"31";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- retorno de carry
        data := x"0D";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- avance de linea
        data := x"0A";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        current_time := now; --obtengo tiempo actual
        report "Tiempo transcurrido: " & time'image(current_time - start_time);
        while now < 18 ms loop
            wait for 1 ns;
        end loop;

        -- dato 1
        data := x"6C";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 2
        data := x"65";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 3
        data := x"64";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 4
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 5
        data := x"31";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- retorno de carry
        data := x"0D";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- avance de linea
        data := x"0A";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        current_time := now; --obtengo tiempo actual
        report "Tiempo transcurrido: " & time'image(current_time - start_time);
        while now < 27 ms loop
            wait for 1 ns;
        end loop;

        -- dato 1
        data := x"6C";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 2
        data := x"65";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 3
        data := x"64";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 4
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 5
        data := x"31";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- retorno de carry
        data := x"0D";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- avance de linea
        data := x"0A";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        current_time := now; --obtengo tiempo actual
        report "Tiempo transcurrido: " & time'image(current_time - start_time);
        while now < 36 ms loop
            wait for 1 ns;
        end loop;

        -- dato 1
        data := x"6C";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 2
        data := x"65";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 3
        data := x"64";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 4
        data := x"20";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- dato 5
        data := x"31";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- retorno de carry
        data := x"0D";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        -- avance de linea
        data := x"0A";
        rx_port <= '0'; --start
        wait for tiempo_de_pulso;
        for i in 0 to 7 loop
            rx_port <= data(i);
            wait for tiempo_de_pulso;
        end loop;
        rx_port <= '1'; --end
        wait for tiempo_de_pulso;

        wait;

    end process;
    --
    --
    --

    -- End of test
    stop : process
    begin
        wait for simulation_time; --tiempo total de
        report "End of Simulation!";
        std.env.stop;
    end process;

    -- Data Verify
    -- aqui irian los note, warning, etc.

end architecture;