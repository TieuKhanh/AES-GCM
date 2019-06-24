library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keodaixung_enable is
    port(
        clk             :   in  std_logic;
        reset           :   in  std_logic;
        enable_doc      :   in  std_logic_vector (1 downto 0);
        we_data_shift   :   out std_logic_vector (1 downto 0)
    );
end entity;

architecture behavioral of keodaixung_enable is
------------------------------------------
    signal cnt          :   std_logic_vector(4 downto 0);
    signal state        :   std_logic;
    constant wait_state :   std_logic:='0';
    constant write_fifo :   std_logic:='1';
------------------------------------------
    BEGIN
        process(clk,reset,enable_doc)
            begin
                if reset = '1' then 
                    we_data_shift   <=  "00";
                    cnt             <=  "00000";
                    state           <=  wait_state;
                elsif clk = '1' and clk'event then
                    case state is
                        when wait_state =>--0
                            we_data_shift   <=  "00";
                            cnt             <=  "00000";
                            if enable_doc = "11" then
                                we_data_shift   <=  "11"; 
                                state           <=  write_fifo;
                            elsif enable_doc = "10" then
                                we_data_shift   <=  "10";
                                state           <=  write_fifo;
                            else
                                state           <=  wait_state;
                            end if;
                        when others => 
                            cnt             <=  cnt+1;
                            if cnt = "01111" then
                                we_data_shift   <=  "00";
                                state           <=  wait_state;
                            end if;    
                    end case;
                end if;
            end process;    
    END architecture;
