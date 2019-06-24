library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library XilinxCoreLib;

entity khoinhandulieu is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        Rx      :   in  std_logic;
        dataout :   out std_logic_vector (127 downto 0);
        done    :   out std_logic
    );
end entity;

architecture tonghop of khoinhandulieu is
-----------------------------------------
    component shift_rx_128 is
        port (
            clk     :   in  std_logic;
            enable  :   in  std_logic;
            reset   :   in  std_logic;
            bitin   :   in  std_logic_vector(7 downto 0);
            dataout :   out std_logic_vector(127 downto 0);
            done    :   out std_logic
        );
    end component;
    
    component receiver_uart is
        port (
            clk16       :   in  std_logic;
            reset       :   in  std_logic;
            rx          :   in  std_logic;
            data_out    :   out std_logic_vector (7 downto 0);
            done        :   out std_logic
        );
    end component;
    
    component fifo_128 is
        port (
            clk         :   in  std_logic;
            rst         :   in  std_logic;
            din         :   in  std_logic_vector(127 downto 0);
            wr_en       :   in  std_logic;
            rd_en       :   in  std_logic;
            dout        :   out std_logic_vector(127 downto 0);
            full        :   out std_logic;
            empty       :   out std_logic;
            data_count  :   out std_logic_vector(4 downto 0)
        );
    end component;
    
    component GCM_AES is
        port (
            fifo_empty      :   in  std_logic;
            clk             :   in  std_logic;
            reset           :   in  std_logic;
            data_fifo_128   :   in  std_logic_vector (127 downto 0);
            data_cnt        :   in  std_logic_vector (4 downto 0);
            data_C_T        :   out std_logic_vector (127 downto 0);
            fifo_re         :   out std_logic;
            done            :   out std_logic
        );
    end component;
    
    component fsm_rx_fifo_shift is
        port(
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            out_shift   :   in  std_logic;
            we_fifo     :   out std_logic
        );
    end component;
    
    component keodaixung_rx is
        port(
            clk             :   in  std_logic;
            reset           :   in  std_logic;
            done_aes        :   in  std_logic;
            we_data_shift   :   out std_logic
        );
    end component;
-----------------------------------------
    signal bitin_temp   :   std_logic_vector (7 downto 0);
    signal data_cnt     :   std_logic_vector (4 downto 0);
    signal dataout_shift:   std_logic_vector (127 downto 0);
    signal dataout_fifo :   std_logic_vector (127 downto 0);

    signal fifo_we      :   std_logic;
    signal fifo_re      :   std_logic;
    signal full         :   std_logic;
    signal empty        :   std_logic;
    signal enable_shift :   std_logic;
    signal done_shift   :   std_logic;
    signal we_data_shift:   std_logic;
-----------------------------------------
    BEGIN
        U0:component receiver_uart
            port map (clk,reset,Rx,bitin_temp,enable_shift);
        U1:component shift_rx_128
            port map (clk,enable_shift,reset,bitin_temp,dataout_shift,done_shift);
        U2:component fifo_128
            port map (clk,reset,dataout_shift,fifo_we,fifo_re,dataout_fifo,full,empty,data_cnt);
        U3:component GCM_AES 
            port map (empty,clk,reset,dataout_fifo,data_cnt,dataout,fifo_re,we_data_shift);
        U4:component fsm_rx_fifo_shift 
            port map (clk,reset,done_shift,fifo_we);
        U5:component keodaixung_rx
            port map (clk,reset,we_data_shift,done);
    END architecture;