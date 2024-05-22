library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MuxConstants;
use work.BiglariTypes;

entity control_unit is
    port (
        clock                         : in  std_logic;

        -- prefixed with d to indicate coming from data path
        d_peak_detected               : in  std_logic;
        d_enable                      : in  std_logic;
        d_reset                       : in  std_logic;
        d_packet_type                 : in  BiglariTypes.packet;
        -- prefixed with c to indicate control signal
        c_wipe_data_registers         : out std_logic;
        c_write_send_register         : out std_logic;
        c_write_data_buffers          : out std_logic;
        c_message_select              : out MuxConstants.message_select_width;
        c_write_min_max_registers     : out std_logic;
        c_write_correlation_registers : out std_logic;
        c_write_config_registers      : out std_logic
    );
end entity;

architecture rtl of control_unit is
    type state is (waiting, send_min_max_information, send_peak_information);
    signal current_state : state := waiting;
    signal next_state    : state := waiting;

begin

    StateRegister : process (clock, d_reset)
    begin
        if (d_reset = '1') then
            current_state <= waiting;
        elsif rising_edge(clock) then
            current_state <= next_state;
        end if;
    end process;

    Logic : process (current_state, d_peak_detected, d_packet_type)

        procedure SetControlSignals (
            constant c_wipe_data_registers_in         : in std_logic;
            constant c_write_send_register_in         : in std_logic;
            constant c_write_data_buffers_in          : in std_logic;
            constant c_message_select_in              : in MuxConstants.message_select_width;
            constant c_write_min_max_registers_in     : in std_logic;
            constant c_write_correlation_registers_in : in std_logic;
            constant c_write_config_registers_in      : in std_logic
        ) is
        begin
            c_wipe_data_registers         <= c_wipe_data_registers_in;
            c_write_send_register         <= c_write_send_register_in;
            c_write_data_buffers          <= c_write_data_buffers_in;
            c_message_select              <= c_message_select_in;
            c_write_min_max_registers     <= c_write_min_max_registers_in;
            c_write_correlation_registers <= c_write_correlation_registers_in;
            c_write_config_registers      <= c_write_config_registers_in;
        end procedure SetControlSignals;
    begin
        if (d_reset = '1') then
            next_state <= waiting;
            SetControlSignals('1', '1', '1', MuxConstants.no_message, '0', '0', '0');
        else
            if (d_enable = '1') then
                -- default is SetControlSignals('0', '0', '0', MuxConstants.no_message, '0', '0', '0');
                case current_state is
                    when waiting =>
                        if d_peak_detected = '1' then
                            next_state <= send_min_max_information;
                            -- Buffer all data
                            SetControlSignals('0', '1', '1', MuxConstants.no_message, '1', '0', '0');
                        else
                            next_state <= waiting;
                            case d_packet_type is
                                when BiglariTypes.config =>
                                    SetControlSignals('0', '1', '0', MuxConstants.no_message, '0', '0', '1');
                                when BiglariTypes.average_data =>
                                    SetControlSignals('0', '1', '0', MuxConstants.no_message, '1', '0', '0');
                                when BiglariTypes.correlation_data =>
                                    SetControlSignals('0', '1', '0', MuxConstants.no_message, '0', '1', '0');
                                when others =>
                                    SetControlSignals('0', '1', '1', MuxConstants.no_message, '0', '0', '0');
                            end case;
                        end if;

                    when send_min_max_information =>
                        next_state <= send_peak_information;
                        -- Send min max information
                        SetControlSignals('0', '1', '0', MuxConstants.min_max_message, '0', '0', '0');

                    when send_peak_information =>
                        next_state <= waiting;
                        -- send peak information and wipe data regs
                        SetControlSignals('1', '1', '0', MuxConstants.peak_info_message, '0', '0', '0');

                    when others =>
                        next_state <= waiting;
                        SetControlSignals('0', '1', '0', MuxConstants.no_message, '0', '0', '0');

                end case;
            else
                next_state <= current_state;
                SetControlSignals('0', '1', '0', MuxConstants.no_message, '0', '0', '0');
            end if;
        end if;
    end process Logic;

end architecture;