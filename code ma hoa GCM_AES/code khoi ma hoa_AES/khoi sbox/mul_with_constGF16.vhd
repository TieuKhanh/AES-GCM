library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_with_constGF16 is
    port (
        x   :   in  std_logic_vector (3 downto 0);
        y   :   out std_logic_vector (3 downto 0)
    );
end entity;

architecture phong of mul_with_constGF16 is
    signal a0,a1,a2,a3  :   std_logic;
    signal y_out        :   std_logic_vector (3 downto 0);
    BEGIN
        a3      <=  x(2) xor x(0);
        a2      <=  x(3) xor x(2) xor x(1) xor x(0);
        a1      <=  x(3);
        a0      <=  x(2);
        y_out   <=  a3 & a2 & a1 & a0;
        y       <=  y_out;
    END architecture;