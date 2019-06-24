library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter_tx_8 is
    port(
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        fifo_empty  :   in  std_logic;
        enable      :   in  std_logic;
        datain      :   in  std_logic_vector (127 downto 0);
        fifo_re     :   out std_logic;
        dataout     :   out std_logic_vector (7 downto 0);
        done        :   out std_logic
    );
end entity;

architecture behavioral of shifter_tx_8 is
------------------------------------------
    component fsm_tx_fifo_shift is
        port(
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            fifo_empty  :   in  std_logic;
            full_fifo   :   in  std_logic;
            cnt         :   in  std_logic_vector (3 downto 0);
            fifo_re     :   out std_logic;
            we_fifo     :   out std_logic;
            cnt_reset   :   out std_logic;
            cnt_enable  :   out std_logic;
            we_mux      :   out std_logic;
            shift_enable:   out std_logic
        );
    end component;
    
    component counter is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            enable  :   in  std_logic;
            cnt     :   out std_logic_vector (3 downto 0)
        );
    end component;
------------------------------------------
    signal dataout_mux  :   std_logic_vector (127 downto 0);
    signal dataout_reg  :   std_logic_vector (127 downto 0);
    signal dataout_shift:   std_logic_vector (127 downto 0);
    signal cnt_reset    :   std_logic;
    signal cnt_enable   :   std_logic;
    signal shift_enable :   std_logic;
    signal we_mux       :   std_logic;
    signal cnt          :   std_logic_vector (3 downto 0);
------------------------------------------
    BEGIN
        U0:component counter
            port map (clk,cnt_reset,cnt_enable,cnt);
        U1:process(clk,reset,dataout_mux)
            begin
                if reset = '1' then
                    dataout_reg <=  (others => '0');
                elsif clk = '1' and clk'event then
                    dataout_reg <=  dataout_mux;
                end if;
            end process U1;
        U2:component fsm_tx_fifo_shift
            port map (clk,reset,fifo_empty,enable,cnt,fifo_re,done,cnt_reset,
                        cnt_enable,we_mux,shift_enable);
        U3:process(dataout_reg,shift_enable)
            begin
                if shift_enable = '1' then
                    dataout_shift   <=  dataout_reg(119 downto 0) & x"00";
                else 
                    dataout_shift   <=  dataout_reg;
                end if;
            end process U3;
        U4: process(dataout_shift,we_mux,datain)
            begin
                if we_mux = '1' then
                    dataout_mux <=  datain;
                else
                    dataout_mux <=  dataout_shift;
                end if;
            end process;
        dataout <=  dataout_reg (127 downto 120);
    END architecture;