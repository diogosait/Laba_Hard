library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_trava is
end entity;

architecture sim of tb_trava is

    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';
    signal input_s  : std_logic_vector(7 downto 0) := (others => '0');
    signal segundos : std_logic_vector(7 downto 0);
    signal trava1   : std_logic;

begin

    -- DUT: trava
    dut: entity work.trava(rtl)
        generic map (
            senha              => 64,  -- 0x40
            tempo_para_desarme => 10   -- 10 "segundos" pra simulação
        )
        port map (
            clock    => clock,
            reset    => reset,
            input    => input_s,
            segundos => segundos,
            trava1   => trava1
        );

    -- clock 1 Hz de mentirinha (período 20 ns só pra sim)
    clk_gen: process
    begin
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
    end process;

    stim: process
    begin
        -- início: reset ativo
        reset <= '1';
        input_s <= (others => '0');
        wait for 40 ns;

        -- tira reset → começa contagem
        reset <= '0';
        wait for 200 ns;

        -- tenta senha errada
        input_s <= "00001010"; -- 10
        wait for 100 ns;

        -- tenta senha certa (64)
        input_s <= std_logic_vector(to_unsigned(64, 8));
        wait for 200 ns;

        -- mexe de novo pra senha errada
        input_s <= std_logic_vector(to_unsigned(20, 8));
        wait for 100 ns;

        -- fim da simulação
        wait;
    end process;

end architecture;
