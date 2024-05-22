library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package BiglariTypes is
    type packet is (config, average_data, correlation_data);
    subtype data_max_width is std_logic_vector(11 downto 0);
    constant counter_max_width : integer := 27;
    subtype counter_width is std_logic_vector(counter_max_width downto 0);
end package;