library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binto7seg_tb is
end entity binto7seg_tb;

architecture behavioral of binto7seg_tb is
    -- Componente a ser testado
    component binto7seg
        port (
            input: in std_logic_vector(3 downto 0);
            display: out std_logic_vector(7 downto 0)
        );
    end component;

    -- Sinais para o DUT (Device Under Test)
    signal input_tb: std_logic_vector(3 downto 0) := (others => '0');
    signal display_tb: std_logic_vector(7 downto 0);

begin
    -- Instanciação do DUT
    uut: binto7seg
        port map (
            input => input_tb,
            display => display_tb
        );

    -- Processo de geração de estímulos
    stim_proc: process
    begin
        -- Teste de 0 a F (Hexadecimal)
        for i in 0 to 15 loop
            input_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns; -- Tempo para a lógica combinacional se estabilizar
        end loop;

        -- Teste de valores aleatórios (opcional, mas bom para cobertura)
        input_tb <= "1001"; -- 9
        wait for 10 ns;
        input_tb <= "1110"; -- E
        wait for 10 ns;
        input_tb <= "0010"; -- 2
        wait for 10 ns;
        
        -- Teste de "others" (fora do range 0-15, embora o input seja 4 bits)
        -- Não aplicável para 4 bits, mas para garantir que o case others funciona
        -- O case others só é alcançado se o valor for "UUUU" ou similar.
        
        wait; -- Fim da simulação
    end process;

end architecture behavioral;
