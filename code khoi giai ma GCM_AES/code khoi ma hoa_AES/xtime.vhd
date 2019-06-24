----------------------------------------------------------------------------------
-- Company: 
-- Engineer:    Nguyen Hong Phong
-- 
-- Create Date:
-- Design Name:    Thuat toan aes
-- Module Name:    xtime - aes
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

entity xtime is
    port (
        x   :   in  std_logic_vector (7 downto 0);
        y   :   out std_logic_vector (7 downto 0)
    );
end entity;

architecture thuattoan of xtime is
    signal n    :   std_logic_vector(7 downto 0);

    BEGIN
        process (x)
            begin
                if x(7)='1' then
                    n   <=  (x(6 downto 0) & '0') xor "00011011";
                else
                    n   <=  x(6 downto 0) & '0';
                end if;
            end process;
        y   <=  n;
    END architecture;