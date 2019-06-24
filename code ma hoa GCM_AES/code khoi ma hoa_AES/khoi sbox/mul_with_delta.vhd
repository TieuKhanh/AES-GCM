library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_with_delta is
    port (
        x   :   in  std_logic_vector (7 downto 0);
        y   :   out std_logic_vector (7 downto 0)
    );
end entity;

architecture phong of mul_with_delta is
    signal a0,a1,a2,a3,a4,a5,a6,a7  :   std_logic;
    signal y_out        :   std_logic_vector (7 downto 0);
    BEGIN
        a7      <=  x(7) xor x(5);
        a6      <=  x(7) xor x(6) xor x(4) xor x(3) xor x(2) xor x(1);
        a5      <=  x(7) xor x(5) xor x(3) xor x(2);
        a4      <=  x(7) xor x(5) xor x(3) xor x(2) xor x(1);
        a3      <=  x(7) xor x(6) xor x(2) xor x(1);
        a2      <=  x(7) xor x(4) xor x(3) xor x(2) xor x(1);
        a1      <=  x(6) xor x(4) xor x(1);
        a0      <=  x(6) xor x(1) xor x(0);
        y_out   <=  a7 & a6 & a5 & a4 & a3 & a2 & a1 & a0;
        y   <=  y_out;
    END architecture;