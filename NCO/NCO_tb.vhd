library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_phase_accumulator is
end entity;

architecture sim of tb_phase_accumulator is

    -------------------------------------------------------------------
    -- Component Declaration
    -------------------------------------------------------------------
    component phase_accumulator
        port(
            clk   : in  std_logic;
            rst   : in  std_logic;
            phase : out std_logic_vector(15 downto 0)
        );
    end component;

    -------------------------------------------------------------------
    -- Signals
    -------------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';
    signal phase : std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin

    -------------------------------------------------------------------
    -- Instantiate DUT
    -------------------------------------------------------------------
    DUT : phase_accumulator
        port map(
            clk   => clk,
            rst   => rst,
            phase => phase
        );

    -------------------------------------------------------------------
    -- Clock Generation
    -------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;

            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -------------------------------------------------------------------
    -- Stimulus Process
    -------------------------------------------------------------------
    stimulus : process
    begin

        ---------------------------------------------------------------
        -- Hold reset for 5 clock cycles
        ---------------------------------------------------------------
        rst <= '1';
        wait for 100 ns;

        ---------------------------------------------------------------
        -- Release reset
        ---------------------------------------------------------------
        rst <= '0';

        ---------------------------------------------------------------
        -- Run simulation for 40 clock cycles
        ---------------------------------------------------------------
        wait for 800 ns;

        ---------------------------------------------------------------
        -- Stop Simulation
        ---------------------------------------------------------------
        assert false
            report "Simulation Finished"
            severity failure;

    end process;

end architecture;