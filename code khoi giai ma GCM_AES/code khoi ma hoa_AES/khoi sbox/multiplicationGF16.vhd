library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplicationGF16 is
    port (
        x1  :   in  std_logic_vector (3 downto 0);
        x2  :   in  std_logic_vector (3 downto 0);
        y   :   out std_logic_vector (3 downto 0)
    );
end entity;

architecture phong of multiplicationGF16 is
    signal x11,x12,x21,x22,x31,x32  :   std_logic_vector (1 downto 0);
    signal nhan1,nhan2,nhan3        :   std_logic_vector (1 downto 0);
    signal a1,a2,a3                 :   std_logic_vector (1 downto 0);
    
    component multiplicationGF2 is
        port (
            x   :   in  std_logic_vector (1 downto 0);
            y   :   in  std_logic_vector (1 downto 0);
            z   :   out std_logic_vector (1 downto 0)
        );
    end component;
    
    component mul_with_constGF2 is
        port (
            x   :   in  std_logic_vector (1 downto 0);
            y   :   out std_logic_vector (1 downto 0)
        );
    end component;
    
    BEGIN
        x11 <=  x1(3 downto 2);
        x12 <=  x2(3 downto 2);
        x21 <=  x1(3 downto 2) xor x1(1 downto 0);
        x22 <=  x2(3 downto 2) xor x2(1 downto 0);
        x31 <=  x1(1 downto 0);
        x32 <=  x2(1 downto 0);
        
        U1:component multiplicationGF2
            port map (x11,x12,nhan1);
        U2:component multiplicationGF2
            port map (x21,x22,nhan2);
        U3:component multiplicationGF2
            port map (x31,x32,nhan3);
        U4:component mul_with_constGF2
            port map (nhan1,a1);
            
        a2  <=  nhan2 xor nhan3;
        a3  <=  nhan3 xor a1;
        y   <=  a2 & a3;
    END architecture;