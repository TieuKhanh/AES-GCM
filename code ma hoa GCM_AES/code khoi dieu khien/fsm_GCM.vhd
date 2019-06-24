library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_GCM is
    port (
        fifo_empty  :   in  std_logic;
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        done_ghash  :   in  std_logic;
        done_aes    :   in  std_logic;
        data_cnt    :   in  std_logic_vector (4 downto 0);
        fifo_GHASH  :   out std_logic;
        done_key_IV :   out std_logic_vector (1 downto 0);
        fifo_re     :   out std_logic
    );
end entity;

architecture rtl of fsm_GCM is
------------------------------
    signal state        :   std_logic_vector(1 downto 0);
    constant idle       :   std_logic_vector(1 downto 0):="00";
    constant state1     :   std_logic_vector(1 downto 0):="01";
    constant state2     :   std_logic_vector(1 downto 0):="10";
    constant wr_state   :   std_logic_vector(1 downto 0):="11";
    signal cnt_temp     :   std_logic_vector(2 downto 0):="000";
    signal done_temp    :   std_logic;
------------------------------
    BEGIN
        process (clk,reset,fifo_empty,done_ghash,data_cnt)
            begin
                if reset = '1' then
                    done_key_IV <=  "00";
                    fifo_re     <=  '0';
                    fifo_GHASH  <=  '1';
                    done_temp   <=  '0';
                    state   <=  idle;
                elsif clk = '1' and clk'event then
                    case state is
                        when idle   =>
                            done_key_IV <=  "00";
                            fifo_re     <=  '0';
                            fifo_GHASH  <=  '1';
                            done_temp   <=  '0';
                            if data_cnt = "00110" then
                                if fifo_empty = '0' then
                                    fifo_re <=  '1';
                                    state   <=  state1;
                                end if;
                            else
                                state   <=  idle;
                            end if;
                        when state1 =>
                            if cnt_temp = "000" then
                                done_key_IV <=  "01";
                                cnt_temp    <=  cnt_temp+1;
                                state       <=  wr_state;
                                fifo_re     <=  '0';
                            elsif cnt_temp = "001" then
                                done_key_IV <=  "10";
                                cnt_temp    <= cnt_temp + 1;
                                state       <= wr_state;
                                fifo_re     <=  '0';
                            else
                                fifo_re     <=  '0';
                                done_key_IV <=  "00";
                                fifo_GHASH  <=  '0';
                                cnt_temp    <=  cnt_temp+1;
                                state       <=  state2;
                            end if;
                            done_temp   <=  '0';
                        when state2 =>
                            fifo_GHASH  <=  '1';
                            if done_aes = '1' then
                                done_temp <= '1';
                                state   <=  state2;
                            end if;
                            if fifo_empty = '0' and done_temp = '1' then
                                fifo_re <=  '1';
                                state   <=  state1;
                            end if;
                            if cnt_temp = "110" then
                                state   <=  wr_state;
                                cnt_temp<=  cnt_temp;
                            end if;
                        when others =>
                            if cnt_temp = "001" then
                                fifo_re <=  '1';
                                state   <=  state1;
                            end if;
                            if cnt_temp = "010" then
                                fifo_re <=  '1';
                                state   <=  state1;
                            end if;
                            if done_GHASH = '1' then
                                state   <=  idle;
                                cnt_temp<=  "000";
                            end if;
                    end case;
                end if;
            end process;
    END architecture;