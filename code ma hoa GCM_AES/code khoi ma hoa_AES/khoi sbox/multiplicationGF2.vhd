library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplicationGF2 is
    port (
        x   :   in  std_logic_vector (1 downto 0);
        y   :   in  std_logic_vector (1 downto 0);
        z   :   out std_logic_vector (1 downto 0)
    );
end entity;

architecture phong of multiplicationGF2 is
    signal  a1,a2    :   std_logic;
    signal  z_out    :   std_logic_vector (1 downto 0);
    BEGIN
        a1  <=  (x(1) and y(1)) xor (x(0) and y(1)) xor (x(1) and y(0));
        a2  <=  (x(1) and y(1)) xor (x(0) and y(0));
        z_out   <=  a1 & a2;
        z   <=  z_out;
    END architecture;