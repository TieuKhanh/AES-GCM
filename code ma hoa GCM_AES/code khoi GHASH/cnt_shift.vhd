library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity cnt_shift is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        enable  :   in  std_logic;
        cnt     :   out std_logic_vector (5 downto 0)
    );
end entity;

architecture demvong of cnt_shift is
    signal dem  :   std_logic_vector (5 downto 0);
    BEGIN
        process (reset,clk)
            begin
                if reset = '1' then
                    dem <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        if dem = x"20" then
                            dem <=  (others => '0');
                        else
                            dem <=  dem + 1;
                        end if;
                    end if;
                end if;
            end process;
        cnt <=  dem;
    END architecture;