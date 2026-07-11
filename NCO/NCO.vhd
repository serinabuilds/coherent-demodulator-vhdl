library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator is 
    port( 
            clk : in std_logic ;
            rst : in std_logic ;
            phase : out unsigned(15 downto 0) ;
            sin_out  : out signed(15 downto 0);
            cos_out  : out signed(15 downto 0)
        );
end entity;
        


architecture rtl of phase_accumulator is

COMPONENT dds_compiler_costasloop
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

signal dds_valid : std_logic;
signal dds_data  : std_logic_vector(31 downto 0);

constant FCW : unsigned (15 downto 0)
:=to_unsigned(6554,16);
signal phase_reg : unsigned (15 downto 0) ;

begin 
process(clk) 
begin 
    if rising_edge(clk) then 
        if rst = '1' then 
            phase_reg <= (others=>'0');
        else 
            phase_reg <= phase_reg + FCW ;
        end if; 
   end if ; 
   
end process ;

phase <= phase_reg;

dds_compiler_costasloop_inst : dds_compiler_costasloop
  PORT MAP (
    aclk => clk,
    s_axis_phase_tvalid => '1' ,
    s_axis_phase_tdata => std_logic_vector(phase_reg),
    m_axis_data_tvalid => dds_valid,
    m_axis_data_tdata => dds_data
  );

cos_out <= signed(dds_data(31 downto 16));
sin_out <= signed(dds_data(15 downto 0));

end rtl ;
            
            
            
            
            
