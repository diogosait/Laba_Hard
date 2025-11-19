library ieee;
use ieee.std_logic_1164.all;

entity binto7seg is
    port (
        input: in std_logic_vector(3 downto 0); -- Valor binário a ser mostrado (0 a 15)
        display: out std_logic_vector(7 downto 0) -- LEDs do Display de 7 seg. (a, b, c, d, e, f, g, dp)
    );
end entity binto7seg;

architecture behavioral of binto7seg is
    -- O mapeamento é para um display de 7 segmentos de anodo comum (ativo baixo).
    -- display(7) é o ponto decimal (dp), que será mantido em '1' (apagado).
    -- display(6 downto 0) são os segmentos g, f, e, d, c, b, a.
    -- O padrão de saída é (dp, g, f, e, d, c, b, a)
    -- Para anodo comum, '0' acende o segmento, '1' apaga.
    -- O mapeamento de segmentos é:
    --    --a--
    --   |     |
    --   f     b
    --   |     |
    --    --g--
    --   |     |
    --   e     c
    --   |     |
    --    --d--  .dp
    
    -- O mapeamento de saída será (dp, g, f, e, d, c, b, a)
    -- O display(7) é o dp, que será '1' (apagado)
    -- O display(6) é o g
    -- O display(5) é o f
    -- O display(4) é o e
    -- O display(3) é o d
    -- O display(2) é o c
    -- O display(1) é o b
    -- O display(0) é o a
    
    -- O padrão de bits para acender os segmentos (0=on, 1=off) é:
    -- (g, f, e, d, c, b, a)
    -- 0: 0111111 -> 0x3F -> "00111111" (com dp=0) -> "10111111" (com dp=1)
    -- 1: 0000110 -> 0x06 -> "00000110" (com dp=0) -> "10000110" (com dp=1)
    -- 2: 1011011 -> 0x5B -> "10111011" (com dp=0) -> "11011011" (com dp=1)
    -- 3: 1001111 -> 0x4F -> "10011111" (com dp=0) -> "11001111" (com dp=1)
    -- 4: 1100110 -> 0x66 -> "11000110" (com dp=0) -> "11100110" (com dp=1)
    -- 5: 1101101 -> 0x6D -> "11011101" (com dp=0) -> "11101101" (com dp=1)
    -- 6: 1111101 -> 0x7D -> "11111101" (com dp=0) -> "11111101" (com dp=1)
    -- 7: 0000111 -> 0x07 -> "00000111" (com dp=0) -> "10000111" (com dp=1)
    -- 8: 1111111 -> 0x7F -> "11111111" (com dp=0) -> "11111111" (com dp=1)
    -- 9: 1101111 -> 0x6F -> "11011111" (com dp=0) -> "11101111" (com dp=1)
    -- A: 1110111 -> 0x77 -> "11101111" (com dp=0) -> "11101111" (com dp=1)
    -- B: 1111100 -> 0x7C -> "11111100" (com dp=0) -> "11111100" (com dp=1)
    -- C: 0111001 -> 0x39 -> "01111001" (com dp=0) -> "10111001" (com dp=1)
    -- D: 1011110 -> 0x5E -> "10111110" (com dp=0) -> "11011110" (com dp=1)
    -- E: 1111001 -> 0x79 -> "11111001" (com dp=0) -> "11111001" (com dp=1)
    -- F: 1110001 -> 0x71 -> "11101001" (com dp=0) -> "11101001" (com dp=1)
    
    -- Corrigindo a ordem dos bits de saída para (dp, g, f, e, d, c, b, a)
    -- O manual da DE0 (pág. 29) indica que o HEX3-HEX0 é (dp, a, b, c, d, e, f, g)
    -- Vamos seguir a ordem do manual para facilitar a prototipação: (dp, a, b, c, d, e, f, g)
    -- display(7) = dp
    -- display(6) = a
    -- display(5) = b
    -- display(4) = c
    -- display(3) = d
    -- display(2) = e
    -- display(1) = f
    -- display(0) = g
    
    -- Para anodo comum, '0' acende o segmento, '1' apaga.
    -- O padrão de bits para acender os segmentos (0=on, 1=off) é:
    -- (g, f, e, d, c, b, a)
    -- 0: 0111111 -> (0, 1, 1, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 0, 0, 0, 1) -> "10000001"
    -- 1: 0000110 -> (0, 0, 0, 0, 1, 1, 0) -> (dp, a, b, c, d, e, f, g) -> (1, 1, 0, 0, 0, 0, 0, 1) -> "11000001" -> (1, 1, 0, 0, 1, 1, 0, 0) -> "11001100"
    -- 2: 1011011 -> (1, 0, 1, 1, 0, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 1, 0, 1, 1, 1) -> "10010111"
    -- 3: 1001111 -> (1, 0, 0, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 0, 1, 1, 1) -> "10000111"
    -- 4: 1100110 -> (1, 1, 0, 0, 1, 1, 0) -> (dp, a, b, c, d, e, f, g) -> (1, 1, 0, 0, 1, 1, 0, 0) -> "11001100"
    -- 5: 1101101 -> (1, 1, 0, 1, 1, 0, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 1, 0, 0, 1, 0, 1) -> "10100101"
    -- 6: 1111101 -> (1, 1, 1, 1, 1, 0, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 1, 0, 0, 0, 0, 1) -> "10100001"
    -- 7: 0000111 -> (0, 0, 0, 0, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 1, 1, 0, 0) -> "10001100"
    -- 8: 1111111 -> (1, 1, 1, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 0, 0, 0, 0) -> "10000000"
    -- 9: 1101111 -> (1, 1, 0, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 0, 1, 0, 0) -> "10000100"
    -- A: 1110111 -> (1, 1, 1, 0, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 0, 0, 1, 0, 0, 0) -> "10001000"
    -- B: 1111100 -> (1, 1, 1, 1, 1, 0, 0) -> (dp, a, b, c, d, e, f, g) -> (1, 1, 0, 0, 0, 0, 0, 0) -> "11000000"
    -- C: 0111001 -> (0, 1, 1, 1, 0, 0, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 1, 1, 1, 0, 0, 1) -> "10111001"
    -- D: 1011110 -> (1, 0, 1, 1, 1, 1, 0) -> (dp, a, b, c, d, e, f, g) -> (1, 1, 0, 0, 0, 1, 1, 1) -> "11000111"
    -- E: 1111001 -> (1, 1, 1, 1, 0, 0, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 1, 1, 1, 0, 0, 0) -> "10111000"
    -- F: 1110001 -> (1, 1, 1, 0, 0, 0, 1) -> (dp, a, b, c, d, e, f, g) -> (1, 0, 1, 1, 1, 0, 0, 0) -> "10111000"
    
    -- Re-mapeando para a ordem (dp, a, b, c, d, e, f, g) e anodo comum (0=on, 1=off)
    -- O padrão de bits para acender os segmentos (a, b, c, d, e, f, g) é:
    -- 0: 1111110 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 0, 0, 0, 1) -> (dp, a, b, c, d, e, f, g) -> "10000001"
    -- 1: 0110000 -> (a, b, c, d, e, f, g) -> (1, 0, 0, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> "11001111"
    -- 2: 1101101 -> (a, b, c, d, e, f, g) -> (0, 0, 1, 0, 0, 1, 0) -> (dp, a, b, c, d, e, f, g) -> "10010010"
    -- 3: 1111001 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 0, 1, 1, 0) -> (dp, a, b, c, d, e, f, g) -> "10001100"
    -- 4: 0110011 -> (a, b, c, d, e, f, g) -> (1, 0, 0, 1, 1, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "11001100"
    -- 5: 1011011 -> (a, b, c, d, e, f, g) -> (0, 1, 0, 0, 1, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10100100"
    -- 6: 1011111 -> (a, b, c, d, e, f, g) -> (0, 1, 0, 0, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10100000"
    -- 7: 1110000 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 1, 1, 1, 1) -> (dp, a, b, c, d, e, f, g) -> "10001111"
    -- 8: 1111111 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 0, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10000000"
    -- 9: 1111011 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 0, 1, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10001000"
    -- A: 1110111 -> (a, b, c, d, e, f, g) -> (0, 0, 0, 1, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10001000"
    -- B: 0011111 -> (a, b, c, d, e, f, g) -> (1, 1, 0, 0, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "11000000"
    -- C: 1001110 -> (a, b, c, d, e, f, g) -> (0, 1, 1, 0, 0, 0, 1) -> (dp, a, b, c, d, e, f, g) -> "10110001"
    -- D: 0111101 -> (a, b, c, d, e, f, g) -> (1, 0, 0, 0, 0, 1, 0) -> (dp, a, b, c, d, e, f, g) -> "11000010"
    -- E: 1001111 -> (a, b, c, d, e, f, g) -> (0, 1, 1, 0, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10110000"
    -- F: 1000111 -> (a, b, c, d, e, f, g) -> (0, 1, 1, 1, 0, 0, 0) -> (dp, a, b, c, d, e, f, g) -> "10111000"
    
    -- A tabela de verdade para anodo comum (0=on, 1=off) e ordem (dp, a, b, c, d, e, f, g)
    -- O ponto decimal (dp) será sempre '1' (apagado)
    
begin
    
    process(input)
    begin
        -- O bit 7 (display(7)) é o ponto decimal (dp), que será sempre '1' (apagado)
        display(7) <= '1';
        
        case input is
            -- '0' -> (a, b, c, d, e, f, g) = (0, 0, 0, 0, 0, 0, 1) -> "0000001"
            when "0000" => display(6 downto 0) <= "0000001"; -- 0
            -- '1' -> (a, b, c, d, e, f, g) = (1, 0, 0, 1, 1, 1, 1) -> "1001111"
            when "0001" => display(6 downto 0) <= "1001111"; -- 1
            -- '2' -> (a, b, c, d, e, f, g) = (0, 0, 1, 0, 0, 1, 0) -> "0010010"
            when "0010" => display(6 downto 0) <= "0010010"; -- 2
            -- '3' -> (a, b, c, d, e, f, g) = (0, 0, 0, 0, 1, 1, 0) -> "0000110"
            when "0011" => display(6 downto 0) <= "0000110"; -- 3
            -- '4' -> (a, b, c, d, e, f, g) = (1, 0, 0, 1, 1, 0, 0) -> "1001100"
            when "0100" => display(6 downto 0) <= "1001100"; -- 4
            -- '5' -> (a, b, c, d, e, f, g) = (0, 1, 0, 0, 1, 0, 0) -> "0100100"
            when "0101" => display(6 downto 0) <= "0100100"; -- 5
            -- '6' -> (a, b, c, d, e, f, g) = (0, 1, 0, 0, 0, 0, 0) -> "0100000"
            when "0110" => display(6 downto 0) <= "0100000"; -- 6
            -- '7' -> (a, b, c, d, e, f, g) = (0, 0, 0, 1, 1, 1, 1) -> "0001111"
            when "0111" => display(6 downto 0) <= "0001111"; -- 7
            -- '8' -> (a, b, c, d, e, f, g) = (0, 0, 0, 0, 0, 0, 0) -> "0000000"
            when "1000" => display(6 downto 0) <= "0000000"; -- 8
            -- '9' -> (a, b, c, d, e, f, g) = (0, 0, 0, 0, 1, 0, 0) -> "0000100"
            when "1001" => display(6 downto 0) <= "0000100"; -- 9
            -- 'A' -> (a, b, c, d, e, f, g) = (0, 0, 0, 1, 0, 0, 0) -> "0001000"
            when "1010" => display(6 downto 0) <= "0001000"; -- A
            -- 'B' -> (a, b, c, d, e, f, g) = (1, 1, 0, 0, 0, 0, 0) -> "1100000"
            when "1011" => display(6 downto 0) <= "1100000"; -- B
            -- 'C' -> (a, b, c, d, e, f, g) = (0, 1, 1, 0, 0, 0, 1) -> "0110001"
            when "1100" => display(6 downto 0) <= "0110001"; -- C
            -- 'D' -> (a, b, c, d, e, f, g) = (1, 0, 0, 0, 0, 1, 0) -> "1000010"
            when "1101" => display(6 downto 0) <= "1000010"; -- D
            -- 'E' -> (a, b, c, d, e, f, g) = (0, 1, 1, 0, 0, 0, 0) -> "0110000"
            when "1110" => display(6 downto 0) <= "0110000"; -- E
            -- 'F' -> (a, b, c, d, e, f, g) = (0, 1, 1, 1, 0, 0, 0) -> "0111000"
            when "1111" => display(6 downto 0) <= "0111000"; -- F
            -- Default: Apaga todos os segmentos
            when others => display(6 downto 0) <= "1111111";
        end case;
    end process;
    
end architecture behavioral;
