library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is    
    port (
        clock: in std_logic;                            -- clock (pode ser rápido, vai pro clock_1hz)
        reset: in std_logic;
        input: in std_logic_vector(7 downto 0);         -- chaves de "senha"
        input_display: out std_logic_vector(7 downto 0);-- só espelha o input
        trava1: out std_logic;                          -- 1 = travado, 0 = destravado
        display1 : out std_logic_vector(7 downto 0);    -- 7 seg (parte baixa do tempo)
        display2 : out std_logic_vector(7 downto 0)     -- 7 seg (parte alta do tempo)
    );
end entity;

architecture rtl of main is

    signal sec    : std_logic_vector(7 downto 0);
    signal high_4 : std_logic_vector(3 downto 0);
    signal low_4  : std_logic_vector(3 downto 0);
    signal clock1 : std_logic;

begin

    rego: entity work.clk_div(rtl)
        port map (
            clock_in  => clock,
            clock_out => clock1
        );

    pix : entity work.trava(rtl)
        generic map (
            senha              => 64,
            tempo_para_desarme => 30
        )
        port map (
            clock    => clock1,
            reset    => reset,
            input    => input,
            segundos => sec,
            trava1   => trava1
        );

    high_4 <= sec(7 downto 4);
    low_4  <= sec(3 downto 0);

    displayPIX1 : entity work.binto7seg(rtl)
        port map (
            input   => low_4,
            display => display1
        );

    displayPIX2 : entity work.binto7seg(rtl)
        port map (
            input   => high_4,
            display => display2
        );

    input_display <= input;

end architecture;
