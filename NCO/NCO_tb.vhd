library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_phase_accumulator is
end tb_phase_accumulator;

architecture sim of tb_phase_accumulator is

    ------------------------------------------------------------------
    -- DUT Declaration
    ------------------------------------------------------------------

    component phase_accumulator
        port(
            clk     : in  std_logic;
            rst     : in  std_logic;
            phase   : out unsigned(15 downto 0);
            sin_out : out signed(15 downto 0);
            cos_out : out signed(15 downto 0)
        );
    end component;

    ------------------------------------------------------------------
    -- Signals
    ------------------------------------------------------------------

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';

    signal phase   : unsigned(15 downto 0);
    signal sin_out : signed(15 downto 0);
    signal cos_out : signed(15 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    ------------------------------------------------------------------
    -- Instantiate DUT
    ------------------------------------------------------------------

    DUT : phase_accumulator
    port map(
        clk     => clk,
        rst     => rst,
        phase   => phase,
        sin_out => sin_out,
        cos_out => cos_out
    );

    ------------------------------------------------------------------
    -- Clock Generation (100 MHz)
    ------------------------------------------------------------------

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;

            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    ------------------------------------------------------------------
    -- Stimulus
    ------------------------------------------------------------------

    stimulus : process
    begin

        --------------------------------------------------------------
        -- Hold Reset
        --------------------------------------------------------------

        rst <= '1';
        wait for 100 ns;

        --------------------------------------------------------------
        -- Release Reset
        --------------------------------------------------------------

        rst <= '0';

        --------------------------------------------------------------
        -- Let DDS pipeline fill
        --------------------------------------------------------------

        wait for 500 ns;

        --------------------------------------------------------------
        -- Continue running
        --------------------------------------------------------------

        wait for 100 us;

        report "Simulation Completed Successfully";

        wait;

    end process;

end sim;
