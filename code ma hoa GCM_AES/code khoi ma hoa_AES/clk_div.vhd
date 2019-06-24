----------------------------------------------------------------------------------
-- Company: 
-- Engineer:    Nguyen Hong Phong
-- 
-- Create Date:
-- Design Name:    Thuat toan aes
-- Module Name:    clk_div
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
library ieee;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_div is
    generic (BandDivide:std_logic_vector (7 downto 0) := "10101010");
    port(
        clk     : in    std_logic;
        clk_16  : out   std_logic
    );
end       ;

architecture rtl of clk_div is

    signal clk_out: std_logic:='1';
    signal cnt_div: std_logic_vector(7 downto 0):=x"00";
    
    BEGIN
        process(clk, cnt_div) 
            begin
                if clk = '1' and clk'event then
                    if (cnt_div = BandDivide) then
                        cnt_div <=  (others => '0');
                    else
                        cnt_div <=  cnt_div + 1;
                    end if; 
                end if;
            end process;
        process(cnt_div,clk_out,clk) 
            begin
                if clk = '1' and clk'event then
                    if cnt_div = BandDivide then
                        clk_out <=  not clk_out;
                    else
                        clk_out <=  clk_out;
                    end if;
                end if;
            end process;
        clk_16  <=  clk_out;
    END rtl;