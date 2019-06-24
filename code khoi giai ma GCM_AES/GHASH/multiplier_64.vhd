library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier_64 is
    port (
        clk     :   in  std_logic;
        done    :   in  std_logic;
        reset   :   in  std_logic;
        D_in1   :   in  std_logic_vector (63 downto 0);
        D_in2   :   in  std_logic_vector (63 downto 0);
        bao_data:   out std_logic;
        D_out   :   out std_logic_vector (127 downto 0)
    );
end entity;

architecture nhan64x64 of multiplier_64 is
------------------------------------------
    component shift_add_reg is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            done    :   in  std_logic;
            D_in1   :   in  std_logic_vector (31 downto 0);
            D_in2   :   in  std_logic_vector (31 downto 0);
            bao_data:   out std_logic;
            D_out   :   out std_logic_vector (63 downto 0)
        );
    end component;
------------------------------------------
    signal  D_temp1,D_temp2,D_temp3,D_temp4             :   std_logic_vector (31 downto 0);
    signal  Dout_temp1,Dout_temp2,Dout_temp3,Dout_temp4 :   std_logic_vector (63 downto 0);
    signal  Dout_temp5,Dout_temp6,Dout_temp7            :   std_logic_vector (63 downto 0);
    signal  bao_dulieu                                  :   std_logic_vector (3 downto 0);
------------------------------------------
    BEGIN
        D_temp1 <=  D_in1(63 downto 32);
        D_temp2 <=  D_in1(31 downto 0);
        D_temp3 <=  D_in2(63 downto 32);
        D_temp4 <=  D_in2(31 downto 0);
        
        U1: component shift_add_reg
            port map (clk,reset,done,D_temp1,D_temp3,bao_dulieu(0),Dout_temp1);
        U2: component shift_add_reg
            port map (clk,reset,done,D_temp2,D_temp4,bao_dulieu(1),Dout_temp2);
        U3: component shift_add_reg
            port map (clk,reset,done,D_temp1,D_temp4,bao_dulieu(2),Dout_temp3);
        U4: component shift_add_reg
            port map (clk,reset,done,D_temp2,D_temp3,bao_dulieu(3),Dout_temp4);
        
        Dout_temp5  <=  Dout_temp1(31 downto 0) & Dout_temp2(63 downto 32);
        Dout_temp6  <=  Dout_temp3 xor Dout_temp4;
        Dout_temp7  <=  Dout_temp5 xor Dout_temp6;
        
        D_out   <=  Dout_temp1(63 downto 32) & Dout_temp7 & Dout_temp2(31 downto 0);
        bao_data    <=  bao_dulieu(0) and bao_dulieu(1) and bao_dulieu(2) and bao_dulieu(3);
    END architecture;