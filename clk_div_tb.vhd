library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_clock_1hz is
end entity;

architecture sim of tb_clock_1hz is

    signal clock_in  : std_logic := '0';
    signal clock_out : std_logic;

begin

    -- DUT: clock_1hz
    dut: entity work.clock_1hz(rtl)
        generic map (
            DIVISOR => 10   -- bem pequeno só pra simulação
        )
        port map (
            clock_in  => clock_in,
            clock_out => clock_out
        );

    -- Geração do clock de entrada (período 10 ns)
    clk_gen: process
    begin
        clock_in <= '0';
        wait for 5 ns;
        clock_in <= '1';
        wait for 5 ns;
    end process;

end architecture;
