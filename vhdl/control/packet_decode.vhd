library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;

entity packet_decode is
    port (
        packet_code : in  std_logic_vector(31 downto 28);
        packet_type : out BiglariTypes.packet
    );
end entity;

architecture beh of packet_decode is
begin
    with packet_code select packet_type <= BiglariTypes.average_data when x"A",
                                           BiglariTypes.config when x"B",
                                           BiglariTypes.correlation_data when x"C",
                                           BiglariTypes.config when others;
end architecture;