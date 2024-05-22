library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity testbench_counter is
end entity;

architecture rtl of testbench_counter is

    signal t_clock    : std_logic;
    signal t_reset    : std_logic := '0';
    signal t_enable   : std_logic := '1';
    signal t_data_out : BiglariTypes.counter_width;

begin
    counter_inst : entity work.counter
        port map(
            clock    => t_clock,
            reset    => t_reset,
            enable   => t_enable,
            data_out => t_data_out
        );

    process
    begin
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
    end process;
    process
    begin
        wait for 69 ns;
        t_enable <= '0';
        wait for 69 ns;
        t_enable <= '1';
        wait for 420 ns;
        t_reset <= '1';
        wait for 69 ns;
        t_reset <= '1';
        wait;
    end process;

end architecture;