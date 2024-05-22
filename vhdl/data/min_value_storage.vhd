library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity min_value_storage is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        enable            : in  std_logic;
        average_data      : in  BiglariTypes.data_width;
        current_min_value : out BiglariTypes.data_width
    );
end entity;

architecture rtl of min_value_storage is
    signal registered_min_value : BiglariTypes.data_width;
    signal new_min_value_found  : std_logic;
    signal internal_enable      : std_logic;
begin

    internal_enable   <= enable and new_min_value_found;
    current_min_value <= registered_min_value;

    max_value_comparator : entity work.comparator
        port map(
            a                => registered_min_value,
            b                => average_data,
            a_greater_than_b => new_min_value_found
        );

    register_buffer_inst : entity work.register_buffer
        generic map(
            default_value => '1',
            width         => BiglariTypes.data_max_width
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => internal_enable,
            data_in      => average_data,
            data_out     => registered_min_value
        );

end architecture;