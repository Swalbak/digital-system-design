library verilog;
use verilog.vl_types.all;
entity CH2_2MUX is
    port(
        I0              : in     vl_logic;
        I1              : in     vl_logic;
        S               : in     vl_logic;
        Z               : out    vl_logic
    );
end CH2_2MUX;
