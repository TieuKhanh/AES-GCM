----------------------------------------------------------------------------------
-- Company: 
-- Engineer:    Nguyen Hong Phong
-- 
-- Create Date:
-- Design Name:    Thuat toan aes
-- Module Name:    may trang thai thuat toan aes - fsm_aes
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_aes is
    port(
        clk             :   in  std_logic;
        reset           :   in  std_logic;
        fifo_empty      :   in  std_logic;
        cnt_aes         :   in  std_logic_vector (4 downto 0);
        cnt_temp        :   in  std_logic_vector (4 downto 0);
        cnt_aes_enable  :   out std_logic;
        cnt_reset       :   out std_logic;
        cnt_enable      :   out std_logic;
        we_aes          :   out std_logic;
        we_keyexpansion :   out std_logic;
        we_subbyte      :   out std_logic;
        fifo_re         :   out std_logic;
        bao_dulieu      :   out std_logic;
        chon_dulieu     :   out std_logic;
        done            :   out std_logic
    );
end entity;

architecture behavioral of fsm_aes is
-------------------------------------    
    signal state            :   std_logic_vector (1 downto 0);
    constant wait_state     :   std_logic_vector (1 downto 0):= "00";
    constant read_fifo      :   std_logic_vector (1 downto 0):= "01";
    constant receiver_state :   std_logic_vector (1 downto 0):= "10";
    constant operator_state :   std_logic_vector (1 downto 0):= "11";
    signal cnt_temp1        :   std_logic_vector (2 downto 0):="000";
-------------------------------------
    BEGIN
        process(clk,reset,fifo_empty,cnt_temp,cnt_aes)
            begin
                if reset = '1' then
                    state           <=  wait_state;
                    fifo_re         <=  '0';
                    cnt_reset       <=  '1';
                    we_aes          <=  '0';
                    we_keyexpansion <=  '0';
                    we_subbyte      <=  '0';
                    cnt_aes_enable  <=  '0';
                    cnt_enable      <=  '0';
                    done            <=  '0';
                    bao_dulieu      <=  '1';
                    chon_dulieu     <=  '0';
                    cnt_temp1       <=  "000";
                elsif clk = '1'  and clk'event then
                    case state is
                        when wait_state =>
                            fifo_re         <=  '0';
                            cnt_reset       <=  '1';
                            we_aes          <=  '0';
                            we_keyexpansion <=  '0';
                            we_subbyte      <=  '0';
                            cnt_aes_enable  <=  '0';
                            cnt_enable      <=  '0';
                            done            <=  '0';
                            chon_dulieu     <=  '0';
                            if fifo_empty = '0' then
                               if cnt_temp1 = "101" then
                                    cnt_temp1    <=  "000";
                                end if;
                                state   <=  read_fifo;
                                fifo_re <=  '1';
                                bao_dulieu <= '0';
                            else 
                                bao_dulieu <= '1';
                            end if;
                        when read_fifo  =>
                            if cnt_temp1 = "000" then
                                cnt_temp1 <= cnt_temp1 + 1;
                                chon_dulieu <=  '1';
                                state   <= wait_state;
                            else
                                cnt_temp1 <= cnt_temp1+1;
                                state   <=  receiver_state;
                            end if;
                            bao_dulieu      <=  '0';
                            fifo_re         <=  '0';
                            done            <=  '0';
                            cnt_reset       <=  '1';
                            cnt_aes_enable  <=  '0';
                            cnt_enable      <=  '0';
                        when receiver_state =>
                            we_aes      <=  '1';
                            we_subbyte  <=  '1';
                            fifo_re         <=  '0';
                            we_keyexpansion <=  '1';
                            cnt_reset       <=  '1';
                            cnt_aes_enable  <=  '1';
                            cnt_enable      <=  '1';
                            state           <=  operator_state;
                        when others =>
                            cnt_reset       <=  '0';
                            we_aes          <=  '0';
                                if cnt_temp = "01111" then
                                    we_subbyte  <=  '1';
                                else
                                    we_subbyte  <=  '0';
                                end if;
                                if cnt_aes = "00000" then
                                    if (cnt_temp = "10000") then
                                        we_keyexpansion <=  '0';
                                    else
                                        we_keyexpansion <=  '1';
                                    end if;
                                else
                                    we_keyexpansion <=  '0';
                                end if;
                                if (cnt_temp = "01111") then
                                    cnt_aes_enable  <=  '1';
                                else
                                    cnt_aes_enable  <=  '0';
                                end if;
                                if cnt_temp    = "10000" then
                                    if cnt_aes = "01001" then
                                        fifo_re     <=  '0';
                                        done        <=  '1';
                                        cnt_enable  <=  '0';
                                        state       <=  wait_state;
                                    end if;
                                else
                                    fifo_re <=  '0';
                                    done    <=  '0';
                                end if;
                    end case;
                end if;
            end process;
    END architecture;