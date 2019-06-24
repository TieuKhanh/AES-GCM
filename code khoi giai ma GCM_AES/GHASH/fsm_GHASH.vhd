library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_GHASH is
    port (
        reset       :   in  std_logic;
        clk         :   in  std_logic;
        bao_dulieu  :   in  std_logic;
        done_aes    :   in  std_logic;
        done_mul    :   in  std_logic;
        rs          :   out std_logic;
        e_reg       :   out std_logic;
        we          :   out std_logic_vector (1 downto 0);
        done_ghash  :   out std_logic;
        done_fsm    :   out std_logic
    );
end entity;

architecture maytrangthai of fsm_GHASH is
-----------------------------------------
    signal state    :   std_logic_vector (1 downto 0);
    constant idle   :   std_logic_vector (1 downto 0):="00";
    constant TT1    :   std_logic_vector (1 downto 0):="01";
    constant TT2    :   std_logic_vector (1 downto 0):="10";
    constant TT3    :   std_logic_vector (1 downto 0):="11";
-----------------------------------------
    BEGIN
        K_fsm:  process(reset,clk,bao_dulieu,done_aes,done_mul)
            begin
                if reset = '1' then
                    rs          <=  '1';
                    we          <=  "00";
                    done_fsm    <=  '0';
                    done_ghash  <=  '0';
                    e_reg       <=  '0';
                    state       <=  idle;
                elsif clk = '1' and clk'event then
                    case state is
                        when  idle  =>
                            rs          <=  '1';
                            we          <=  "00";
                            done_fsm    <=  '0';
                            done_ghash  <=  '0';
                            if bao_dulieu = '1' then
                                done_ghash  <=  '1';
                                done_fsm    <=  '0';
                                rs          <=  '1';
                                we          <=  "00";
                                state       <=  TT1;
                            end if;
                        when TT1 =>
                            done_ghash  <=  '0';
                            e_reg       <=  '0';
                            done_fsm    <=  '0';
                            rs          <=  '0';
                            we          <=  "00";
                            if bao_dulieu = '0' and done_aes = '1' then
                                done_ghash  <=  '1';
                                done_fsm    <=  '0';
                                rs          <=  '0';
                                e_reg       <=  '1';
                                we          <=  "10";
                                state       <=  TT2;
                            else
                                done_ghash  <=  '0';
                                done_fsm    <=  '0';
                                rs          <=  '0';
                                we          <=  "00";
                                state       <=  TT1;
                            end if;
                        when TT2 =>
                            e_reg   <=  '0';
                            rs  <=  '0';
                            done_ghash  <=  '0';
                            done_fsm    <=  '0';
                            we          <=  "10";
                            if bao_dulieu = '0' and done_aes = '1' then
                                done_ghash  <=  '1';
                                done_fsm    <=  '0';
                                e_reg       <=  '1';
                                rs          <=  '0';
                                we          <=  "10";
                                state       <=  TT2;
                            end if;
                            if bao_dulieu = '1' and done_mul = '1' then
                                done_ghash  <=  '1';
                                e_reg       <=  '1';
                                done_fsm    <=  '0';
                                rs          <=  '0';
                                we          <=  "11";
                                state       <=  TT3;
                            end if;
                        when others =>
                            done_ghash  <=  '0';
                            e_reg       <=  '0';
                            done_fsm    <=  '0';
                            rs          <=  '0';
                            we          <=  "11";
                            if done_mul = '1' then
                                done_fsm    <= '1';
                                done_ghash  <= '0';
                                rs          <= '0';
                                we          <= "01";
                                state       <=  idle;
                            end if;
                    end case;
                end if;
            end process K_fsm;
    END architecture;