library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.BiglariTypes;
use work.MuxConstants;
use work.NocConstants;

entity noc_output_stage is
    port (
        clock          : in  std_logic;
        reset          : in  std_logic;
        enable         : in  std_logic;
        max_value      : in  BiglariTypes.data_width;
        min_value      : in  BiglariTypes.data_width;
        counter_value  : in  BiglariTypes.counter_width;
        message_select : in  MuxConstants.message_select_width;
        message_out    : out ZoranTypes.tdma_min_data
    );
end entity;

architecture rtl of noc_output_stage is
    signal min_max_message                   : ZoranTypes.tdma_min_data;
    signal buffered_min_max_message          : ZoranTypes.tdma_min_data;

    signal peak_information_message          : ZoranTypes.tdma_min_data;
    signal buffered_peak_information_message : ZoranTypes.tdma_min_data;
begin

    with message_select
    select message_out <= x"00000000" when MuxConstants.no_message,
                          buffered_min_max_message when MuxConstants.min_max_message,
                          buffered_peak_information_message when MuxConstants.peak_info_message,
                          x"00000000" when others;

    min_max_message <= NocConstants.min_max_message_code & x"0" & max_value & min_value;
    min_max_message_buffer : entity work.register_buffer
        generic map(
            width => 32
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => min_max_message,
            data_out     => buffered_min_max_message
        );

    peak_information_message <= NocConstants.peak_info_message_code & std_logic_vector(counter_value);

    peak_information_message_buffer : entity work.register_buffer
        generic map(
            width => 32
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => peak_information_message,
            data_out     => buffered_peak_information_message
        );

end architecture;