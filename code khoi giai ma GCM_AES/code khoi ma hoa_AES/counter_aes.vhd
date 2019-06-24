library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter_aes is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        enable  :   in  std_logic;
        cnt     :   out std_logic_vector (4 downto 0)
    );
end entity;

architecture demvong of counter_aes is
    signal dem  :   std_logic_vector (4 downto 0);
    BEGIN
        process (reset,clk)
            begin
                if reset = '1' then
                    dem <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        if dem = "10000" then
                            dem <=  (others => '0');
                        else
                            dem <=  dem + 1;
                        end if;
                    end if;
                end if;
            end process;
        cnt <=  dem;
    END architecture;