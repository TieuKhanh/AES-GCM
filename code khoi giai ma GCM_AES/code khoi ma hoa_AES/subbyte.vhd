----------------------------------------------------------------------------------
-- Company: 
-- Engineer:    Nguyen Hong Phong
-- 
-- Create Date:
-- Design Name:    Thuat toan aes
-- Module Name:    subbyte - aes
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

entity subbyte is
    port(
        Din     :   in  std_logic_vector (127 downto 0);
        we      :   in  std_logic;
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        Dout    :   out std_logic_vector (127 downto 0)
    );
end entity;

architecture rtl of subbyte is

    signal Din1,Dmux:   std_logic_vector (127 downto 0);
    signal Dsbox    :   std_logic_vector (7 downto 0);

    component s_box is
        port(
            x : in  std_logic_vector(7 downto 0);
            y : out std_logic_vector(7 downto 0)
        );
    end component;

    BEGIN
        K_mux:process(we,Din,Din1)
            begin
                if we = '1' then
                    Dmux    <=  Din;
                else
                    Dmux    <=  Din1;
                end if;
            end process K_mux;

        K_sbox: component s_box
            port map (Dmux(7 downto 0),Dsbox);

        K_dich:process(clk,reset)
            begin
                if (reset = '1') then
                    Din1    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    Din1    <=  Dsbox & Dmux(127 downto 8);
                end if;
            end process K_dich;

        Dout    <=  Din1;
    END architecture;