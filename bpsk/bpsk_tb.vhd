library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bpsk_tb is
end entity;

architecture sim of bpsk_tb is

component bpsk
port(
    clk      : in std_logic;
    rst      : in std_logic;
    bpsk_out : out signed(15 downto 0)
);
end component;

signal clk : std_logic := '0';
signal rst : std_logic := '1';

signal bpsk_out : signed(15 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

--------------------------------------------------------------------
-- DUT
--------------------------------------------------------------------

DUT : bpsk
port map(

    clk      => clk,
    rst      => rst,
    bpsk_out => bpsk_out

);

--------------------------------------------------------------------
-- Clock
--------------------------------------------------------------------

clk_process : process
begin

    while true loop

        clk <= '0';
        wait for CLK_PERIOD/2;

        clk <= '1';
        wait for CLK_PERIOD/2;

    end loop;

end process;

--------------------------------------------------------------------
-- Reset
--------------------------------------------------------------------

stimulus : process
begin

    rst <= '1';
    wait for 40 ns;

    rst <= '0';

    wait for 5000 ns;

    report "Simulation Finished";

    wait;

end process;

end sim;