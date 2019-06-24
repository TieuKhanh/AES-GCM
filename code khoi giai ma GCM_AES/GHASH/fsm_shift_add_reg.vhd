library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_shift_add_reg is
    port (
        reset       :   in  std_logic;
        clk         :   in  std_logic;
        done        :   in  std_logic;
        cnt         :   in  std_logic_vector (5 downto 0);
        we_shift_reg:   out std_logic;
        enable      :   out std_logic;
        rs_cnt      :   out std_logic;
        done_fsm    :   out std_logic
    );
end entity;

architecture maytrangthai of fsm_shift_add_reg is
    signal state    :   std_logic;
    constant idle   :   std_logic:= '0';
    constant start  :   std_logic:= '1';
    BEGIN
        K_fsm:  process(reset,clk,done,cnt)
            begin
                if reset = '1' then
                    we_shift_reg    <=  '0';
                    enable          <=  '0';
                    rs_cnt          <=  '1';
                    done_fsm        <=  '0';
                    state           <=  idle;
                elsif clk = '1' and clk'event then
                    case state is
                        when idle   =>
                            rs_cnt      <=  '1';
                            enable      <=  '0';
                            we_shift_reg<=  '0';
                            done_fsm    <=  '0';
                            if done = '1' then
                                rs_cnt      <=  '0';
                                enable      <=  '1';
                                we_shift_reg<=  '1';
                                state       <=  start;
                            end if;
                        when others =>
                            rs_cnt  <=  '0';
                            enable  <=  '1';
                            we_shift_reg    <=  '0';
                            done_fsm        <=  '0';
                            if cnt = x"1f" then
                                state   <=  idle;
                                done_fsm<=  '1';
                            end if;
                    end case;
                end if;
            end process K_fsm;
    END architecture;