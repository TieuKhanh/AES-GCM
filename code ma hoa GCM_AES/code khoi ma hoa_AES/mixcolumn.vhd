----------------------------------------------------------------------------------
-- Company: 
-- Engineer:    Nguyen Hong Phong
-- 
-- Create Date:
-- Design Name:    Thuat toan aes
-- Module Name:    mixcolumn
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mixcolumn is
    port (
        Din     :   in  std_logic_vector (31 downto 0);
        Dout    :   out std_logic_vector (31 downto 0)
    );
end entity;

architecture rtl of mixcolumn is
    signal d0,d1,d2,d3  :   std_logic_vector (7 downto 0);
    signal a0,a1,a2,a3  :   std_logic_vector (7 downto 0);
    signal b0,b1,b2,b3  :   std_logic_vector (7 downto 0);

    component xtime is
        port (
            x   :   in  std_logic_vector (7 downto 0);
            y   :   out std_logic_vector (7 downto 0)
        );
    end component;

    BEGIN
        d0  <=  Din(7 downto 0);
        d1  <=  Din(15 downto 8);
        d2  <=  Din(23 downto 16);
        d3  <=  Din(31 downto 24);

        K_xtime1:component xtime
            port map (d0,a0);
        K_xtime2:component xtime
            port map (d1,a1);
        K_xtime3:component xtime
            port map (d2,a2);
        K_xtime4:component xtime
            port map (d3,a3);

        b0  <=  (a3 xor d3) xor d2 xor d1 xor a0;
        b1  <=  d3 xor d2 xor a1 xor (a0 xor d0);
        b2  <=  d3 xor a2 xor (a1 xor d1) xor d0;
        b3  <=  a3 xor (a2 xor d2) xor d1 xor d0;

        Dout   <=  b3 & b2 & b1 & b0;
    END architecture;