library ieee;
use ieee.std_logic_1164.all;
entity antirrebote is

	generic (
		delay_count : integer := 100
	);

	port (
		clk      : in std_logic;
		enable   : in std_logic;
		tecla_in : in std_logic;

		tecla_out : out std_logic
	);

end antirrebote;

architecture antirrebote_a of antirrebote is

	signal tecla_prev : std_logic := '0';
	signal tecla_in_s : std_logic;
	signal cnt        : integer range 0 to delay_count;

begin
	process (clk)
		--variable cnt  : integer range 0 to delay_count;
		variable flag : bit := '0';
	begin

		if (rising_edge(clk)) then
			if (enable = '1') then

				--no leo las teclas hasta que flag = 0
				if flag = '1' then
					if (cnt /= delay_count) then
						cnt <= cnt + 1;
					else
						if (tecla_in_s xor tecla_prev) = '1' then
							tecla_prev <= tecla_in_s;
						else
						end if;

						cnt <= 0;
						flag := '0';

					end if;

					--if (tecla_in xor tecla_prev) = '1' then
					--	cnt        <= 0;
					--	tecla_prev <= tecla_in;
					--elsif cnt < delay_count then
					--	cnt <= cnt + 1;
					--else
					--	tecla_out <= tecla_prev;
					--
					--end if;

				elsif (tecla_in_s xor tecla_prev) = '1' then
					flag := '1';
				end if;
			end if;

		end if;

		tecla_in_s <= tecla_in;
		tecla_out  <= tecla_prev;

	end process;
end antirrebote_a;