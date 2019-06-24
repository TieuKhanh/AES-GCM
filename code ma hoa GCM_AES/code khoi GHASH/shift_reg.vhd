library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_reg is
    port (
        D_in    :   in  std_logic_vector (31 downto 0);
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        enable  :   in  std_logic;
        we      :   in  std_logic;
        D_out   :   out std_logic
    );
end entity;

architecture rtl of shift_reg is
    signal mux_temp     :   std_logic_vector (31 downto 0);
    signal reg_temp     :   std_logic_vector (31 downto 0);
    BEGIN
        K_mux:  process (we,D_in,reg_temp)
            begin
                if we = '1' then
                    mux_temp    <=  D_in;
                else
                    mux_temp    <=  reg_temp;
                end if;
            end process K_mux;
            
        K_reg:  process (clk,reset,mux_temp)
            begin
                if reset = '1' then
                    reg_temp    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        reg_temp    <=  mux_temp(30 downto 0) & '0';
                    end if;
                end if;
            end process K_reg;
        
        D_out   <=  mux_temp(31);
    END architecture;