library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
    port (
        clock_50mhz : in std_logic; -- Clock de entrada de 50 MHz
        clock_1hz   : out std_logic  -- Clock de saída de 1 Hz
    );
end entity clk_div;

architecture behavioral of clk_div is
    -- Constante para o valor máximo do contador (50,000,000 / 2 = 25,000,000)
    -- O contador deve ir de 0 até 24,999,999.
    constant MAX_COUNT : natural := 25000000 - 1;
    -- O contador precisa de 25 bits (2^24 = 16,777,216; 2^25 = 33,554,432)
    signal counter : unsigned(24 downto 0) := (others => '0');
    signal clk_out_s : std_logic := '0';

begin
    process(clock_50mhz)
    begin
        if rising_edge(clock_50mhz) then
            if counter = MAX_COUNT then
                counter <= (others => '0'); -- Reseta o contador
                clk_out_s <= not clk_out_s; -- Inverte o sinal de clock de saída (gera 1 Hz)
            else
                counter <= counter + 1; -- Incrementa o contador
            end if;
        end if;
    end process;

    clock_1hz <= clk_out_s;

end architecture behavioral;
