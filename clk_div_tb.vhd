library ieee;
use ieee.std_logic_1164.all;

entity clk_div_tb is
end entity clk_div_tb;

architecture behavioral of clk_div_tb is
    -- Constantes
    constant CLOCK_50MHZ_PERIOD : time := 20 ns; -- Período do clock de 50 MHz (1/50MHz = 20ns)
    constant TEST_DURATION : time := 5 sec; -- Duração total da simulação

    -- Componente a ser testado
    component clk_div
        port (
            clock_50mhz : in std_logic;
            clock_1hz   : out std_logic
        );
    end component;

    -- Sinais para o DUT
    signal clock_50mhz_tb : std_logic := '0';
    signal clock_1hz_tb   : std_logic;

begin
    -- Instanciação do DUT
    uut: clk_div
        port map (
            clock_50mhz => clock_50mhz_tb,
            clock_1hz   => clock_1hz_tb
        );

    -- Geração do clock de 50 MHz
    clock_50mhz_gen: process
    begin
        loop
            clock_50mhz_tb <= '0';
            wait for CLOCK_50MHZ_PERIOD / 2;
            clock_50mhz_tb <= '1';
            wait for CLOCK_50MHZ_PERIOD / 2;
        end loop;
    end process;

    -- Processo de geração de estímulos
    stim_proc: process
    begin
        -- Espera por um tempo suficiente para observar algumas bordas do clock de 1 Hz
        wait for TEST_DURATION; 

        wait; -- Fim da simulação
    end process;

end architecture behavioral;
