library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library XilinxCoreLib;

entity khoitruyendulieu is
    port (
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        data_in     :   in  std_logic_vector (127 downto 0);
        e_data_shift:   in  std_logic_vector (1 downto 0);
        we          :   in  std_logic;
        tx          :   out std_logic
    );
end entity;

architecture tonghop of khoitruyendulieu is
-------------------------------------------
    component fifo_128_2 is
        port (
            clk     :   in  std_logic;
            rst     :   in  std_logic;
            din     :   in  std_logic_vector(127 downto 0);
            wr_en   :   in  std_logic;
            rd_en   :   in  std_logic;
            dout    :   out std_logic_vector(127 downto 0);
            full    :   out std_logic;
            empty   :   out std_logic
        );
    end component;
    
    component shifter_tx_8 is
        port(
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            fifo_empty  :   in  std_logic;
            enable      :   in  std_logic;
            e_data_shift:   in  std_logic_vector (1 downto 0);
            datain      :   in  std_logic_vector (127 downto 0);
            fifo_re     :   out std_logic;
            dataout     :   out std_logic_vector (7 downto 0);
            done        :   out std_logic
        );
    end component;
    
    component transfer_uart is
        port(
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            datain  :   in  std_logic_vector (7 downto 0);
            enable  :   in  std_logic;
            tx      :   out std_logic;
            done    :   out std_logic
        );
    end component;
    
    component fifo_8 is
        port (
            clk     :   in  std_logic;
            rst     :   in  std_logic;
            din     :   in  std_logic_vector(7 downto 0);
            wr_en   :   in  std_logic;
            rd_en   :   in  std_logic;
            dout    :   out std_logic_vector(7 downto 0);
            full    :   out std_logic;
            empty   :   out std_logic
        );
    end component;
    
    component clk_div is
        generic (BandDivide:std_logic_vector (7 downto 0) := "10101010");
        port(
            clk     :   in  std_logic;
            clk_16  :   out std_logic
        );
    end component;
-------------------------------------------
    signal data_128                 :   std_logic_vector (127 downto 0);
    signal shift_out                :   std_logic_vector (7 downto 0);
    signal fifo_out                 :   std_logic_vector (7 downto 0);
    signal write_fifo               :   std_logic;
    signal read_fifo                :   std_logic;
    signal empty                    :   std_logic;
    signal full                     :   std_logic;
    signal clk_temp                 :   std_logic;
    signal fifo_re,fifo_full,fifo_e :   std_logic;
-------------------------------------------
    BEGIN
        K_fifo_128: component fifo_128_2
            port map (clk_temp,reset,data_in,we,fifo_re,data_128,fifo_full,fifo_e);
        U0:component shifter_tx_8
            port map (clk_temp,reset,fifo_e,full,e_data_shift,data_128,fifo_re,shift_out,write_fifo);
        U1:component fifo_8
            port map (clk_temp,reset,shift_out,write_fifo,read_fifo,fifo_out,full,empty);
        U2:component transfer_uart
            port map (clk_temp,reset,fifo_out,empty,tx,read_fifo);
        U3:component clk_div 
            generic map (x"07")
            port map (clk,clk_temp);
    END architecture;