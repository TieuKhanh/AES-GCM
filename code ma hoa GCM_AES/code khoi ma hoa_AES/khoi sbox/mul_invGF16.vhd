library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_invGF16 is
    port (
        x   :   in  std_logic_vector (3 downto 0);
        y   :   out std_logic_vector (3 downto 0)
    );
end entity;

architecture phong of mul_invGF16 is
    signal  a1,a2,a3,a4 :   std_logic;
    signal  y_out       :   std_logic_vector (3 downto 0);
    BEGIN
        a4      <=  x(3) xor (x(3) and x(2) and x(1)) xor (x(3) and x(0)) xor x(2);
        a3      <=  (x(3) and x(2) and x(1)) xor (x(3) and x(2) and x(0)) xor (x(3) and x(0)) xor x(2) xor (x(2) and x(1));
        a2      <=  x(3) xor (x(3) and x(2) and x(1)) xor (x(3) and x(1) and x(0)) xor x(2) xor (x(2) and x(0)) xor x(1);
        a1      <=  (x(3) and x(2) and x(1)) xor (x(3) and x(2) and x(0)) xor (x(3) and x(1)) xor (x(3) and x(1) and x(0)) 
                    xor (x(3) and x(0)) xor x(2) xor (x(2) and x(1)) xor (x(2) and x(1) and x(0)) xor x(1) xor x(0);
        y_out   <=  a4 & a3 & a2 & a1;
        y       <=  y_out;
    END architecture;