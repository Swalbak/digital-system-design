library verilog;
use verilog.vl_types.all;
entity CH2_4SIPO is
    port(
        CLK             : in     vl_logic;
        RESETN          : in     vl_logic;
        DATA_IN         : in     vl_logic;
        Q               : out    vl_logic_vector(3 downto 0)
    );
end CH2_4SIPO;
