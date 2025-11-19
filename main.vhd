library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_main is
end entity;

architecture sim of tb_main is

    signal clock         : std_logic := '0';
    signal reset         : std_logic := '0';
    signal input_s       : std_logic_vector(7 downto 0) := (others => '0');
    signal input_display : std_logic_vector(7 downto 0);
    signal trava1        : std_logic;
    signal display1      : std_logic_vector(7 downto 0);
    signal display2      : std_logic_vector(7 downto 0);

begin

    -- DUT: main
    dut: entity work.main(rtl)
        port map (
            clock         => clock,
            reset         => reset,
            input         => input_s,
            input_display => input_display,
            trava1        => trava1,
            display1      => display1,
            display2      => display2
        );

    -- clock "rápido" (20 ns de período) → dentro da main vira 1 Hz pelo clock_1hz
    clk_gen: process
    begin
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
    end process;

    stim: process
    begin
        -- Aplica reset
        reset <= '1';
        input_s <= (others => '0');
        wait for 40 ns;

        -- Tira reset -> começa contagem
        reset <= '0';
        wait for 200 ns;

        -- Tenta senha errada
        input_s <= std_logic_vector(to_unsigned(10, 8));
        wait for 200 ns;

        -- Tenta senha certa (64, de acordo com generic da trava na main)
        input_s <= std_logic_vector(to_unsigned(64, 8));
        wait for 300 ns;

        -- Troca pra uma senha errada de novo
        input_s <= std_logic_vector(to_unsigned(20, 8));
        wait for 200 ns;

        -- Fim da simulação
        wait;
    end process;

end architecture;
