-- VHDL file
--
-- Autor: Jassan, Joel
-- Date: (May/2023)
-- 
-- Proyect Explanation: Transmisor modulo UART con ROM. No me gusta esta implementacion
--
-- Copyright 2023, Joel Jassan <joeljassan@hotmail.com>
-- All rights reserved.
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tx_uart is

	generic (
		nbits       : integer := 13;
		cnt_max     : integer := 5209;
		data_lenght : integer := 8 --la mef de tx y rx no estan preparadas para cambiar cantidad
	);

	port (
		--input ports
		clk   : in std_logic;
		reset : in std_logic;

		send_port : in std_logic; -- se le indica al transmisor que envie "dato"
		data_port : in std_logic_vector (data_lenght - 1 downto 0);

		--output ports
		tx_port : out std_logic
	);
end entity;

architecture a_tx_uart of tx_uart is

	----- Typedefs --------------------------------------------------------------------------------

	----- Constants -------------------------------------------------------------------------------

	----- Signals (i: entrada, o:salida, s:señal intermedia)---------------------------------------

	-- Reloj
	signal clk_9600 : std_logic;

	-- Transmisor UART
	signal salida_tx : std_logic;

begin
	----- Components ------------------------------------------------------------------------------

	ut_9600 : entity work.contador_binario
		generic map(nbits, cnt_max) --(13, 5209)
		port map(clk, reset, clk_9600, open);

	ut_t_uart : entity work.tx_uart_mef
		port map(clk_9600, reset, send_port, data_port, salida_tx);

	----- Codigo ----------------------------------------------------------------------------------

	-- Logica de estado siguiente

	-- Logica de Salida
	tx_port <= salida_tx;

end architecture;