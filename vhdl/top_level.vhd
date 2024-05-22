library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.BiglariTypes;

entity top_level is

    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        data_in  : in  ZoranTypes.tdma_min_port;
        data_out : out ZoranTypes.tdma_min_port
    );
end entity;

architecture rtl of top_level is
    signal packet_type    : BiglariTypes.packet;
    signal internal_reset : std_logic;
    signal is_config      : std_logic;
begin
    with packet_type select is_config <= '1' when BiglariTypes.config,
                                         '0' when others;

    internal_reset <= (data_in.data(15) and is_config) or reset;

    packet_decode_inst : entity work.packet_decode
        port map(
            packet_code => data_in.data(31 downto 28),
            packet_type => packet_type
        );

    destination_config_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => packet_type = BiglariTypes.config,
            data_in      => data_in.data(27 downto 24),
            data_out     => data_out
        );

    next_config_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => packet_type = BiglariTypes.config,
            data_in      => data_in.data(23 downto 20),
            data_out     => data_out
        );

    bit_count_register : entity work.register_buffer
        generic map(
            width => 2
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => packet_type = BiglariTypes.config,
            data_in      => data_in.data(19 downto 18),
            data_out     => data_out
        );

    enable_register : entity work.register_buffer
        generic map(
            width => 1
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => packet_type = BiglariTypes.config,
            data_in      => data_in.data(17 downto 17),
            data_out     => data_out
        );

    data_truncation_mux : entity work.bit_truncation
        port map(
            data_in  => data_in.data(11 downto 0),
            sel      => sel,
            data_out => data_out
        );

    max_value_comparator : entity work.comparator
        port map(
            a                => a,
            b                => b,
            a_greater_than_b => a_greater_than_b
        );

    min_value_comparator : entity work.comparator
        port map(
            a                => a,
            b                => b,
            a_greater_than_b => a_greater_than_b
        );

    rising_edge_comparator : entity work.comparator
        port map(
            a                => a,
            b                => b,
            a_greater_than_b => a_greater_than_b
        );

end architecture;