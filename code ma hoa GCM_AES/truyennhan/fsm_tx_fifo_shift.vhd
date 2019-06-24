library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_tx_fifo_shift is
    port(
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        fifo_empty  :   in  std_logic;
        full_fifo   :   in  std_logic;
        cnt         :   in  std_logic_vector (3 downto 0);
        fifo_re     :   out std_logic;
        we_fifo     :   out std_logic;
        cnt_reset   :   out std_logic;
        cnt_enable  :   out std_logic;
        we_mux      :   out std_logic;
        shift_enable:   out std_logic
    );
end entity;

architecture behavioral of fsm_tx_fifo_shift is
-----------------------------------------------
    signal state        :   std_logic_vector(1 downto 0):="00";
    constant idle       :   std_logic_vector(1 downto 0):="00";
    constant shift      :   std_logic_vector(1 downto 0):="01";
    constant receiver   :   std_logic_vector(1 downto 0):="10";
    constant result     :   std_logic_vector(1 downto 0):="11";
------------------------------------------------
    BEGIN
        process(clk,reset,fifo_empty,full_fifo,cnt)
            begin
                if reset = '1' then
                    fifo_re     <=  '0';
                    we_fifo     <=  '0';
                    cnt_reset   <=  '1';
                    cnt_enable  <=  '0';
                    shift_enable<=  '0';
                    we_mux      <=  '0';
                elsif clk = '1' and clk'event then
                    case state is
                        when idle   => 
                            we_fifo     <=  '0';
                            cnt_reset   <=  '1';
                            cnt_enable  <=  '0';
                            shift_enable<=  '0';
                            fifo_re     <=  '0';
                            we_mux      <=  '0';
                            if fifo_empty = '0' then 
                                state       <=  receiver;
                                fifo_re     <=  '1';
                                we_fifo     <=  '0';
                                shift_enable<=  '0';
                            else 
                                state       <=  idle;
                            end if;
                        when receiver   =>
                                fifo_re     <=  '0';
                                we_fifo     <=  '0';
                                we_mux      <=  '1';
                                cnt_reset   <=  '1';
                                cnt_enable  <=  '0';
                                shift_enable<=  '0';
                                state       <=  shift;
                        when shift  =>
                            cnt_reset   <=  '0';
                            if full_fifo = '0' then
                                we_mux      <=  '0';
                                we_fifo     <=  '1';
                                shift_enable<=  '1';
                                cnt_enable  <=  '1';
                                if cnt = "1111" then 
                                    we_fifo     <=  '0';
                                    shift_enable<=  '0';
                                    cnt_enable  <=  '0';
                                    state       <=  result;    
                                end if;    
                            else
                                we_mux      <=  '0';
                                we_fifo     <=  '0';
                                shift_enable<=  '0';
                                cnt_enable  <=  '0';
                                state       <=  shift;
                            end if;
                        when others =>
                            we_fifo <=  '0';
                            state   <=  idle;
                    end case;
                end if;    
            end process;
    END architecture;        