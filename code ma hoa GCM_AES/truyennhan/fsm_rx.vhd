library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_rx is
    port (
        clk16           :   in  std_logic;
        reset           :   in  std_logic;
        Rx              :   in  std_logic;
        cnt16           :   in  std_logic_vector (3 downto 0);
        cnt_bit         :   in  std_logic_vector (3 downto 0);
        cnt16_reset     :   out std_logic;
        cnt16_enable    :   out std_logic;
        cnt_bit_reset   :   out std_logic;
        cnt_bit_enable  :   out std_logic;
        shift_enable    :   out std_logic;
        data_reg_We     :   out std_logic
    );
end entity;

architecture behavioral of fsm_rx is
    signal rx_reg           :   std_logic;
    signal state            :   std_logic_vector (1 downto 0);
    constant idle_state     :   std_logic_vector (1 downto 0):= "00";
    constant receive_state  :   std_logic_vector (1 downto 0):= "01"; 
    constant start_state    :   std_logic_vector (1 downto 0):= "10";
    
    BEGIN
        process(clk16,Rx)
            begin
                if (clk16 = '1' and clk16'event) then
                    rx_reg  <=  rx;
                end if;
            end process;
            
        process(clk16,Rx,rx_reg,reset,cnt16,cnt_bit)
            begin
                if reset = '1' then
                    state   <=  idle_state;
                elsif (clk16 = '1' and clk16'event) then
                    case state is
                        when idle_state =>
                            cnt16_reset     <=  '0';
                            cnt_bit_reset   <=  '0';
                            data_reg_We     <=  '0';
                            if rx = '0' and rx_reg = '1' then
                                state       <=  start_state;
                                cnt16_enable<=  '1';
                                cnt16_reset <=  '1';
                            end if;
                        when start_state    =>
                            cnt16_reset <=  '0';
                            if cnt16 = "0101" then
                                if rx = '0' then
                                    cnt16_enable    <=  '1';
                                    cnt16_reset     <=  '1';
                                    cnt_bit_reset   <=  '1';
                                    state           <=  receive_state;
                                else
                                    cnt16_enable    <=  '0';
                                    state           <=  idle_state;
                                end if;
                            end if;
                        when receive_state  =>
                            cnt_bit_reset   <=  '0';
                            cnt16_reset     <=  '0';
                            if cnt16 = "1110" then
                                cnt_bit_enable  <=  '1';
                                shift_enable    <=  '1';
                            else
                                cnt_bit_enable  <=  '0';
                                shift_enable    <=  '0';
                            end if;
                            if cnt_bit = "1000" then
                                data_reg_WE     <=  '1';
                                cnt16_enable    <=  '0';
                                cnt16_reset     <=  '1';
                                cnt_bit_enable  <=  '0';
                                cnt_bit_reset   <=  '1';
                                shift_enable    <=  '0';
                                state           <=  idle_state;
                            end if;
                        when others =>
                            shift_enable    <=  '0';
                            cnt16_enable    <=  '0';
                            cnt_bit_enable  <=  '0';
                            state           <=  idle_state;
                    end case;
                end if;
            end process;
    END architecture;