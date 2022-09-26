library verilog;
use verilog.vl_types.all;
entity COUNT_8BIT is
    port(
        RESETN          : in     vl_logic;
        CLK             : in     vl_logic;
        COUNT_OUT       : out    vl_logic_vector(7 downto 0)
    );
end COUNT_8BIT;
