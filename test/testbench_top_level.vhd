library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;

entity testbench_top_level is
end entity;

architecture rtl of testbench_top_level is
    signal t_clock    : std_logic;
    signal t_reset    : std_logic;
    signal t_data_in  : ZoranTypes.tdma_min_port;
    signal t_data_out : ZoranTypes.tdma_min_port;
begin
    top_level_inst : entity work.top_level
        port map(
            clock    => t_clock,
            reset    => t_reset,
            data_in  => t_data_in,
            data_out => t_data_out
        );

    process
    begin
        t_clock <= '1';
        wait for 10 ns;
        t_clock <= '0';
        wait for 10 ns;
    end process;
end architecture;