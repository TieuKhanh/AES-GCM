library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GCM_AES is
    port (
        fifo_empty      :   in  std_logic;
        clk             :   in  std_logic;
        reset           :   in  std_logic;
        data_fifo_128   :   in  std_logic_vector (127 downto 0);
        data_cnt        :   in  std_logic_vector (4 downto 0);
        data_C_T        :   out std_logic_vector (127 downto 0);
        fifo_re         :   out std_logic;
        enable_doc      :   out std_logic_vector (1 downto 0);
        done            :   out std_logic
    );
end entity;

architecture rtl of GCM_AES is
---------------------------------------
    component GCTR_AES is
        port (
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            fifo_empty  :   in  std_logic;
            P           :   in  std_logic_vector (127 downto 0);
            key         :   in  std_logic_vector (127 downto 0);
            inc_IV      :   in  std_logic_vector (127 downto 0);
            dataout     :   out std_logic_vector (127 downto 0);
            bao_dulieu  :   out std_logic;
            done        :   out std_logic
        );
    end component;
    
    component mahoaaes is
        port (
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            fifo_empty  :   in  std_logic;
            data        :   in  std_logic_vector (127 downto 0);
            key         :   in  std_logic_vector (127 downto 0);
            dataout     :   out  std_logic_vector (127 downto 0)
        );
    end component;
    
    component fsm_GCM is
        port (
            fifo_empty  :   in  std_logic;
            clk         :   in  std_logic;
            reset       :   in  std_logic;
            done_ghash  :   in  std_logic_vector (1 downto 0);
            done_aes    :   in  std_logic;
            data_cnt    :   in  std_logic_vector (4 downto 0);
            fifo_GHASH  :   out std_logic;
            done_key_IV :   out std_logic_vector (1 downto 0);
            fifo_re     :   out std_logic
        );
    end component;
    
    component GHASH is
        port (
            Din_x       :   in  std_logic_vector (127 downto 0);
            Din_h       :   in  std_logic_vector (127 downto 0);
            reset       :   in  std_logic;
            clk         :   in  std_logic;
            done_aes    :   in  std_logic;
            bao_dulieu  :   in  std_logic;
            done        :   out std_logic;
            Dout_y      :   out std_logic_vector (127 downto 0)
        );
    end component;

---------------------------------------
    signal  e_shift_256,fifo_re_temp,fifo_GHASH :   std_logic;
    signal  done_aes,bao_dulieu,done_ghash      :   std_logic;
    
    signal  done_key_IV,done_sosanh             :   std_logic_vector (1 downto 0);

    signal  inc_IV,Dout_aes_128,H_data,key      :   std_logic_vector (127 downto 0);
    signal  Dout_ghash,inc_IV_out,D_tag,Data_tag:   std_logic_vector (127 downto 0);
---------------------------------------
    BEGIN
        K_incIV:process(reset,clk,done_key_IV,fifo_re_temp)
            begin
                if reset = '1' then
                    inc_IV  <=  (others => '0');
                    key     <=  (others => '0');
                    Data_tag<=  (others => '0');
                elsif clk = '1' and clk'event then
                    if done_key_IV = "01" then
                        key         <=  data_fifo_128;
                        e_shift_256 <=  '0';
                    elsif done_key_IV = "10" then
                        inc_IV      <=  data_fifo_128;
                        e_shift_256 <=  '1';
                    elsif done_key_IV = "11" then
                        Data_tag    <=  data_fifo_128;
                        e_shift_256 <=  '0';
                    else
                        e_shift_256 <= '0';
                    end if;
                    if fifo_re_temp = '1' then
                        inc_IV  <=  inc_IV + 1;
                    end if;
                end if;
            end process K_incIV;
        K_fsm: component fsm_GCM 
            port map (fifo_empty,clk,reset,done_sosanh,done_aes,data_cnt,fifo_GHASH,done_key_IV,fifo_re_temp);
        fifo_re <=  fifo_re_temp;
        U1: component GCTR_AES
            port map (clk,reset,fifo_GHASH,data_fifo_128,key,inc_IV,data_C_T,bao_dulieu,done_aes);
        U2: component mahoaaes
            port map (clk,reset,e_shift_256,(others => '0'),key,H_data);
        U3: component mahoaaes
            port map (clk,reset,e_shift_256,inc_IV,key,inc_IV_out);
            
        U4: component GHASH 
            port map (data_fifo_128,H_data,reset,clk,done_aes,bao_dulieu,done_ghash,Dout_ghash);
        D_tag   <=  Dout_ghash xor inc_IV_out;
        
        K_sosanh:process (clk,reset,done_ghash)
            begin
                if reset = '1' then
                    done_sosanh <=  "00";
                elsif clk = '1' and clk'event then
                    if done_ghash = '1' then
                        if D_tag = data_tag then
                            done_sosanh <=  "11";
                        else
                            done_sosanh <=  "10";
                        end if;
                    else
                        done_sosanh <=  "00";
                    end if;
                end if;
            end process;
        
        K_tinhieura:process (reset,clk,done_aes)
            begin
                if reset = '1' then
                    done    <=  '0';
                elsif clk = '1' and clk'event then
                    done    <=  done_aes;
                end if;
            end process K_tinhieura;
        enable_doc  <=  done_sosanh;
    END architecture;