library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_rx_fifo_shift is
    port(
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        out_shift   :   in  std_logic;
        we_fifo     :   out std_logic
    );
end entity;
architecture behavioral of fsm_rx_fifo_shift is
-----------------------------------------------    
    signal state        :   std_logic;
    constant wait_state :   std_logic:='0';
    constant write_fifo :   std_logic:='1';
-----------------------------------------------
    BEGIN
        process(clk,reset,out_shift)
          begin
            if reset='1' then 
                we_fifo <=  '0';
                state   <=  wait_state;
            elsif clk = '1' and clk'event then
                case state is
                    when wait_state =>--0
                        we_fifo <=  '0';
                        if out_shift='1' then
                            state   <=  write_fifo;
                        end if;    
                    when others=>
                        we_fifo<='0'; 
                        if out_shift='0' then
                            we_fifo <=  '1';
                            state   <=  wait_state;
                        end if;    
                end case;
            end if;
        end process;    
    END architecture;
    