library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div is
    generic (
        DIVISOR : natural := 50_000_000  -- ajuste conforme o clock de entrada
    );
    port (
        clock_in  : in  std_logic;
        clock_out : out std_logic
    );
end entity;

architecture rtl of clk_div is
    signal count   : unsigned(31 downto 0) := (others => '0');
    signal clk_reg : std_logic := '0';
begin

    process(clock_in)
    begin
        if rising_edge(clock_in) then
            if count = to_unsigned(DIVISOR/2 - 1, count'length) then
                count   <= (others => '0');
                clk_reg <= not clk_reg;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clock_out <= clk_reg;

end architecture;
