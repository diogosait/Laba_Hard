library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binto7seg_tb is
end entity;

architecture sim of binto7seg_tb is

    signal input_s  : std_logic_vector(3 downto 0) := (others => '0');
    signal display  : std_logic_vector(7 downto 0);

begin

    dut: entity work.binto7seg(rtl)
        port map (
            input   => input_s,
            display => display
        );

    stim: process
    begin
        for i in 0 to 15 loop
            input_s <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;

        wait;
    end process;

end architecture;
