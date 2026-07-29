library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bpsk is
port(
    clk      : in  std_logic;
    rst      : in  std_logic;
    bpsk_out : out signed(15 downto 0)
);
end entity;

architecture rtl of bpsk is

    --------------------------------------------------------------------
    -- DDS Signals
    --------------------------------------------------------------------
    signal sin_wave   : signed(15 downto 0);
    signal cos_wave   : signed(15 downto 0);
    signal phase_word : unsigned(15 downto 0);

    --------------------------------------------------------------------
    -- Test Data
    --------------------------------------------------------------------
    constant TEST_DATA : std_logic_vector(15 downto 0) :=
                         "1011001001110101";

    signal tx_data : std_logic_vector(15 downto 0);
    signal current_bit : std_logic;

    signal bit_counter : integer range 0 to 9 := 0;

begin

    --------------------------------------------------------------------
    -- DDS / Phase Accumulator
    --------------------------------------------------------------------
    DDS_INST : entity work.phase_accumulator
    port map(
        clk     => clk,
        rst     => rst,
        phase   => phase_word,
        sin_out => sin_wave,
        cos_out => cos_wave
    );

    --------------------------------------------------------------------
    -- Data Generator
    --------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            if rst='1' then

                tx_data <= TEST_DATA;
                bit_counter <= 0;

            else

                if bit_counter = 9 then

                    bit_counter <= 0;

                    tx_data <= tx_data(14 downto 0) &
                               tx_data(15);

                else

                    bit_counter <= bit_counter + 1;

                end if;

            end if;

        end if;
    end process;

    current_bit <= tx_data(15);

    --------------------------------------------------------------------
    -- BPSK Modulator
    --------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then

            if current_bit='1' then
                bpsk_out <= sin_wave;
            else
                bpsk_out <= -sin_wave;
            end if;

        end if;
    end process;

end rtl;