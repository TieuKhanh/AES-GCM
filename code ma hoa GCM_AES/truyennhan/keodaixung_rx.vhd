library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keodaixung_rx is
    port(
        clk             :   in  std_logic;
        reset           :   in  std_logic;
        done_aes        :   in  std_logic;
        we_data_shift   :   out std_logic
    );
end entity;

architecture behavioral of keodaixung_rx is
------------------------------------------
    signal cnt          :   std_logic_vector(4 downto 0);
    signal state        :   std_logic;
    constant wait_state :   std_logic:='0';
    constant write_fifo :   std_logic:='1';
------------------------------------------
    BEGIN
        process(clk,reset,done_aes)
            begin
                if reset = '1' then 
                    we_data_shift   <=  '0';
                    cnt             <=  "00000";
                    state           <=  wait_state;
                elsif clk = '1' and clk'event then
                    case state is
                        when wait_state =>--0
                            we_data_shift   <=  '0';
                            cnt             <=  "00000";
                            if done_aes = '1' then
                                we_data_shift   <=  '1'; 
                                state           <=  write_fifo;
                            end if;
                        when others =>
                            we_data_shift   <=  '1'; 
                            cnt             <=  cnt+1;
                            if cnt = "01111" then
                                we_data_shift   <=  '0';
                                state           <=  wait_state;
                            end if;    
                    end case;
                end if;
            end process;    
    END architecture;