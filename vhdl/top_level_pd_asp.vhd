library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.BiglariTypes;
use work.MuxConstants;

entity top_level_pd_asp is

    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        data_in  : in  ZoranTypes.tdma_min_port;
        data_out : out ZoranTypes.tdma_min_port
    );
end entity;

architecture rtl of top_level_pd_asp is
    signal d_peak_detected               : std_logic;
    signal d_enable                      : std_logic;
    signal d_reset                       : std_logic;
    signal d_packet_type                 : BiglariTypes.packet;

    signal d_destination                 : std_logic_vector(3 downto 0);
    signal d_next_address                : std_logic_vector(3 downto 0);
    signal d_padded_next_address         : std_logic_vector(7 downto 0);
    signal d_bit_count                   : MuxConstants.bit_select_width;
    signal d_config_enable               : std_logic;
    signal d_config_reset                : std_logic;

    signal d_is_config                   : std_logic;

    signal d_min_value                   : BiglariTypes.data_width;
    signal d_max_value                   : BiglariTypes.data_width;
    signal d_counter_value               : BiglariTypes.counter_width;
    signal d_truncated_value             : BiglariTypes.data_width;
    signal d_selected_message            : ZoranTypes.tdma_min_data;

    signal c_wipe_data_registers         : std_logic;
    signal c_write_send_register         : std_logic;
    signal c_write_data_buffers          : std_logic;
    signal c_message_select              : MuxConstants.bit_select_width;
    signal c_write_min_max_registers     : std_logic;
    signal c_write_correlation_registers : std_logic;
    -- Experimental
    signal c_write_config_registers      : std_logic;

begin

    with d_packet_type select d_is_config <= '1' when BiglariTypes.config,
                                             '0' when others;
    d_reset               <= (d_config_reset and (d_is_config)) or reset;
    d_enable              <= d_config_enable;
    d_padded_next_address <= "0000" & d_next_address;

    packet_decode : entity work.packet_decode
        port map(
            packet_code => data_in.data(31 downto 28),
            packet_type => d_packet_type
        );

    config_registers : entity work.config_registers
        port map(
            clock         => clock,
            reset         => reset,
            enable        => d_is_config,
            packet        => data_in.data,
            destination   => d_destination,
            next_address  => d_next_address,
            bit_count     => d_bit_count,
            config_enable => d_config_enable,
            config_reset  => d_config_reset
        );

    data_truncation_mux : entity work.bit_truncation
        port map(
            data_in  => data_in.data(11 downto 0),
            sel      => d_bit_count,
            data_out => d_truncated_value
        );

    control_unit : entity work.control_unit
        port map(
            clock                         => clock,
            d_peak_detected               => d_peak_detected,
            d_enable                      => d_config_enable,
            d_reset                       => d_reset,
            d_packet_type                 => d_packet_type,
            c_wipe_data_registers         => c_wipe_data_registers,
            c_write_send_register         => c_write_send_register,
            c_write_data_buffers          => c_write_data_buffers,
            c_message_select              => c_message_select,
            c_write_min_max_registers     => c_write_min_max_registers,
            c_write_correlation_registers => c_write_correlation_registers,
            c_write_config_registers      => c_write_config_registers
        );

    peak_detection : entity work.peak_detection
        port map(
            clock            => clock,
            enable           => c_write_correlation_registers,
            reset            => c_wipe_data_registers,
            data_reset       => d_reset,
            correlation_data => d_truncated_value,
            peak_detected    => d_peak_detected
        );

    counter : entity work.counter
        port map(
            clock    => clock,
            reset    => reset,
            enable   => c_write_correlation_registers,
            data_out => d_counter_value
        );

    min_value_storage : entity work.min_value_storage
        port map(
            clock             => clock,
            reset             => c_wipe_data_registers,
            enable            => c_write_min_max_registers,
            average_data      => d_truncated_value,
            current_min_value => d_min_value
        );

    max_value_storage : entity work.max_value_storage
        port map(
            clock             => clock,
            reset             => c_wipe_data_registers,
            enable            => c_write_min_max_registers,
            average_data      => d_truncated_value,
            current_max_value => d_max_value
        );

    noc_output_stage : entity work.noc_output_stage
        port map(
            clock          => clock,
            reset          => reset,
            enable         => c_write_data_buffers,
            max_value      => d_max_value,
            min_value      => d_min_value,
            counter_value  => d_counter_value,
            message_select => c_message_select,
            message_out    => d_selected_message
        );

    send_buffer : entity work.register_buffer
        generic map(
            width => 40
        )
        port map(
            clock                  => clock,
            reset                  => reset,
            write_enable           => c_write_send_register,
            data_in(39 downto 32)  => d_padded_next_address,
            data_in(31 downto 0)   => d_selected_message,
            data_out(39 downto 32) => data_out.addr,
            data_out(31 downto 0)  => data_out.data
        );

end architecture;