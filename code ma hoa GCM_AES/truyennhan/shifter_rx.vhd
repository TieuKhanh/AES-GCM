library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter_rx is
    port (
        reset       :   in  std_logic;
        clk         :   in  std_logic;
        Rx          :   in  std_logic;
        shift_enable:   in  std_logic;
        shift_value :   out std_logic_vector (7 downto 0)
    );
end entity;

architecture tonghop of shifter_rx is
    signal shift_temp   :   std_logic_vector (7 downto 0);
    BEGIN
        process(reset,clk,Rx,shift_enable,shift_temp)
            begin
                if reset = '1' then
                    shift_temp  <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if shift_enable = '1' then
                        shift_temp  <=  Rx & shift_temp(7 downto 1);
                    end if;
                end if;
            end process;
        shift_value <=  shift_temp;
    END architecture;