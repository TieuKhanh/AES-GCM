library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_with_constGF2 is
    port (
        x   :   in  std_logic_vector (1 downto 0);
        y   :   out std_logic_vector (1 downto 0)
    );
end entity;

architecture phong of mul_with_constGF2 is
    signal  a1,a0   :   std_logic;
    signal  y_out   :   std_logic_vector (1 downto 0);
    BEGIN
        a1      <=  x(1) xor x(0);
        a0      <=  x(1);
        y_out   <=  a1 & a0;
        y       <=  y_out;
    END architecture;