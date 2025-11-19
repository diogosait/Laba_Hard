library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trava_tb is
end entity trava_tb;

architecture behavioral of trava_tb is
    -- Constantes para o Testbench
    constant CLOCK_PERIOD : time := 10 ns; -- Período do clock de 50 MHz (para simulação)
    constant SENHA_TESTE : natural := 42; -- Senha para o teste
    constant TEMPO_TESTE : natural := 5; -- Tempo para desarme (em segundos)

    -- Componente a ser testado
    component trava
        generic (
            senha: natural range 0 to 255;
            tempo_para_desarme: natural range 0 to 255
        );
        port (
            clock: in std_logic;
            reset: in std_logic;
            input: in std_logic_vector(7 downto 0);
            segundos: out std_logic_vector(7 downto 0);
            trava: out std_logic
        );
    end component;

    -- Sinais para o DUT (Device Under Test)
    signal clock_tb: std_logic := '0';
    signal reset_tb: std_logic := '1'; -- Começa em reset
    signal input_tb: std_logic_vector(7 downto 0) := (others => '0');
    signal segundos_tb: std_logic_vector(7 downto 0);
    signal trava_tb: std_logic;

    -- Sinal interno para simular o clock de 1 Hz (para a trava)
    signal clk_1hz_tb : std_logic := '0';
    
    -- Função para simular o divisor de clock de 50 MHz para 1 Hz
    -- O clock de 1 Hz é gerado a cada 50,000,000 ciclos do clock de 50 MHz
    -- Em simulação, vamos simplificar para um período de 1 segundo.
    -- O componente trava espera um clock de 1 Hz.
    
begin
    -- Instanciação do DUT
    uut: trava
        generic map (
            senha => SENHA_TESTE,
            tempo_para_desarme => TEMPO_TESTE
        )
        port map (
            clock => clk_1hz_tb, -- Usamos o clock de 1 Hz simulado
            reset => reset_tb,
            input => input_tb,
            segundos => segundos_tb,
            trava => trava_tb
        );

    -- Geração do clock de 1 Hz simulado (período de 1 segundo)
    clk_1hz_gen: process
    begin
        loop
            clk_1hz_tb <= '0';
            wait for 500 ms;
            clk_1hz_tb <= '1';
            wait for 500 ms;
        end loop;
    end process;

    -- Processo de geração de estímulos
    stim_proc: process
    begin
        -- 1. Início: Reset ativo (reset = '1')
        -- Espera-se: contador = TEMPO_TESTE (5), trava = '1'
        reset_tb <= '1';
        input_tb <= (others => '0');
        wait for 2 * CLOCK_PERIOD; -- Tempo para estabilizar

        -- 2. Desativa o Reset (reset = '0')
        -- Espera-se: contador começa a decrementar a cada 1 segundo, trava = '1'
        reset_tb <= '0';
        wait for 100 ms; -- Pequeno atraso para garantir a borda de descida do reset

        -- 3. Espera 2 segundos (contador deve ir para 3)
        wait for 2 sec; 

        -- 4. Tenta senha errada (input != SENHA_TESTE)
        -- Espera-se: trava = '1', contador continua a decrementar
        input_tb <= std_logic_vector(to_unsigned(SENHA_TESTE + 1, 8));
        wait for 1 sec; -- Contador deve ir para 2

        -- 5. Tenta senha correta (input = SENHA_TESTE)
        -- Espera-se: trava = '0', contador para de decrementar (deve permanecer em 2)
        input_tb <= std_logic_vector(to_unsigned(SENHA_TESTE, 8));
        wait for 3 sec; -- Deve permanecer destravado e contador parado

        -- 6. Tira a senha correta (input != SENHA_TESTE)
        -- Espera-se: trava = '1', contador volta a decrementar (deve ir para 1, 0)
        input_tb <= (others => '0');
        wait for 1 sec; -- Contador deve ir para 1
        wait for 1 sec; -- Contador deve ir para 0

        -- 7. Contador chegou a zero
        -- Espera-se: trava = '1', contador = 0, não decrementa mais
        wait for 2 sec;
        
        -- 8. Tenta senha correta com contador em zero
        -- Espera-se: trava = '1' (bloqueado, pois contador = 0)
        input_tb <= std_logic_vector(to_unsigned(SENHA_TESTE, 8));
        wait for 1 sec;
        
        -- 9. Novo Reset
        -- Espera-se: contador = TEMPO_TESTE (5), trava = '1'
        reset_tb <= '1';
        wait for 2 * CLOCK_PERIOD;
        reset_tb <= '0';
        wait for 100 ms;
        
        -- 10. Espera o tempo acabar
        wait for TEMPO_TESTE sec;
        
        wait; -- Fim da simulação
    end process;

end architecture behavioral;
