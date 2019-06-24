library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter_tx is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        we      :   in  std_logic;
        D       :   in  std_logic_vector (7 downto 0);
        Q       :   out std_logic
    );
end entity;

architecture behavioral of shifter_tx is
----------------------------------------
    signal sh_mux   :   std_logic_vector (9 downto 0);
    signal sh_reg   :   std_logic_vector (9 downto 0);
    signal sh_temp  :   std_logic_vector (9 downto 0);
----------------------------------------
    BEGIN
        sh_temp <=  '1' & sh_reg(9 downto 1);
        U0:process(we,sh_temp,D)
            begin
                if we = '1' then
                    sh_mux  <=  '1' & D & '0';
                else
                    sh_mux  <=  sh_temp;
                end if;
            end process;
        U1:process(reset,clk,sh_mux)
            begin
                if reset = '1' then
                    sh_reg  <=  (others    => '0');
                elsif clk = '1' and clk'event then
                    sh_reg  <=  sh_mux;
                end if;
            end process;
        Q   <=  sh_reg(0);
    END architecture;