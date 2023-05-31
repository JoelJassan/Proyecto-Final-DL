-- PROYECTO LCD CON STRING.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_String is
	generic(			    --"                |16 |20       |30       |40       |50   |56 |60
		cadena0 :	string := "Joel Jassan    -                        41.870.435     -"
	);
	port
	(
		clk,reset	: in  std_logic:='0';
		lcd_data	: out std_logic_vector (7 downto 0);
		lcd_enable, lcd_rw, lcd_rs : out std_logic		
	);
end LCD_String;

architecture a_sw_lcd of LCD_String is

	signal clks: std_logic;

begin
	
	conta1: entity work.conta generic map (0,49999 )port map( clk, '0','1', clks , open); --DIVISOR PARA LCD
	
	ins2: entity work.escribelcd_string generic map (cadena) port map (clks, reset, lcd_data ,lcd_enable,lcd_rw,lcd_rs);

		
end a_sw_lcd;