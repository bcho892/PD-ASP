library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;
use work.MuxConstants;

entity testbench_control_unit is
end entity;

architecture rtl of testbench_control_unit is

    signal t_clock                         : std_logic;
    signal t_d_slope_changed               : std_logic;
    signal t_d_reset                       : std_logic;
    signal t_d_enable                      : std_logic;
    signal t_d_packet_type                 : BiglariTypes.packet;
    signal t_c_wipe_data_registers         : std_logic;
    signal t_c_write_send_register         : std_logic;
    signal t_c_write_data_buffers          : std_logic;
    signal t_c_message_select              : MuxConstants.message_select_width;
    signal t_c_write_min_max_registers     : std_logic;
    signal t_c_write_correlation_registers : std_logic;
    signal t_c_write_config_registers      : std_logic;
begin
    DUT : entity work.control_unit
        port map(
            clock                         => t_clock,
            d_peak_detected               => t_d_slope_changed,
            d_reset                       => t_d_reset,
            d_enable                      => t_d_enable,
            d_packet_type                 => t_d_packet_type,
            c_wipe_data_registers         => t_c_wipe_data_registers,
            c_write_send_register         => t_c_write_send_register,
            c_write_data_buffers          => t_c_write_data_buffers,
            c_message_select              => t_c_message_select,
            c_write_min_max_registers     => t_c_write_min_max_registers,
            c_write_correlation_registers => t_c_write_correlation_registers,
            c_write_config_registers      => t_c_write_config_registers
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
        t_d_reset         <= '1';
        t_d_enable        <= '0';
        t_d_slope_changed <= '0';
        t_d_packet_type   <= BiglariTypes.invalid;
        wait for 69 ns;

        t_d_reset       <= '0';
        t_d_enable      <= '1';
        t_d_packet_type <= BiglariTypes.config;
        wait until rising_edge(t_clock);
        assert t_c_write_config_registers = '1'
        report "STACK FRAMED - configure packets not working"
            severity error;

        assert t_c_write_correlation_registers = '0'
        report "STACK FRAMED - correlation registers is being written to for configure packets"
            severity error;

        assert t_c_write_min_max_registers = '0'
        report "STACK FRAMED - min max registers are being written to for configure packets"
            severity error;

        t_d_packet_type <= BiglariTypes.average_data;
        wait until rising_edge(t_clock);

        assert t_c_write_config_registers = '0'
        report "STACK FRAMED - configure register is being written to for average data packets"
            severity error;

        assert t_c_write_correlation_registers = '0'
        report "STACK FRAMED - correlation registers is being written to for average data packets"
            severity error;

        assert t_c_write_min_max_registers = '1'
        report "STACK FRAMED - max and min value registers are not being written to when average packets are here"
            severity error;

        t_d_packet_type <= BiglariTypes.correlation_data;
        wait until rising_edge(t_clock);

        assert t_c_write_config_registers = '0'
        report "STACK FRAMED - configure register is being written to for correlation data packets"
            severity error;

        assert t_c_write_correlation_registers = '1'
        report "STACK FRAMED - correlation registers not working on correlation packets"
            severity error;

        assert t_c_write_min_max_registers = '0'
        report "STACK FRAMED - max and min value registers are not being written to when correlation packets are here"
            severity error;

        t_d_slope_changed <= '1';

        wait until rising_edge(t_clock);

        assert t_c_write_data_buffers = '1'
        report "STACK FRAMED - data not being buffered on rising edge detected"
            severity error;

        -- Shouldn't matter if this becomes cleared
        t_d_slope_changed <= '0';

        wait until rising_edge(t_clock);

        assert t_c_message_select = MuxConstants.min_max_message and t_c_write_send_register = '1'
        report "STACK FRAMED - min max message not being sent after rising edge detected"
            severity error;

        wait until rising_edge(t_clock);

        assert t_c_message_select = MuxConstants.peak_info_message and t_c_write_send_register = '1'
        report "STACK FRAMED - peak info message not being sent after rising edge detected"
            severity error;

        assert t_c_wipe_data_registers = '1'
        report "STACK FRAMED - data registers not being wiped after being buffered"
            severity error;

        wait until rising_edge(t_clock);

        assert t_c_message_select = MuxConstants.no_message and t_c_write_send_register = '1'
        report "STACK FRAMED - message not being wiped from NOC after sends"
            severity error;
        wait;
    end process;
end architecture;