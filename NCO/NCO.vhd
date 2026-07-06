library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator is
    port(
        clk   : in std_logic;
        rst   : in std_logic;
        phase : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of phase_accumulator is

constant FCW : unsigned(15 downto 0)
:= to_unsigned(6554,16);
signal phase_reg : unsigned(15 downto 0);

begin
process(clk)

begin
if rising_edge(clk) then
    if rst='1' then
        phase_reg <= (others=>'0');
    else
        phase_reg <= phase_reg + FCW;
    end if;
end if;
end process;

phase <= std_logic_vector(phase_reg);
end rtl;