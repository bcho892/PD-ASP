library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.NocConstants;

entity testbench_passthrough is
end entity;

architecture rtl of testbench_passthrough is
    signal t_clock    : std_logic;
    signal t_reset    : std_logic;
    signal t_data_in  : ZoranTypes.mips_tdma_min_port;
    signal t_data_out : ZoranTypes.mips_tdma_min_port;
begin
    top_level_inst : entity work.top_level_pd_asp
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

    process
    begin
        -- enable the PD
        wait until rising_edge(t_clock);
        t_data_in.addr <= x"FF";
        t_data_in.data <= NocConstants.pd_config_code & x"F537FFF";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"F537FFF";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"EEFF00D";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"F999999";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"EEEEEEE";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"6969696";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.average_data_code & x"9A9A9A9";
        wait until rising_edge(t_clock);
        t_data_in.data <= NocConstants.correlation_code & x"6A9A9A9";
        wait;
    end process;
end architecture;