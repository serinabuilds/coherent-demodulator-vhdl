library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mixer is
port(
    clk       : in  std_logic;
    rst       : in  std_logic;

    -- Received sample
    rx_sample : in signed(15 downto 0);

    -- DDS outputs
    sin_wave  : in signed(15 downto 0);
    cos_wave  : in signed(15 downto 0);

    -- Mixer outputs
    I_product : out signed(31 downto 0);
    Q_product : out signed(31 downto 0)
);
end entity;

architecture rtl of mixer is
begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then

                I_product <= (others => '0');
                Q_product <= (others => '0');

            else

                -- In-phase mixer
                I_product <= rx_sample * cos_wave;

                -- Quadrature mixer
                Q_product <= rx_sample * sin_wave;

            end if;

        end if;
    end process;

end rtl;
