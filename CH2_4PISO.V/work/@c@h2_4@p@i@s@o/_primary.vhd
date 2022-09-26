library verilog;
use verilog.vl_types.all;
entity CH2_4PISO is
    port(
        CLK             : in     vl_logic;
        SH_LDN          : in     vl_logic;
        D               : in     vl_logic_vector(3 downto 0);
        Q               : out    vl_logic
    );
end CH2_4PISO;
