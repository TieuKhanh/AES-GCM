library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity transfer_uart is
    port(
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        datain  :   in  std_logic_vector (7 downto 0);
        enable  :   in  std_logic;
        tx      :   out std_logic;
        done    :   out std_logic
    );
end entity;

architecture behavioral of transfer_uart is
-------------------------------------------
    component counter is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            enable  :   in  std_logic;
            cnt     :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component fsm_tx is
        port(
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            enable      :   in  std_logic; -- lay tu fifo_empty
            cnt_bit     :   in  std_logic_vector (3 downto 0);
            data_we     :   out std_logic;
            cnt_enable  :   out std_logic;
            cnt_reset   :   out std_logic;
            fifo_re     :   out std_logic;
            done        :   out std_logic
        );
    end component;
    
    component shifter_tx is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            we      :   in  std_logic;
            D       :   in  std_logic_vector (7 downto 0);
            Q       :   out std_logic
        );
    end component;
-------------------------------------------
    signal cnt_temp     :   std_logic_vector (3 downto 0);
    signal tx_temp      :   std_logic:='1';

    signal we_temp      :   std_logic;
    signal cnt_enable   :   std_logic;
    signal cnt_reset    :   std_logic;
    signal done_temp    :   std_logic;
    signal fifo_re      :   std_logic;
    signal enable_temp  :   std_logic;
-------------------------------------------
    BEGIN
        U0:component fsm_tx
            port map (clk,reset,enable_temp,cnt_temp,we_temp,cnt_enable,cnt_reset,fifo_re,done_temp);
        U1:component counter
            port map (clk,cnt_reset,cnt_enable,cnt_temp);
        U2:component shifter_tx
            port map (clk,reset,we_temp,datain,tx_temp);
        enable_temp    <=    not enable;
        process(done_temp,tx_temp,clk)
            begin
                if clk = '1' and clk'event then
                    if done_temp = '1' then
                        tx  <=  '1';
                    else
                        tx  <=  tx_temp;
                    end if;
                end if;
            end process;
        done<=  fifo_re;
    END architecture;