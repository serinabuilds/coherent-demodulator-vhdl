library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity Demodulator_tb is
end entity Demodulator_tb;

architecture sim of Demodulator_tb is

------------------------------------------------------------------
-- Component Declaration
------------------------------------------------------------------

component Demodulator
port(
    clk         : in  std_logic;
    rst         : in  std_logic;
    rx_sample   : in  signed(15 downto 0);

    sin_wave_o  : out signed(15 downto 0);
    cos_wave_o  : out signed(15 downto 0);

    I_mix_o     : out signed(31 downto 0);
    Q_mix_o     : out signed(31 downto 0);

    I_filt_o    : out signed(31 downto 0);
    Q_filt_o    : out signed(31 downto 0)
);
end component;

------------------------------------------------------------------
-- Signals
------------------------------------------------------------------

signal clk       : std_logic := '0';
signal rst       : std_logic := '1';

signal rx_sample : signed(15 downto 0) := (others => '0');

signal sin_wave  : signed(15 downto 0);
signal cos_wave  : signed(15 downto 0);

signal I_mix     : signed(31 downto 0);
signal Q_mix     : signed(31 downto 0);

signal I_filt    : signed(31 downto 0);
signal Q_filt    : signed(31 downto 0);

constant CLK_PERIOD : time := 10 ns;

------------------------------------------------------------------
-- Input File
------------------------------------------------------------------

file IQ_FILE : text open read_mode is
"C:/Users/sakha/Desktop/WORK/CENTUM WORK/Mixers/IQ_data.txt";

begin

------------------------------------------------------------------
-- Clock Generation
------------------------------------------------------------------

clk <= not clk after CLK_PERIOD/2;

------------------------------------------------------------------
-- DUT
------------------------------------------------------------------

DUT : Demodulator
port map(

    clk => clk,
    rst => rst,

    rx_sample => rx_sample,

    sin_wave_o => sin_wave,
    cos_wave_o => cos_wave,

    I_mix_o => I_mix,
    Q_mix_o => Q_mix,

    I_filt_o => I_filt,
    Q_filt_o => Q_filt

);

------------------------------------------------------------------
-- Stimulus Process
------------------------------------------------------------------

stim_proc : process

    variable L          : line;
    variable sample_int : integer;

begin

    --------------------------------------------------------------
    -- Reset
    --------------------------------------------------------------

    rst <= '1';
    wait for 100 ns;
    rst <= '0';

    wait until rising_edge(clk);

    --------------------------------------------------------------
    -- Read IQ samples
    --------------------------------------------------------------

    while not endfile(IQ_FILE) loop

        readline(IQ_FILE, L);
        read(L, sample_int);

        rx_sample <= to_signed(sample_int,16);

        wait until rising_edge(clk);

    end loop;
    --------------------------------------------------------------
    -- End Simulation
    --------------------------------------------------------------
    wait for 500 ns;
    assert false
        report "Simulation Finished"
        severity failure;

end process;
end architecture sim;
