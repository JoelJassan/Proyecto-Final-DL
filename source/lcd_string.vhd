-- PROYECTO LCD CON STRING.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_String is
    generic (
        cadena_e : string := "ON   ;";
        cadena_a : string := "OFF  ;"
    );
    port (
        clk, reset : in std_logic := '0';
        led_signal : in std_logic;

        lcd_data                   : out std_logic_vector (7 downto 0);
        lcd_enable, lcd_rw, lcd_rs : out std_logic
    );
end LCD_String;

architecture a_sw_lcd of LCD_String is

    signal clks : std_logic;

begin

    conta1 : entity work.conta
        generic map(0, 199999)
        port map(clk, reset, '1', clks, open); --DIVISOR PARA LCD

    ins2 : entity work.escribelcd_string
        generic map(cadena_e, cadena_a)
        port map(clks, reset, led_signal, lcd_data, lcd_enable, lcd_rw, lcd_rs);

end a_sw_lcd;