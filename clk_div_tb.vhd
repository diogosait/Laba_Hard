library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_div_tb is
end entity;

architecture sim of clk_div_tb is

    signal clock_in  : std_logic := '0';
    signal clock_out : std_logic;

begin

    -- DUT: clk_div
    dut: entity work.clk_div(rtl)
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
        
        for i in natural range 0 to 50 loop
            clock_in <= '0';
            wait for 5 ns;
            clock_in <= '1';
            wait for 5 ns;
            
        end loop;
        wait;
    end process;

end architecture;
