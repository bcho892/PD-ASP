library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity peak_detection is
    port (
        clock            : in  std_logic;
        enable           : in  std_logic;
        reset            : in  std_logic;
        correlation_data : in  BiglariTypes.data_width;
        peak_detected    : out std_logic
    );
end entity;

architecture rtl of peak_detection is
    signal previous_correlation    : BiglariTypes.data_width;
    signal previous_positive_slope : std_logic;
    signal current_positive_slope  : std_logic;
begin

    peak_detected <= (previous_positive_slope = '1') and (current_positive_slope = '0');

    previous_correlation_register : entity work.register_buffer
        generic map(
            width => BiglariTypes.data_width
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => correlation_data,
            data_out     => previous_correlation
        );

    previously_increasing_register : entity work.register_buffer
        generic map(
            width => 1
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable and current_positive_slope,
            data_in      => correlation_data,
            data_out     => previous_positive_slope
        );

    comparator_inst : entity work.comparator
        port map(
            a                => correlation_data,
            b                => previous_correlation,
            a_greater_than_b => current_positive_slope
        );

end architecture;