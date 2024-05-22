library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity max_value_storage is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        enable            : in  std_logic;
        average_data      : in  BiglariTypes.data_width;
        current_max_value : out BiglariTypes.data_width
    );
end entity;

architecture rtl of max_value_storage is
    signal registered_max_value : BiglariTypes.data_width;
    signal new_max_value_found  : std_logic;
    signal internal_enable      : std_logic;
begin

    current_max_value <= registered_max_value;
    internal_enable   <= enable and new_max_value_found;
    max_value_comparator : entity work.comparator
        port map(
            a                => average_data,
            b                => registered_max_value,
            a_greater_than_b => new_max_value_found
        );

    max_value_register : entity work.register_buffer
        generic map(
            width => BiglariTypes.data_max_width
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => internal_enable,
            data_in      => average_data,
            data_out     => registered_max_value
        );

end architecture;