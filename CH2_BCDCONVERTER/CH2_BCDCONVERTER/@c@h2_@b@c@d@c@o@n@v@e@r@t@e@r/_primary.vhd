library verilog;
use verilog.vl_types.all;
entity CH2_BCDCONVERTER is
    port(
        ONE             : in     vl_logic_vector(3 downto 0);
        TEN             : in     vl_logic_vector(3 downto 0);
        BIN             : out    vl_logic_vector(6 downto 0)
    );
end CH2_BCDCONVERTER;
