library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity receiver_uart is
    port (
        clk16   :   in  std_logic;
        reset   :   in  std_logic;
        rx      :   in  std_logic;
        data_out:   out std_logic_vector (7 downto 0);
        done    :   out std_logic
    );
end entity;

architecture behavioral of receiver_uart is
-------------------------------------------
    component counter is
        port (
            clk     :   in std_logic;
            reset   :   in std_logic;
            enable  :   in std_logic;
            cnt     :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component shifter_rx is
        port(
            reset       :   in  std_logic;
            clk         :   in  std_logic;
            Rx          :   in  std_logic;
            shift_enable:   in  std_logic;
            shift_value :   out std_logic_vector (7 downto 0)
        );
    end component;
    
    component fsm_rx is
        port(
            clk16           :   in  std_logic;
            reset           :   in  std_logic;
            rx              :   in  std_logic;
            cnt16           :   in  std_logic_vector (3 downto 0);
            cnt_bit         :   in  std_logic_vector (3 downto 0);
            cnt16_reset     :   out std_logic;
            cnt16_enable    :   out std_logic;
            cnt_bit_reset   :   out std_logic;
            cnt_bit_enable  :   out std_logic;
            shift_enable    :   out std_logic;
            data_reg_we     :   out std_logic
        );
    end component;
-------------------------------------------
    signal cnt16            :   std_logic_vector (3 downto 0);
    signal cnt_bit          :   std_logic_vector (3 downto 0);
    signal data_out_temp    :   std_logic_vector (7 downto 0);

    signal cnt16_enable     :   std_logic;
    signal cnt16_reset      :   std_logic;
    signal cnt_bit_reset    :   std_logic;
    signal cnt_bit_enable   :   std_logic;
    signal shift_enable     :   std_logic;
-------------------------------------------
    BEGIN
        K_cntbit:component counter
           port map (clk16,cnt16_reset,cnt16_enable,cnt16);
        K_cnt16:component counter
            port map (clk16,cnt_bit_reset,cnt_bit_enable,cnt_bit);
        K_shift_rx:component shifter_rx 
            port map (reset,clk16,rx,shift_enable,data_out_temp);
        K_fsm:component fsm_rx
            port map (clk16,reset,rx,cnt16,cnt_bit,cnt16_reset,cnt16_enable,
                        cnt_bit_reset,cnt_bit_enable,shift_enable,done);
        data_out    <=  data_out_temp;
    END architecture;