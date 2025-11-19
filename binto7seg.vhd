library ieee;
use ieee.std_logic_1164.all;

entity binto7seg is
    port (
        input   : in  std_logic_vector(3 downto 0); -- nibble
        display : out std_logic_vector(7 downto 0)  -- [7]=DP, [6..0]=abcdefg
    );
end entity;

architecture rtl of binto7seg is
begin
    process(input)
    begin
        -- Aqui estou assumindo display de 7 segmentos common anode/cathode conforme
        -- seu professor usar; se inverter, basta complementar os bits.
        case input is
            when "0000" => display <= "11000000"; -- 0
            when "0001" => display <= "11111001"; -- 1
            when "0010" => display <= "10100100"; -- 2
            when "0011" => display <= "10110000"; -- 3
            when "0100" => display <= "10011001"; -- 4
            when "0101" => display <= "10010010"; -- 5
            when "0110" => display <= "10000010"; -- 6
            when "0111" => display <= "11111000"; -- 7
            when "1000" => display <= "10000000"; -- 8
            when "1001" => display <= "10010000"; -- 9
            when "1010" => display <= "10001000"; -- A
            when "1011" => display <= "10000011"; -- b
            when "1100" => display <= "11000110"; -- C
            when "1101" => display <= "10100001"; -- d
            when "1110" => display <= "10000110"; -- E
            when "1111" => display <= "10001110"; -- F
            when others => display <= (others => '1');
        end case;
    end process;
end architecture;
