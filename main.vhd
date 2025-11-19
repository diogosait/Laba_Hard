-- main.vhd
library ieee;
use ieee.std_logic_1164.all;

entity main is
    port (
        CLOCK_50 : in  std_logic;
        SW       : in  std_logic_vector(9 downto 0);
        LEDR     : out std_logic_vector(9 downto 0);
        HEX3     : out std_logic_vector(7 downto 0);
        HEX2     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of main is
    signal clk_1hz    : std_logic;
    signal segundos_s : std_logic_vector(7 downto 0);
    signal trava_s    : std_logic;

begin
    ---------------------------------------------------------------------
    -- Espelhar os switches nos LEDs para visualização
    ---------------------------------------------------------------------
    LEDR(7 downto 0) <= SW(7 downto 0);  -- senha nas chaves
    LEDR(8)          <= '0';             -- não usado
    LEDR(9)          <= trava_s;         -- LED de trava (1=travado)

    ---------------------------------------------------------------------
    -- Divisor de clock 50 MHz -> 1 Hz
    ---------------------------------------------------------------------
    clk_div_inst : entity work.clk_div(behavioral)
        generic map (
            DIVISOR => 50_000_000
        )
        port map (
            clk_in  => CLOCK_50,
            reset   => SW(9),        -- mesmo reset da trava
            clk_out => clk_1hz
        );

    ---------------------------------------------------------------------
    -- Instância da trava
    ---------------------------------------------------------------------
    trava_inst : entity work.trava(behavioral)
        generic map (
            senha              => 42,  -- exemplo de senha (decimal)
            tempo_para_desarme => 30   -- tempo em segundos
        )
        port map (
            clock    => clk_1hz,
            reset    => SW(9),          -- SW9 = reset
            input    => SW(7 downto 0), -- SW7..0 = entrada de senha
            segundos => segundos_s,
            trava    => trava_s
        );

    ---------------------------------------------------------------------
    -- Displays HEX3 e HEX2 mostrando o tempo restante em Hex
    ---------------------------------------------------------------------
    -- parte alta dos segundos
    binto7seg_high : entity work.binto7seg(behavioral)
        port map (
            input   => segundos_s(7 downto 4),
            display => HEX3
        );

    -- parte baixa dos segundos
    binto7seg_low : entity work.binto7seg(behavioral)
        port map (
            input   => segundos_s(3 downto 0),
            display => HEX2
        );

end architecture;
