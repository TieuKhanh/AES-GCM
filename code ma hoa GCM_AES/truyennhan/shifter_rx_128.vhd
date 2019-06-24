library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_rx_128 is
    port (
        clk     :   in  std_logic;
        enable  :   in  std_logic;
        reset   :   in  std_logic;
        bitin   :   in  std_logic_vector(7 downto 0);
        dataout :   out std_logic_vector(127 downto 0);
        done    :   out std_logic
    );
end entity;

architecture behavioral of shift_rx_128 is
------------------------------------------
    signal dataout_temp :   std_logic_vector(127 downto 0);
    signal data_out     :   std_logic_vector (127 downto 0);
    signal cnt_temp     :   std_logic_vector(4 downto 0):="00000";
------------------------------------------
    BEGIN
        K_shift:process(clk,enable,reset)
            begin
                if reset = '1' then
                    dataout_temp    <=  (others=>'0');
                elsif clk = '1' and clk'event then 
                    if enable = '1' then
                        dataout_temp<=  dataout_temp(119 downto 0) & bitin;
                        cnt_temp    <=  cnt_temp+1;
                        if cnt_temp = "10000" then 
                            cnt_temp  <=  "00001";
                        end if;
                    end if;
                end if;
            end process;
        
        K_result:process(cnt_temp,dataout_temp,clk)
            begin
                if cnt_temp = "01111" then
                    data_out   <=  dataout_temp;
                    done       <=  '1';
                else
                    done    <=  '0';
                end if;
            end process;
        dataout <=  data_out;
    END architecture;
