library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    generic (
        SENHA_PADRAO: natural range 0 to 255 := 123; -- Senha padrão para a trava
        TEMPO_PADRAO: natural range 0 to 255 := 10 -- Tempo padrão para desarme (em segundos)
    );
    port (
        -- Sinais da FPGA DE0
        CLOCK_50 : in std_logic; -- Clock de 50 MHz da placa
        SW       : in std_logic_vector(9 downto 0); -- Chaves (SW9 para reset, SW7-SW0 para input)
        LEDR     : out std_logic_vector(9 downto 0); -- LEDs Vermelhos (LEDR9 para trava, LEDR7-LEDR0 para input)
        HEX3     : out std_logic_vector(7 downto 0); -- Display de 7 segmentos (dígito mais significativo)
        HEX2     : out std_logic_vector(7 downto 0)  -- Display de 7 segmentos (dígito menos significativo)
    );
end entity main;

architecture structural of main is
    -- Componentes
    component clk_div
        port (
            clock_50mhz : in std_logic;
            clock_1hz   : out std_logic
        );
    end component;

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

    component binto7seg
        port (
            input: in std_logic_vector(3 downto 0);
            display: out std_logic_vector(7 downto 0)
        );
    end component;

    -- Sinais internos
    signal clk_1hz_s : std_logic;
    signal segundos_s : std_logic_vector(7 downto 0);
    signal trava_s : std_logic;
    
    -- Sinais para os dígitos do display de 7 segmentos
    signal digito_msb : std_logic_vector(3 downto 0); -- Dígito mais significativo (dezena)
    signal digito_lsb : std_logic_vector(3 downto 0); -- Dígito menos significativo (unidade)

begin
    -- Mapeamento de pinos da FPGA
    -- SW9 -> reset
    -- SW7-SW0 -> input da trava
    -- LEDR9 -> trava
    -- LEDR7-LEDR0 -> visualização do input
    
    -- Instanciação do divisor de clock
    U_CLK_DIV : clk_div
        port map (
            clock_50mhz => CLOCK_50,
            clock_1hz   => clk_1hz_s
        );

    -- Instanciação da trava
    U_TRAVA : trava
        generic map (
            senha => SENHA_PADRAO,
            tempo_para_desarme => TEMPO_PADRAO
        )
        port map (
            clock    => clk_1hz_s, -- Clock de 1 Hz
            reset    => SW(9),     -- SW9 para reset
            input    => SW(7 downto 0), -- SW7-SW0 para input
            segundos => segundos_s, -- Saída do contador de segundos
            trava    => trava_s     -- Saída da trava
        );
        
    -- Visualização do input nos LEDs
    LEDR(7 downto 0) <= SW(7 downto 0);
    
    -- Visualização do estado da trava no LEDR9
    LEDR(9) <= trava_s;
    
    -- Conversão do contador de segundos (8 bits) para dois dígitos BCD (4 bits cada)
    -- O contador de segundos é um número binário de 8 bits (0 a 255).
    -- Para exibir em dois displays de 7 segmentos, precisamos dos dígitos da dezena e da unidade.
    -- Como o tempo_para_desarme é de 0 a 255, e o display é de 2 dígitos (00 a 99), 
    -- vamos exibir apenas os dois dígitos menos significativos (unidade e dezena) do contador.
    -- O requisito diz que o tempo_para_desarme é de 0 a 255, mas a saída é para 2 displays HEX.
    -- Assumindo que o tempo máximo a ser exibido é 99, o contador de 8 bits é suficiente.
    -- Vamos converter o valor binário de segundos_s para BCD.
    
    -- Exemplo de conversão de binário para BCD (Double Dabble Algorithm ou uso de funções prontas)
    -- Para simplificar, e dado que o máximo é 255, e o tempo_para_desarme é um generic,
    -- vamos assumir que o valor máximo que o usuário irá configurar para tempo_para_desarme
    -- será um valor que pode ser representado em 2 dígitos decimais (0 a 99).
    -- Se o valor for maior que 99, o display mostrará um valor truncado ou incorreto.
    -- A conversão binário para BCD é complexa para ser feita manualmente em VHDL.
    -- Uma alternativa é usar a função de conversão se disponível, ou uma tabela de lookup.
    -- Dado o escopo, e a necessidade de exibir o valor do contador, a melhor abordagem é
    -- fazer a conversão de binário para BCD.
    
    -- Para o propósito de simulação e prototipação, vamos usar uma abordagem simples
    -- que funciona para valores até 99, que é o limite prático para 2 displays.
    
    -- Conversão para BCD (para valores até 99)
    digito_lsb <= std_logic_vector(to_unsigned(to_integer(unsigned(segundos_s)) mod 10, 4));
    digito_msb <= std_logic_vector(to_unsigned(to_integer(unsigned(segundos_s)) / 10, 4));
    
    -- Instanciação do decodificador binto7seg para o dígito da unidade (HEX2)
    U_BINTO7SEG_LSB : binto7seg
        port map (
            input   => digito_lsb, -- Dígito da unidade
            display => HEX2        -- Display HEX2 (unidade)
        );

    -- Instanciação do decodificador binto7seg para o dígito da dezena (HEX3)
    U_BINTO7SEG_MSB : binto7seg
        port map (
            input   => digito_msb, -- Dígito da dezena
            display => HEX3        -- Display HEX3 (dezena)
        );

end architecture structural;
