library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_affine_transformation is
    port (
        x   :   in  std_logic_vector (7 downto 0);
        y   :   out std_logic_vector (7 downto 0)
    );
end entity;

architecture phong of inv_affine_transformation is
    signal a0,a1,a2,a3,a4,a5,a6,a7  :   std_logic;
    BEGIN
        a7  <=  '0' xor x(6) xor x(4) xor x(1);
        a6  <=  '0' xor x(5) xor x(3) xor x(0);
        a5  <=  '0' xor x(7) xor x(4) xor x(2);
        a4  <=  '0' xor x(6) xor x(3) xor x(1);
        a3  <=  '0' xor x(5) xor x(2) xor x(0);
        a2  <=  '1' xor x(7) xor x(4) xor x(1);
        a1  <=  '0' xor x(6) xor x(3) xor x(0);
        a0  <=  '1' xor x(7) xor x(5) xor x(2);
        y   <=  a7 & a6 & a5 & a4 & a3 & a2 & a1 & a0;
    END architecture;