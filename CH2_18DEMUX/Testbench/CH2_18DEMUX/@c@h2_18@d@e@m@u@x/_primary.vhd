library verilog;
use verilog.vl_types.all;
entity CH2_18DEMUX is
    port(
        I               : in     vl_logic;
        S               : in     vl_logic_vector(2 downto 0);
        O               : out    vl_logic_vector(7 downto 0)
    );
end CH2_18DEMUX;
