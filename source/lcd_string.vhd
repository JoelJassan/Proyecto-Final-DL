-- PROYECTO LCD CON STRING.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_String is
    generic (
        longitud_cadena : integer := 10
    );

    port (
        clk, reset : in std_logic := '0';
        cadena     : in string (1 to longitud_cadena); -- aqui si debe ingresar "cadena"

        lcd_data                   : out std_logic_vector (7 downto 0);
        lcd_enable, lcd_rw, lcd_rs : out std_logic
    );
end LCD_String;

architecture a_sw_lcd of LCD_String is

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
    pantalla <= cadena;

end a_sw_lcd;