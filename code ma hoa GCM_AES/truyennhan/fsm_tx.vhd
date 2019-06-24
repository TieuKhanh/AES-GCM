library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_tx is
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
end entity;

architecture behavioral of fsm_tx is
------------------------------------
    signal state        :   std_logic_vector (1 downto 0);
    constant idle       :   std_logic_vector (1 downto 0) := "00";
    constant read_fifo  :   std_logic_vector (1 downto 0) := "01";
    constant receiver   :   std_logic_vector (1 downto 0) := "10";
    constant transfer   :   std_logic_vector (1 downto 0) := "11";
------------------------------------
    BEGIN
        process(clk,reset,enable,cnt_bit)
            begin
                if reset = '1' then
                    state       <=  idle;
                    cnt_reset   <=  '1';
                    cnt_enable  <=  '0';
                    data_we     <=  '0';
                    done        <=  '1';
                    fifo_re     <=  '0';
                elsif clk = '1' and clk'event then
                    case state is
                        when idle   =>
                            cnt_reset   <=  '1';
                            cnt_enable  <=  '0';
                            data_we     <=  '0';
                            done        <=  '1';
                            fifo_re     <=  '0';
                            if enable = '1' then
                                state       <=  read_fifo;
                                cnt_reset   <=  '0';
                                cnt_enable  <=  '0';
                                data_we     <=  '0';
                                fifo_re     <=  '1';
                                done        <=  '1';
                            end if;
                        when read_fifo  =>
                            fifo_re <=  '0';
                            done    <=  '1';
                            data_we <=  '1';
                            state   <=  receiver;                            
                        when receiver   =>
                            data_we     <=  '0';
                            done        <=  '0';
                            fifo_re     <=  '0';
                            cnt_reset   <=  '0';
                            cnt_enable  <=  '1';
                            state       <=  transfer;
                        when others =>
                            --done        <=    '0';
                            --fifo_re        <=    '0';
                            --data_we        <=    '0';
                            --cnt_enable    <=    '1';
                            --cnt_reset    <=    '0';
                            if cnt_bit = "1001" then
                                done        <=  '1';
                                fifo_re     <=  '0';
                                cnt_reset   <=  '1';
                                cnt_enable  <=  '0';
                                state       <=  idle;
                            end if;
                    end case;
                end if;
            end process;
    END architecture;
    