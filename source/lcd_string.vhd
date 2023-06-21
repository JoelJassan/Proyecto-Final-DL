-- PROYECTO LCD CON STRING.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_String is
    generic (
        cantidad_de_leds : integer := 4
    );

    port (
        clk, reset : in std_logic := '0';
        leds_array : in std_logic_vector(cantidad_de_leds - 1 downto 0);

        lcd_data                   : out std_logic_vector (7 downto 0);
        lcd_enable, lcd_rw, lcd_rs : out std_logic
    );
end LCD_String;

architecture a_sw_lcd of LCD_String is

    constant longitud_cadena : integer := 11;

    signal clks     : std_logic;
    signal pantalla : string (1 to longitud_cadena);
begin

    conta1 : entity work.conta
        generic map(0, 199999)
        port map(clk, reset, '1', clks, open); --DIVISOR PARA LCD

    ins2 : entity work.escribelcd_string
        generic map(longitud_cadena)
        port map(clks, reset, pantalla, lcd_data, lcd_enable, lcd_rw, lcd_rs); -- aqui se tiene que armar una mef para la pantalla

    -- MODIFICACION JOEL

    -- esto equivale a una mef futura
    process (leds_array)
    begin
        case leds_array is

            when "1111" => pantalla <= "All Leds Of";
            when "0000" => pantalla <= "All Leds On";
            when others => pantalla <= "NNNNNNNNNNN";

        end case;
    end process;
end a_sw_lcd;