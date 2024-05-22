library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package BiglariTypes is
    type packet is (config, average_data, correlation_data, invalid);
    constant data_max_width : integer := 11;
    subtype data_width is std_logic_vector(data_max_width downto 0);
    constant counter_max_width : integer := 27;
    subtype counter_data is unsigned(counter_max_width downto 0);
end package;