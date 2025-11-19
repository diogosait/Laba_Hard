library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Para operações com unsigned/signed e conversão

entity trava is
    generic (
        senha: natural range 0 to 255; -- Número usado como senha para destravar
        tempo_para_desarme: natural range 0 to 255 -- Em segundos
    );
    port (
        clock: in std_logic; -- Entrada de clock 1hz para contagem do tempo
        reset: in std_logic; -- Reset do tempo
        input: in std_logic_vector(7 downto 0); -- Chaves para destravar
        segundos: out std_logic_vector(7 downto 0); -- Tempo para desbloqueio
        trava: out std_logic -- Sinal de led: '1' para travado, '0' para destravado
    );
end entity trava;

architecture behavioral of trava is
    -- Sinal interno para o contador de tempo
    signal contador_tempo : unsigned(7 downto 0) := (others => '0');
    -- Sinal interno para o estado da trava
    signal trava_s : std_logic := '1'; -- '1' = travado, '0' = destravado
    -- Sinal interno para verificar se a senha foi acertada
    signal senha_correta : boolean := false;

    -- Constante para a senha em formato unsigned
    constant SENHA_UNSIGNED : unsigned(7 downto 0) := to_unsigned(senha, 8);
    -- Constante para o tempo de desarme em formato unsigned
    constant TEMPO_DESARME_UNSIGNED : unsigned(7 downto 0) := to_unsigned(tempo_para_desarme, 8);

begin
    -- Processo sequencial para o controle da trava e do contador de tempo
    process(clock, reset)
    begin
        if reset = '1' then
            -- Reset síncrono (ou assíncrono, dependendo da interpretação, mas o requisito é "Ao ter o sinal reset ligado (reset = 1)")
            -- 1. O contador de tempo deve ser definido com tempo_para_desarme;
            contador_tempo <= TEMPO_DESARME_UNSIGNED;
            -- 2. O sinal de saída trava deve ser definido como 1 (bloqueado);
            trava_s <= '1';
            senha_correta <= false;

        elsif rising_edge(clock) then
            -- Ao ter o sinal reset desligado (reset = 0)
            
            -- 1. O contador de tempo deve decrementar 1 unidade por segundo até chegar em 0;
            -- 2. O sinal de saída trava deve ser definido como 1 (bloqueado);
            
            -- Lógica de verificação da senha
            if input = std_logic_vector(SENHA_UNSIGNED) then
                -- Se input = senha:
                -- 1. então sinal de saída trava deve ser definido como 0 (desbloqueado) e o contador de tempo deve parar de decrementar;
                trava_s <= '0';
                senha_correta <= true;
            else
                -- senão sinal de saída trava deve ser definido como 1 (bloqueado) e o contador de tempo deve voltar a decrementar;
                trava_s <= '1';
                senha_correta <= false;
            end if;
            
            -- Lógica de decremento do contador
            if senha_correta = false and contador_tempo > 0 then
                contador_tempo <= contador_tempo - 1;
            end if;
            
            -- Lógica de inicialização (Ao ser ligada: 1. A entidade deve ser automaticamente resetada;)
            -- Isso é geralmente tratado por um power-on reset (POR) externo ou um valor inicial no sinal.
            -- O reset='1' no início do processo já cobre o requisito de inicialização.
            
        end if;
    end process;

    -- Saídas
    trava <= trava_s;
    segundos <= std_logic_vector(contador_tempo);

end architecture behavioral;
