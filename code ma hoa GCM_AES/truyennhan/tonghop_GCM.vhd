LIBRARY IEEE;
use IEEE.std_logic_1164.all;
---------------------------------
entity tonghop_GCM is
    port(
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        Rx      :   in  std_logic;
        tx      :   out std_logic
    );
end entity;
---------------------------------
ARCHITECTURE phong of tonghop_GCM is
-------------------------------------------
    component khoinhandulieu is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            Rx      :   in  std_logic;
            dataout :   out std_logic_vector (127 downto 0);
            done    :   out std_logic
        );
    end component;
    
    component khoitruyendulieu is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            data_in :   in  std_logic_vector (127 downto 0);
            we      :   in  std_logic;
            tx      :   out std_logic
        );
    end component;
    
    component clk_div is
        generic (BandDivide:std_logic_vector (7 downto 0) := "00000000");
        port(
            clk     :   in  std_logic;
            clk_16  :   out std_logic
        );
    end component;
-------------------------------------------
    signal dataout_aes_temp :   std_logic_vector(127 downto 0);
    signal we_shift         :   std_logic;
    signal clk_temp         :   std_logic;
    signal nreset           :   std_logic;
-------------------------------------------
    BEGIN
        nreset  <=  reset;
        U0:component khoinhandulieu
            port map(clk_temp,nreset,Rx,dataout_aes_temp,we_shift);
        U1:component khoitruyendulieu
            port map(clk_temp,nreset,dataout_aes_temp,we_shift,tx);
        U2:component clk_div
            generic map(x"A2")
            port map(clk,clk_temp);    
    END architecture;