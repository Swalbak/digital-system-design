library verilog;
use verilog.vl_types.all;
entity CH2_4COMPARE is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        O               : out    vl_logic_vector(2 downto 0)
    );
end CH2_4COMPARE;
