-- CREDIT BIGLARI-ABHARI
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_buffer is
    generic (
        width         : integer range 0 to 40;
        default_value : std_logic := '0'
    );
    port (
        clock        : in  std_logic;
        reset        : in  std_logic;
        write_enable : in  std_logic;

        data_in      : in  std_logic_vector(width - 1 downto 0);
        data_out     : out std_logic_vector(width - 1 downto 0)
    );
end register_buffer;

architecture arch of register_buffer is

    signal next_data : std_logic_vector(width - 1 downto 0) := (others => default_value);

begin

    process (clock, reset)
    begin
        if reset = '1' then
            next_data <= (others => default_value);
        elsif rising_edge(clock) then
            if write_enable = '1' then
                next_data <= data_in;
            end if;
        end if;
    end process;

    data_out <= next_data;

end architecture; -- arch