library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package NocConstants is
    constant average_data_code      : std_logic_vector(3 downto 0) := "1110";
    constant pd_config_code         : std_logic_vector(3 downto 0) := "1010";
    constant correlation_code       : std_logic_vector(3 downto 0) := "1001";

    constant peak_info_message_code : std_logic_vector(3 downto 0) := "1000";
    constant min_max_message_code   : std_logic_vector(3 downto 0) := "1100";
end package;