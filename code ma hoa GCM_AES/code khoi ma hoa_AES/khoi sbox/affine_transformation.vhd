library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity affine_transformation is
    port (
        x   :   in  std_logic_vector (7 downto 0);
        y   :   out std_logic_vector (7 downto 0)
    );
end entity;

architecture phong of affine_transformation is
    signal a0,a1,a2,a3,a4,a5,a6,a7  :   std_logic;
    signal y_out        :   std_logic_vector (7 downto 0);
    BEGIN
        a7  <=  '0' xor x(7) xor x(6) xor x(5) xor x(4) xor x(3);
        a6  <=  '1' xor x(6) xor x(5) xor x(4) xor x(3) xor x(2);
        a5  <=  '1' xor x(5) xor x(4) xor x(3) xor x(2) xor x(1);
        a4  <=  '0' xor x(4) xor x(3) xor x(2) xor x(1) xor x(0);
        a3  <=  '0' xor x(7) xor x(3) xor x(2) xor x(1) xor x(0);
        a2  <=  '0' xor x(7) xor x(6) xor x(2) xor x(1) xor x(0);
        a1  <=  '1' xor x(7) xor x(6) xor x(5) xor x(1) xor x(0);
        a0  <=  '1' xor x(7) xor x(6) xor x(5) xor x(4) xor x(0);
        y_out   <=  a7 & a6 & a5 & a4 & a3 & a2 & a1 & a0;
        y       <=  y_out;
    END architecture;