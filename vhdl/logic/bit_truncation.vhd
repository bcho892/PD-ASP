library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.BiglariTypes;
use work.MuxConstants;

entity bit_truncation is
    port (
        data_in  : in  BiglariTypes.data_width := (others => '0');
        sel      : in  MuxConstants.bit_select_width;
        data_out : out BiglariTypes.data_width := (others => '0')
    );
end entity;

architecture behaviour of bit_truncation is
begin
    with sel select data_out <= data_in when MuxConstants.bits_12,
                                "00" & data_in(9 downto 0) when MuxConstants.bits_10,
                                "0000" & data_in(7 downto 0) when MuxConstants.bits_8,
                                data_in when others;
end architecture;