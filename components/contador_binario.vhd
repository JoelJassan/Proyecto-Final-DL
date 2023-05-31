-- VHDL file
--
-- Autor: Joel Jassan
--
-- Modificacion: Ing. Gomez Lopez



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_binario is

	generic
	(
		nbits		: integer := 26;
		cnt_max		: integer := 50000000
	);

	port
	(
		clk		  	: in std_logic;
		reset	  	: in std_logic;
		
		clk_out 	: out std_logic;
		q		  	: out std_logic_vector (nbits-1 downto 0)
	);

end entity;

architecture contador_binario_a of contador_binario is
	signal clk_out_s : std_logic;
	signal q_s		 : std_logic_vector(nbits-1 downto 0);
begin

	process (clk,reset)
		variable   cnt	: integer range 0 to cnt_max;
	begin

		if reset = '0' then	cnt:=0;
		
		elsif (rising_edge(clk)) then 
		
			cnt := cnt + 1;
			
			if (cnt < cnt_max/2 ) then 
				clk_out_s <= '0';
				
			elsif  cnt < cnt_max then  
				clk_out_s <= '1';

			elsif  cnt = cnt_max  then  
				cnt:=0; 
				clk_out_s <= '0';
	
			end if;
			
		end if;

		
		q_s <= std_logic_vector(to_unsigned(cnt,q_s'length));

	end process;



	-- Logica de Salida
	clk_out <= clk_out_s;
	q <= q_s;

end architecture;
