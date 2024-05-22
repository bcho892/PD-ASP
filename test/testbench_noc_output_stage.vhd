library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.BiglariTypes;
use work.MuxConstants;

entity testbench_noc_output_stage is
end entity;

architecture rtl of testbench_noc_output_stage is

    signal t_clock          : std_logic;
    signal t_reset          : std_logic                         := '0';
    signal t_enable         : std_logic                         := '1';
    signal t_max_value      : BiglariTypes.data_width           := x"696";
    signal t_min_value      : BiglariTypes.data_width           := x"420";
    signal t_counter_value  : BiglariTypes.counter_width        := to_unsigned(69, BiglariTypes.counter_max_width);
    signal t_message_select : MuxConstants.message_select_width := MuxConstants.no_message;
    signal t_message_out    : ZoranTypes.tdma_min_data;
begin
    noc_output_stage_inst : entity work.noc_output_stage
        port map(
            clock          => t_clock,
            reset          => t_reset,
            enable         => t_enable,
            max_value      => t_max_value,
            min_value      => t_min_value,
            counter_value  => t_counter_value,
            message_select => t_message_select,
            message_out    => t_message_out
        );

    process
    begin
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
    end process;

    process
    begin
        -- load values into regs
        wait until rising_edge(t_clock);

        t_message_select <= MuxConstants.min_max_message;
        wait until rising_edge(t_clock);
        assert t_message_out = x"00696420"
        report "STACK FRAMED - max min value message is bad"
            severity error;

        t_message_select <= MuxConstants.peak_info_message;
        wait until rising_edge(t_clock);
        assert t_message_out = x"00000045"
        report "STACK FRAMED - peak info value message is bad"
            severity error;

        t_reset <= '1';
        wait until rising_edge(t_clock);
        assert t_message_out = x"00000000"
        report "STACK FRAMED - reset is bad"
            severity error;
        wait;

    end process;

end architecture;