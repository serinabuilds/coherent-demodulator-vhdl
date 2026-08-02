library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Demodulator is
port(
    clk       : in  std_logic;
    rst       : in  std_logic;

    -- Input sample
    rx_sample : in signed(15 downto 0);

    -- Outputs for observation
    sin_wave_o : out signed(15 downto 0);
    cos_wave_o : out signed(15 downto 0);

    I_mix_o    : out signed(31 downto 0);
    Q_mix_o    : out signed(31 downto 0);

    I_filt_o   : out signed(31 downto 0);
    Q_filt_o   : out signed(31 downto 0)
);
end entity Demodulator;

architecture rtl of Demodulator is

------------------------------------------------------------
-- Phase Accumulator
------------------------------------------------------------

component phase_accumulator
port(
    clk     : in std_logic;
    rst     : in std_logic;
    phase   : out unsigned(15 downto 0);
    sin_out : out signed(15 downto 0);
    cos_out : out signed(15 downto 0)
);
end component;

------------------------------------------------------------
-- Mixer
------------------------------------------------------------

component mixer
port(clk       : in std_logic;
    rst       : in std_logic;
    rx_sample : in signed(15 downto 0);
    sin_wave  : in signed(15 downto 0);
    cos_wave  : in signed(15 downto 0);
    I_product : out signed(31 downto 0);
    Q_product : out signed(31 downto 0));
end component;

------------------------------------------------------------
-- FIR Filter
------------------------------------------------------------

component fir_filter
port(
    aclk                : in std_logic;

    s_axis_data_tvalid  : in std_logic;
    s_axis_data_tready  : out std_logic;
    s_axis_data_tdata   : in std_logic_vector(31 downto 0);

    m_axis_data_tvalid  : out std_logic;
    m_axis_data_tdata   : out std_logic_vector(31 downto 0)
);
end component;

------------------------------------------------------------
-- Internal Signals
------------------------------------------------------------

signal phase_sig : unsigned(15 downto 0);

signal sin_sig   : signed(15 downto 0);
signal cos_sig   : signed(15 downto 0);

signal I_mix     : signed(31 downto 0);
signal Q_mix     : signed(31 downto 0);

signal I_filt    : std_logic_vector(31 downto 0);
signal Q_filt    : std_logic_vector(31 downto 0);

signal I_ready   : std_logic;
signal Q_ready   : std_logic;

signal I_valid   : std_logic;
signal Q_valid   : std_logic;

begin

------------------------------------------------------------
-- Phase Accumulator
------------------------------------------------------------

NCO : phase_accumulator
port map(
    clk     => clk,
    rst     => rst,
    phase   => phase_sig,
    sin_out => sin_sig,
    cos_out => cos_sig
);

------------------------------------------------------------
-- Mixer
------------------------------------------------------------

MIX : mixer
port map(
    clk       => clk,
    rst       => rst,

    rx_sample => rx_sample,

    sin_wave  => sin_sig,
    cos_wave  => cos_sig,

    I_product => I_mix,
    Q_product => Q_mix
);

------------------------------------------------------------
-- FIR I
------------------------------------------------------------

FIR_I : fir_filter
port map(
    aclk               => clk,
    s_axis_data_tvalid => '1',
    s_axis_data_tready => I_ready,
    s_axis_data_tdata  => std_logic_vector(I_mix),

    m_axis_data_tvalid => I_valid,
    m_axis_data_tdata  => I_filt
);

------------------------------------------------------------
-- FIR Q
------------------------------------------------------------

FIR_Q : fir_filter
port map(
    aclk               => clk,

    s_axis_data_tvalid => '1',
    s_axis_data_tready => Q_ready,
    s_axis_data_tdata  => std_logic_vector(Q_mix),

    m_axis_data_tvalid => Q_valid,
    m_axis_data_tdata  => Q_filt
);

------------------------------------------------------------
-- Outputs
------------------------------------------------------------

sin_wave_o <= sin_sig;
cos_wave_o <= cos_sig;

I_mix_o <= I_mix;
Q_mix_o <= Q_mix;

I_filt_o <= signed(I_filt);
Q_filt_o <= signed(Q_filt);

end architecture rtl;
