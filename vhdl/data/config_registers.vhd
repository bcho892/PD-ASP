library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ZoranTypes;
use work.MuxConstants;

entity config_registers is
    port (
        clock         : in  std_logic;
        reset         : in  std_logic;
        enable        : in  std_logic;
        packet        : in  ZoranTypes.tdma_min_data;
        destination   : out std_logic_vector(3 downto 0);
        next_address  : out std_logic_vector(3 downto 0);
        bit_count     : out MuxConstants.bit_select_width;
        config_enable : out std_logic;
        config_reset  : out std_logic
    );
end entity;

architecture rtl of config_registers is

begin
    config_reset <= packet(15);

    destination_config_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => packet(27 downto 24),
            data_out     => destination
        );

    next_config_register : entity work.register_buffer
        generic map(
            width => 4
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => packet(23 downto 20),
            data_out     => next_address
        );

    bit_count_register : entity work.register_buffer
        generic map(
            width => 2
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => packet(19 downto 18),
            data_out     => bit_count
        );

    enable_register : entity work.register_buffer
        generic map(
            width => 1
        )
        port map(
            clock        => clock,
            reset        => reset,
            write_enable => enable,
            data_in      => packet(17 downto 17),
            data_out(0)  => config_enable
        );
end architecture;