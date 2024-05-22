library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity counter is
    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        enable   : in  std_logic;
        data_out : out BiglariTypes.counter_width
    );
end entity;

architecture rtl of counter is
begin
    process (clock)
        variable next_value : BiglariTypes.counter_width := (others => '0');
    begin
        if reset = '1' then
            next_value := (others => '0');
        elsif rising_edge(clock) then
            if (enable = '1') then
                next_value := next_value + 1;
            else
                next_value := next_value;
            end if;
        end if;
        data_out <= next_value;
    end process;
end architecture;