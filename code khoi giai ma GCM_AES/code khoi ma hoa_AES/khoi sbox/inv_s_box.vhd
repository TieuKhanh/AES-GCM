library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_s_box is
    port (
        x :   in  std_logic_vector (7 downto 0);
        y:   out std_logic_vector (7 downto 0)
    );
end entity;

architecture phong of inv_s_box is
    
    signal x_delta1,x_out,mul_x,y_out   :   std_logic_vector (7 downto 0);
    signal squar_x,x_lamda,sum_x,inv_x  :   std_logic_vector (3 downto 0);
    signal mul_x1,mul_x2,mul_x3,sum_x1  :   std_logic_vector (3 downto 0);
    
    component squaringGF16 is
        port (
            x   :   in  std_logic_vector (3 downto 0);
            y   :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component mul_with_constGF16 is
        port (
            x   :   in  std_logic_vector (3 downto 0);
            y   :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component multiplicationGF16 is
        port (
            x1  :   in  std_logic_vector (3 downto 0);
            x2  :   in  std_logic_vector (3 downto 0);
            y   :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component mul_invGF16 is
         port (
            x   :   in  std_logic_vector (3 downto 0);
            y   :   out std_logic_vector (3 downto 0)
        );
    end component;
    
    component mul_with_delta is
        port (
            x   :   in  std_logic_vector (7 downto 0);
            y   :   out std_logic_vector (7 downto 0)
        );
    end component;
    
    component inv_mul_with_delta is
        port (
            x   :   in  std_logic_vector (7 downto 0);
            y   :   out std_logic_vector (7 downto 0)
        );
    end component;
    
    component inv_affine_transformation is
        port (
            x   :   in  std_logic_vector (7 downto 0);
            y   :   out std_logic_vector (7 downto 0)
        );
    end component;
    
    BEGIN
        K_inv_affine_transformation: component inv_affine_transformation 
            port map (x,x_out);

        K_nhandelta: component mul_with_delta
            port map (x_out,x_delta1);

        K_binhphuong: component squaringGF16
            port map (x_delta1(7 downto 4),squar_x);
        K_nhanlamda: component mul_with_constGF16
            port map (squar_x,x_lamda);
        
        sum_x   <=  x_delta1(7 downto 4) xor x_delta1(3 downto 0);
        K_nhanGF16: component multiplicationGF16
            port map (sum_x,x_delta1(3 downto 0),mul_x1);
            
        sum_x1  <=  x_lamda xor mul_x1;
        K_nghichdao: component mul_invGF16
            port map (sum_x1,inv_x);
        K_nhanGF16_1: component multiplicationGF16
            port map (x_delta1(7 downto 4),inv_x,mul_x2);
        K_nhanGF16_2: component multiplicationGF16
            port map (inv_x,sum_x,mul_x3);
        
        mul_x   <=  mul_x2 & mul_x3;
        K_nhannghichdaodelta: component inv_mul_with_delta
            port map (mul_x,y_out);
            
        y <=  y_out;
    END architecture;