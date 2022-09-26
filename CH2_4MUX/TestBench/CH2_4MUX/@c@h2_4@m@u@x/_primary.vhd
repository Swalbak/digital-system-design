library verilog;
use verilog.vl_types.all;
entity CH2_4MUX is
    port(
        I               : in     vl_logic_vector(3 downto 0);
        S               : in     vl_logic_vector(1 downto 0);
        Z               : out    vl_logic
    );
end CH2_4MUX;
