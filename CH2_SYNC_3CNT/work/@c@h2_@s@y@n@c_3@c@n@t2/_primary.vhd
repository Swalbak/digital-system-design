library verilog;
use verilog.vl_types.all;
entity CH2_SYNC_3CNT2 is
    port(
        RESETN          : in     vl_logic;
        CLK             : in     vl_logic;
        Q               : out    vl_logic_vector(2 downto 0);
        SEG             : out    vl_logic_vector(6 downto 0)
    );
end CH2_SYNC_3CNT2;
