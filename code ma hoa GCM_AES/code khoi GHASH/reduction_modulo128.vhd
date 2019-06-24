library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reduction_modulo128 is
    port (
        D_in    :   in  std_logic_vector (255 downto 0);
        D_out   :   out std_logic_vector (127 downto 0)
    );
end entity;

architecture tonghop of reduction_modulo128 is
----------------------------------------------
    signal A,B,C,D      :   std_logic_vector (63 downto 0);
    signal E,F,G,H,R    :   std_logic_vector (127 downto 0);
    signal x2,x3        :   std_logic_vector (63 downto 0);
----------------------------------------------
    BEGIN
        x3  <=  D_in(255 downto 192);
        x2  <=  D_in(191 downto 128);

        A   <=  x"000000000000000" & "000" & x3(63);
        B   <=  x"000000000000000" & "00" & x3(63 downto 62);
        C   <=  x"00000000000000" & '0' & x3(63 downto 57);
        
        D   <=  x2 xor A xor B xor C;
        R   <=  x3 & D;
        E   <=  R(126 downto 0) & '0';
        F   <=  R(125 downto 0) & "00";
        G   <=  R(120 downto 0) & "0000000";
        H   <=  R xor E xor F xor G;
        
        D_out   <=  H xor D_in(127 downto 0);
    END architecture;