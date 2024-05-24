library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity testbench_peak_detection is
end entity;

architecture rtl of testbench_peak_detection is

    signal t_clock            : std_logic;
    signal t_enable           : std_logic               := '1';
    signal t_reset            : std_logic               := '0';
    signal t_data_reset       : std_logic               := '0';
    signal t_correlation_data : BiglariTypes.data_width := x"000";
    signal t_peak_detected    : std_logic;
begin
    peak_detection_inst : entity work.peak_detection
        port map(
            clock            => t_clock,
            enable           => t_enable,
            reset            => t_reset,
            data_reset       => t_data_reset,
            correlation_data => t_correlation_data,
            peak_detected    => t_peak_detected
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

        t_reset <= '1';

        wait until rising_edge(t_clock);

        assert t_peak_detected = '0' report "RESET NOT RESETING" severity error;

        t_reset            <= '0';
        t_correlation_data <= x"069";

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;
        t_correlation_data <= x"069";

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;
        t_correlation_data <= x"420";

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;
        t_correlation_data <= x"666";

        wait until rising_edge(t_clock);
        t_correlation_data <= x"069";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        assert t_peak_detected = '1' report "PEAK NOT DETECTED ON SWITCH" severity error;

        wait until rising_edge(t_clock);
        t_correlation_data <= x"069";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        t_correlation_data <= x"420";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        t_correlation_data <= x"666";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        t_correlation_data <= x"696";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        t_correlation_data <= x"420";
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;

        wait until rising_edge(t_clock);
        assert t_peak_detected = '1' report "PEAK NOT DETECTED ON SWITCH" severity error;
        t_correlation_data <= x"420";

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;
        t_correlation_data <= x"421";
        t_reset            <= '1';

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "PEAK DETECTED WHEN NO SWITCH" severity error;
        t_correlation_data <= x"420";

        wait until rising_edge(t_clock);
        assert t_peak_detected = '0' report "reset not working" severity error;

        wait;

    end process;

end architecture;