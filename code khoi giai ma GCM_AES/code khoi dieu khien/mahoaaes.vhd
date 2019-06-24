library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mahoaaes is
    port (
        clk         :   in  std_logic;
        reset       :   in  std_logic;
        fifo_empty  :   in  std_logic;
        data        :   in  std_logic_vector (127 downto 0);
        key         :   in  std_logic_vector (127 downto 0);
        dataout     :   out  std_logic_vector (127 downto 0)
    );
end entity;

architecture rtl of mahoaaes is
-------------------------------
    component mixcolumn is
        port (
            Din :   in  std_logic_vector (31 downto 0);
            Dout:   out std_logic_vector (31 downto 0)
        );
    end component;
    
    component subbyte is
        port (
            Din     :   in  std_logic_vector (127 downto 0);
            we      :   in  std_logic;
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            Dout    :   out std_logic_vector (127 downto 0)
        );
    end component;
    
    component keyexpansion is
        port (
            keyin   :   in  std_logic_vector (127 downto 0);
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            counter :   in  std_logic_vector (4 downto 0);
            cnt_aes :   in  std_logic_vector (4 downto 0);
            we      :   in  std_logic;
            keyout  :   out std_logic_vector (127 downto 0)
        );
    end component;
    
    component counter_aes is
        port (
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            enable  :   in  std_logic;
            cnt     :   out std_logic_vector (4 downto 0)
        );
    end component;
    
    component fsm_mahoaaes is
        port(
            clk             :   in  std_logic;
            reset           :   in  std_logic;
            fifo_empty      :   in  std_logic;
            cnt_aes         :   in  std_logic_vector (4 downto 0);
            cnt_temp        :   in  std_logic_vector (4 downto 0);
            cnt_aes_enable  :   out std_logic;
            cnt_reset       :   out std_logic;
            cnt_enable      :   out std_logic;
            we_aes          :   out std_logic;
            we_keyexpansion :   out std_logic;
            we_subbyte      :   out std_logic;
            done            :   out std_logic
        );
    end component;
-------------------------------
    signal cnt_aes,cnt_temp                 :   std_logic_vector (4 downto 0);

    signal we_aes,we_subbyte                :   std_logic;
    signal cnt_reset,cnt_enable             :   std_logic;
    signal we_keyexpansion                  :   std_logic;
    signal cnt_aes_enable,done_temp         :   std_logic;
    
    signal datain1,datain2,datamux          :   std_logic_vector (127 downto 0);
    signal data_sbox,data_shr,keyexpin      :   std_logic_vector (127 downto 0);
    signal data_mix,data_out,data_mix_out   :   std_logic_vector (127 downto 0);
-------------------------------
    BEGIN
        U0:component counter_aes 
            port map (clk,cnt_reset,cnt_aes_enable,cnt_aes);
        U1:component counter_aes
            port map (clk,cnt_reset,cnt_enable,cnt_temp);
        U2:component fsm_mahoaaes
            port map (clk,reset,fifo_empty,cnt_aes,cnt_temp,cnt_aes_enable,
                        cnt_reset,cnt_enable,we_aes,we_keyexpansion,we_subbyte,done_temp);
        
    ----------------------thuat toan -----------------
        datain1 <=  data xor key;
        
        K_mux:process(we_aes,datain1,datain2)
            begin
                if we_aes = '1' then
                    datamux <=  datain1;
                else
                    datamux <=  datain2;
                end if;
            end process K_mux;
        
        K_subbyte:component subbyte 
            port map (datamux,we_subbyte,clk,reset,data_sbox);
    
        data_shr(127 downto 96) <= data_sbox(127 downto 120)& data_sbox(87 downto 80)   & data_sbox(47 downto 40)   & data_sbox(7 downto 0);
        data_shr(95 downto 64)  <= data_sbox(95 downto 88)  & data_sbox(55 downto 48)   & data_sbox(15 downto 8)    & data_sbox(103 downto 96);
        data_shr(63 downto 32)  <= data_sbox(63 downto 56)  & data_sbox(23 downto 16)   & data_sbox(111 downto 104) & data_sbox(71 downto 64);
        data_shr(31 downto 0)   <= data_sbox(31 downto 24)  & data_sbox(119 downto 112) & data_sbox(79 downto 72)   & data_sbox(39 downto 32);

        K_vongsinhkhoa:component keyexpansion
                port map (key,clk,reset,cnt_aes,cnt_temp,we_keyexpansion,keyexpin);
        
        -------chon du lieu vao khoi mixcolumn--------------------
        data_mix    <=  data_shr;
        -------ma hoa-------------
        K_mix1:component mixcolumn
            port map (data_mix(127 downto 96),data_mix_out(127 downto 96));
        K_mix2:component mixcolumn
            port map (data_mix(95 downto 64),data_mix_out(95 downto 64));
        K_mix3:component mixcolumn
            port map (data_mix(63 downto 32),data_mix_out(63 downto 32));
        K_mix4:component mixcolumn
            port map (data_mix(31 downto 0),data_mix_out(31 downto 0));
    ---------------------************----------------------------------
        process(reset,clk)
            begin
                if (reset = '1') then
                    datain2 <=  (others => '0');
                elsif clk = '1' and clk'event then
                        if cnt_temp = "01111" then
                            if cnt_aes = "01001" then
                                datain2 <=  data_mix xor keyexpin;
                            else
                                datain2 <=  data_mix_out xor keyexpin;
                            end if;
                        end if;
                end if;
        end process;
        
        process(done_temp,reset,clk)
            begin
                if reset = '1' then
                    data_out    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if done_temp = '1' then
                        data_out    <=  datain2;
                    end if;
                end if;
            end process;

        dataout <=  data_out;
    END architecture;