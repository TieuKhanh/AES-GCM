library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier_128 is
    port (
        clk     :   in  std_logic;
        done    :   in  std_logic;
        reset   :   in  std_logic;
        D_in1   :   in  std_logic_vector (127 downto 0);
        D_in2   :   in  std_logic_vector (127 downto 0);
        bao_data:   out std_logic;
        D_out   :   out std_logic_vector (255 downto 0)
    );
end entity;

architecture nhan128x128 of multiplier_128 is
------------------------------------------
    component multiplier_64 is
        port (
            clk     :   in  std_logic;
            done    :   in  std_logic;
            reset   :   in  std_logic;
            D_in1   :   in  std_logic_vector (63 downto 0);
            D_in2   :   in  std_logic_vector (63 downto 0);
            bao_data:   out std_logic;
            D_out   :   out std_logic_vector (127 downto 0)
        );
    end component;
------------------------------------------
    signal  Din_temp1,Din_temp2,Din_temp3,Din_temp4     :   std_logic_vector (63 downto 0);
    signal  Dout1,Dout2,Dout3,Dout4                     :   std_logic_vector (127 downto 0);
    signal  Dout5,Dout6,Dout7                           :   std_logic_vector (127 downto 0);
    signal  bao_dulieu                                  :   std_logic_vector (3 downto 0);
------------------------------------------
    BEGIN
        Din_temp1 <=  D_in1(127 downto 64);
        Din_temp2 <=  D_in1(63 downto 0);
        Din_temp3 <=  D_in2(127 downto 64);
        Din_temp4 <=  D_in2(63 downto 0);
        
        U1: component multiplier_64
            port map (clk,done,reset,Din_temp1,Din_temp3,bao_dulieu(0),Dout1);
        U2: component multiplier_64
            port map (clk,done,reset,Din_temp2,Din_temp4,bao_dulieu(1),Dout2);
        U3: component multiplier_64
            port map (clk,done,reset,Din_temp1,Din_temp4,bao_dulieu(2),Dout3);
        U4: component multiplier_64
            port map (clk,done,reset,Din_temp2,Din_temp3,bao_dulieu(3),Dout4);

        Dout5  <=  Dout1(63 downto 0) & Dout2(127 downto 64);
        Dout6  <=  Dout3 xor Dout4;
        Dout7  <=  Dout5 xor Dout6;
        
        D_out   <=  Dout1(127 downto 64) & Dout7 & Dout2(63 downto 0);
        U5: process (reset,clk,bao_dulieu)
            begin
                if reset = '1' then
                    bao_data    <=  '0';
                elsif clk = '1' and clk'event then
                    bao_data    <=  bao_dulieu(0) and bao_dulieu(1) and bao_dulieu(2) and bao_dulieu(3);
                end if;
            end process U5;
    END architecture;