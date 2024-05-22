library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.BiglariTypes;

entity comparator is
    port (
        a                : in  BiglariTypes.data_width;
        b                : in  BiglariTypes.data_width;
        a_greater_than_b : out std_logic
    );
end entity;

architecture behaviour of comparator is
begin
    process (a, b)
        variable out_next : std_logic := '0';
    begin
        if (a > b) then
            out_next := '1';
        else
            out_next := '0';
        end if;
        a_greater_than_b <= out_next;
    end process;
end architecture;