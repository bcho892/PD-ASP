library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package MuxConstants is
    subtype bit_select_width is std_logic_vector(1 downto 0);
    constant bits_12 : bit_select_width := "00";
    constant bits_10 : bit_select_width := "01";
    constant bits_8  : bit_select_width := "10";

    subtype message_select_width is std_logic_vector(1 downto 0);
    constant no_message        : bit_select_width := "00";
    constant min_max_message   : bit_select_width := "01";
    constant peak_info_message : bit_select_width := "10";
end package;