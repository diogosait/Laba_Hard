# Projeto de Fechadura Eletrônica em VHDL

Este projeto implementa um modelo simplificado de fechadura eletrônica em VHDL, conforme especificado para o Trabalho Prático da disciplina de Laboratório de Hardware.
##

link do video da implementação https://www.youtube.com/shorts/bE7Q_snYwi0

## Estrutura do Projeto

O projeto é composto pelas seguintes entidades VHDL:

| Arquivo | Entidade | Descrição |
| :--- | :--- | :--- |
| `binto7seg.vhd` | `binto7seg` | Decodificador binário de 4 bits para display de 7 segmentos hexadecimal (anodo comum). |
| `trava.vhd` | `trava` | Entidade principal da fechadura, controlando o desbloqueio por senha e o contador de tempo. |
| `clk_div.vhd` | `clk_div` | Divisor de frequência para gerar um sinal de clock de 1 Hz a partir do clock de 50 MHz da FPGA. |
| `main.vhd` | `main` | Entidade de nível superior que instancia e interliga as entidades `trava`, `binto7seg` e `clk_div`, mapeando-as para os pinos da FPGA DE0. |

## Testbenches

Os seguintes arquivos de Testbench foram criados para verificação e validação em tempo de simulação:

| Arquivo | Entidade Testada | Descrição |
| :--- | :--- | :--- |
| `binto7seg_tb.vhd` | `binto7seg` | Testa a conversão de todos os valores binários de 0 a 15 para o código de 7 segmentos hexadecimal. |
| `trava_tb.vhd` | `trava` | Testa a lógica de reset, decremento do contador, e o desbloqueio/bloqueio com a senha correta/incorreta. |
| `clk_div_tb.vhd` | `clk_div` | Testa a geração do sinal de 1 Hz a partir do clock de 50 MHz. |

## Mapeamento de Pinos (FPGA DE0)

A entidade `main` foi projetada para o seguinte mapeamento na placa Altera DE0:

| Sinal | Pino da FPGA (DE0) | Descrição |
| :--- | :--- | :--- |
| `CLOCK_50` | CLOCK_50 | Clock de 50 MHz (entrada) |
| `SW(9)` | SW9 | Reset da trava (entrada) |
| `SW(7 downto 0)` | SW7-SW0 | Input da senha (entrada) |
| `LEDR(9)` | LEDR9 | Sinal da trava (`1`=travado, `0`=destravado) (saída) |
| `LEDR(7 downto 0)` | LEDR7-LEDR0 | Visualização do input da senha (saída) |
| `HEX3` | HEX3 | Display de 7 segmentos (dezena do contador) (saída) |
| `HEX2` | HEX2 | Display de 7 segmentos (unidade do contador) (saída) |

**Nota:** A senha padrão e o tempo de desarme podem ser configurados via `generic` na entidade `main`. O valor padrão é `SENHA_PADRAO = 123` e `TEMPO_PADRAO = 10` segundos.

## Como Usar

1. Compile os arquivos VHDL (`.vhd`) em um ambiente de desenvolvimento como o Quartus Prime.
2. Utilize os arquivos de Testbench (`_tb.vhd`) para simular e verificar o comportamento das entidades.
3. Para prototipação na FPGA DE0, utilize a entidade `main.vhd` como o top-level design e configure o mapeamento de pinos conforme a tabela acima.
4. Lembre-se de que a entidade `trava` espera um clock de 1 Hz, que é gerado pela `clk_div` a partir do `CLOCK_50` da placa.
5. O display de 7 segmentos (`binto7seg`) é configurado para displays de **anodo comum** (o que é comum na DE0).
