library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GHASH is
    port (
        Din_x       :   in  std_logic_vector (127 downto 0);
        Din_h       :   in  std_logic_vector (127 downto 0);
        Din_len_A_C :   in  std_logic_vector (127 downto 0);
        reset       :   in  std_logic;
        clk         :   in  std_logic;
        done_aes    :   in  std_logic;
        bao_dulieu  :   in  std_logic;
        done        :   out std_logic;
        Dout_y      :   out std_logic_vector (127 downto 0)
    );
end entity;

architecture tonghop of GHASH is
--------------------------------
    signal Din_256                  :   std_logic_vector (255 downto 0);
    signal Dout_128,Dx_temp,Dh_temp :   std_logic_vector (127 downto 0);
    signal D_reg                    :   std_logic_vector (127 downto 0);
    signal Dout_temp,D_mux          :   std_logic_vector (127 downto 0):=(others =>'0');
    
    signal we                       :   std_logic_vector (1 downto 0);
    
    signal done_mul,rs_cnt,e_reg    :   std_logic;
    signal done_fsm,done_ghash      :   std_logic;
--------------------------------
    component reduction_modulo128 is
        port (
            D_in    :   in  std_logic_vector (255 downto 0);
            D_out   :   out std_logic_vector (127 downto 0)
        );
    end component;
    
    component multiplier_128 is
        port (
            clk     :   in  std_logic;
            done    :   in  std_logic;
            reset   :   in  std_logic;
            D_in1   :   in  std_logic_vector (127 downto 0);
            D_in2   :   in  std_logic_vector (127 downto 0);
            bao_data:   out std_logic;
            D_out   :   out std_logic_vector (255 downto 0)
        );
    end component;
    
    component fsm_GHASH is
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
    end component;
    
    component reflect is
        port (
            x   :   in  std_logic_vector (127 downto 0);
            y   :   out std_logic_vector (127 downto 0)
        );
    end component;
--------------------------------
    BEGIN
        U1: component fsm_GHASH 
            port map (reset,clk,bao_dulieu,done_aes,done_mul,rs_cnt,e_reg,we,done_ghash,done_fsm);
    -----------------------------------------------------------------------
        K_mux:  process(Din_x,we,Dout_temp,Din_len_A_C)
            begin
                if ((we = "00") or (we = "01")) then
                    D_mux   <=  (others => '0');
                elsif we = "10" then
                    D_mux   <=  Dout_temp xor Din_x;
                else
                    D_mux   <=  Dout_temp xor Din_len_A_C;
                end if;
            end process K_mux;
    ------------------------------------------------------------------------
        K_reg:  process(reset,clk,e_reg)
            begin
                if reset = '1' then
                    D_reg   <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if e_reg = '1' then
                        D_reg <= D_mux;
                    end if;
                end if;
            end process K_reg;

        U_K1: component reflect
            port map (D_reg,Dx_temp);
        U_K2: component reflect
            port map (Din_h,Dh_temp);

        U2: component multiplier_128
            port map (clk,done_ghash,rs_cnt,Dx_temp,Dh_temp,done_mul,Din_256);
        U3: component reduction_modulo128
            port map (Din_256,Dout_128);
        
        U_K3: component reflect 
            port map (Dout_128,Dout_temp);
    --------------------------------------------------------------------------
        K_daura:process (done_fsm,reset,clk)
            begin
                if reset = '1' then
                    Dout_y    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if done_fsm = '1' then
                        Dout_y    <=  Dout_temp;
                    end if;
                end if;
            end process K_daura;
            
        K_baocodulieura:process(clk)
            begin
                if clk = '1' and clk'event then
                    done    <=  done_fsm;
                end if;
            end process K_baocodulieura;
    END architecture;