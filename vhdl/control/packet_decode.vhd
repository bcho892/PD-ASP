library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;
use work.NocConstants;

entity packet_decode is
    port (
        packet_code : in  std_logic_vector(31 downto 28);
        packet_type : out BiglariTypes.packet
    );
end entity;

architecture beh of packet_decode is
begin
    with packet_code select packet_type <= BiglariTypes.average_data when NocConstants.average_data_code,
                                           BiglariTypes.config when NocConstants.pd_config_code,
                                           BiglariTypes.correlation_data when NocConstants.correlation_code,
                                           BiglariTypes.invalid when others;
end architecture;