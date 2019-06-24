library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_add_reg is
    port (
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        done    :   in  std_logic;
        D_in1   :   in  std_logic_vector (31 downto 0);
        D_in2   :   in  std_logic_vector (31 downto 0);
        bao_data:   out std_logic;
        D_out   :   out std_logic_vector (63 downto 0)
    );
end entity;

architecture rtl of shift_add_reg is
------------------------------------
    signal we_shift,we  :   std_logic;
    signal mux_temp     :   std_logic_vector (31 downto 0);
    signal reg_temp     :   std_logic_vector (63 downto 0);
    signal temp1,temp2  :   std_logic_vector (63 downto 0);
    signal add_temp     :   std_logic_vector (63 downto 0);
    signal enable,rs_cnt:   std_logic;
    signal cnt          :   std_logic_vector (5 downto 0);
    signal done_fsm     :   std_logic;
------------------------------------
    component shift_reg is
        port (
            D_in    :   in  std_logic_vector (31 downto 0);
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            enable  :   in  std_logic;
            we      :   in  std_logic;
            D_out   :   out std_logic
        );
    end component;
    
    component fsm_shift_add_reg is
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
    end component;
    
    component cnt_shift is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            enable  :   in  std_logic;
            cnt     :   out std_logic_vector (5 downto 0)
        );
    end component;
------------------------------------
    BEGIN
        K_dem:  component cnt_shift
            port map (clk,rs_cnt,enable,cnt);
        
        K_fsm:component fsm_shift_add_reg
            port map (reset,clk,done,cnt,we_shift,enable,rs_cnt,done_fsm);
        
        K_shiftreg: component shift_reg
            port map (D_in2,clk,rs_cnt,enable,we_shift,we);
        
        K_mux:  process(we,D_in1)
            begin
                if we = '1' then
                    mux_temp    <=  D_in1;
                else
                    mux_temp    <=  (others => '0');
                end if;
            end process K_mux;
        
        K_reg:  process(rs_cnt,clk,reg_temp)
            begin
                if rs_cnt = '1' then
                    reg_temp    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        reg_temp    <=  add_temp;
                    end if;
                end if;
            end process K_reg;
        
        temp2   <=  reg_temp(62 downto 0) & '0';
        temp1   <=  x"00000000" & mux_temp;
        add_temp<=  temp1 xor temp2;
        
        process(done_fsm,reset,clk)
            begin
                if reset = '1' then
                    D_out    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if done_fsm = '1' then
                        D_out    <=   reg_temp;
                    end if;
                end if;
            end process;
        bao_data  <=  done_fsm;
    END architecture;