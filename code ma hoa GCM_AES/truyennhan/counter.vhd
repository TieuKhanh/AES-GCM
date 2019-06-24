library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        enable  :   in  std_logic;
        cnt     :   out std_logic_vector (3 downto 0)
    );
end entity;

architecture dem of counter is
    signal dem  :   std_logic_vector (3 downto 0);
    BEGIN
        process(reset,clk)
            begin
                if reset = '1' then
                    dem <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        dem <=  dem + 1 ;
                    else
                        dem <=  dem;
                    end if;
                end if;
            end process;
        cnt <=  dem;
    END architecture;