library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.NocConstants;

entity testbench_top_level is
end entity;

architecture rtl of testbench_top_level is
    signal t_clock    : std_logic;
    signal t_reset    : std_logic;
    signal t_data_in  : ZoranTypes.tdma_min_port;
    signal t_data_out : ZoranTypes.tdma_min_port;
begin
    top_level_inst : entity work.top_level
        port map(
            clock    => t_clock,
            reset    => t_reset,
            data_in  => t_data_in,
            data_out => t_data_out
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
        -- enable the PD
        wait until rising_edge(t_clock);
        t_data_in.addr <= x"FF";
        t_data_in.data <= NocConstants.pd_config_code & x"FFFFFFF";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"0000420";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000696";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"0000069";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000069";
        wait until rising_edge(t_clock);
        -- buffering in here
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000699";
        wait on t_data_out.data until t_data_out.data = NocConstants.min_max_message_code & x"0420069" for 1 ns;
        assert t_data_out.data = NocConstants.min_max_message_code & x"0420069"
        report "STACK FRAMED - Min Max Message not sending correct values"
            severity error;

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000042";
        -- weird delta cycle thing going on
        wait on t_data_out.data until t_data_out.data = NocConstants.peak_info_message_code & x"0000001" for 1 ns;
        assert t_data_out.data = NocConstants.peak_info_message_code & x"0000001"
        report "STACK FRAMED - Peak info Message not sending correct values"
            severity error;

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000069";
        wait on t_data_out.data until t_data_out.data = x"00000000" for 1 ns;
        assert t_data_out.data = x"00000000"
        report "STACK FRAMED - NOC message not getting reset"
            severity error;

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"0000D1C";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000666";

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000D1C";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"0000666";

        -- Good because it will not care about avg values that come after a detected peak
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"0000069";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000669";
        -- Took 5 Messages from CORE

        wait until rising_edge(t_clock);
        -- buffering

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000699";
        wait on t_data_out.data until t_data_out.data = NocConstants.min_max_message_code & x"0D1C069" for 1 ns;
        assert t_data_out.data = NocConstants.min_max_message_code & x"0D1C069"
        report "STACK FRAMED - Min Max Message not sending correct values"
            severity error;

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0006C0C";
        -- weird delta cycle thing going on
        wait on t_data_out.data until t_data_out.data = NocConstants.peak_info_message_code & x"0000002" for 1 ns;
        assert t_data_out.data = NocConstants.peak_info_message_code & x"0000005"
        report "STACK FRAMED - Peak info Message not sending correct values"
            severity error;

        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"0000FA7";
        wait on t_data_out.data until t_data_out.data = x"00000000" for 1 ns;
        assert t_data_out.data = x"00000000"
        report "STACK FRAMED - NOC message not getting reset"
            severity error;

        wait;
    end process;
end architecture;