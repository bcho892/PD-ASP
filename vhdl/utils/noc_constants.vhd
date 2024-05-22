library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package NocConstants is
    constant peak_info_message_code : std_logic_vector(3 downto 0) := "0000";
    constant min_max_message_code   : std_logic_vector(3 downto 0) := "0000";
end package;