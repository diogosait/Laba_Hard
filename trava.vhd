library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trava is
    generic (
        senha              : natural range 0 to 255;
        tempo_para_desarme : natural range 0 to 255
    );
    port (
        clock    : in  std_logic;                     -- clock de 1 Hz
        reset    : in  std_logic;                     -- reset síncrono
        input    : in  std_logic_vector(7 downto 0);  -- chaves (senha)
        segundos : out std_logic_vector(7 downto 0);  -- tempo restante
        trava1   : out std_logic                      -- 1 = travado, 0 = destravado
    );
end entity;

architecture rtl of trava is
    signal contador   : unsigned(7 downto 0) := (others => '0');
    signal trava_reg  : std_logic := '1';
    signal last_input : std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clock)
        constant senha_bin : unsigned(7 downto 0) := to_unsigned(senha, 8);
        variable input_changed : boolean;
        variable new_trava     : std_logic;
        variable new_contador  : unsigned(7 downto 0);
    begin
        if rising_edge(clock) then
            -- valores default (começam com o atual)
            new_trava    := trava_reg;
            new_contador := contador;

            -- detecta mudança de input
            input_changed := (input /= last_input);

            if reset = '1' then
                -- reset geral
                new_contador := to_unsigned(tempo_para_desarme, 8);
                new_trava    := '1';      -- travado
            else
                if contador > 0 then
                    -- houve mudança nas chaves?
                    if input_changed then
                        if unsigned(input) = senha_bin then
                            -- senha correta: destrava e congela tempo
                            new_trava := '0';
                        else
                            -- senha errada: trava e continua a contagem
                            new_trava := '1';
                        end if;
                    end if;

                    -- se ainda estiver travado, o tempo continua correndo
                    if new_trava = '1' then
                        new_contador := contador - 1;
                    end if;
                else
                    -- tempo esgotado -> sempre travado
                    new_trava := '1';
                end if;
            end if;

            -- atualiza registradores
            trava_reg  <= new_trava;
            contador   <= new_contador;
            last_input <= input;
        end if;
    end process;

    trava1   <= trava_reg;
    segundos <= std_logic_vector(contador);

end architecture;
