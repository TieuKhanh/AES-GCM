library IEEE;
use    IEEE.STD_LOGIC_1164.ALL;
use    IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AES is
    port (
        clk16            :    in std_logic;
        reset        :    in std_logic;
        fifo_empty    :    in std_logic;
        datain        :    in std_logic_vector (127 downto 0);
        fifo_re        :    inout std_logic;
        dataout        :    out std_logic_vector (127 downto 0);
        done        :    out std_logic
    );
end entity;

architecture tonghop of AES is
------------------------------    
    component counter_aes is
        port (
            clk        :    in std_logic;
            reset    :    in std_logic;
            enable    :    in std_logic;
            cnt        :    out std_logic_vector (4 downto 0)
        );
    end component;
    
    component fsm_aes is
        port(
            clk                :    in std_logic;
            reset            :    in std_logic;
            fifo_empty        :    in std_logic;
            cnt_aes            :    in std_logic_vector (4 downto 0);
            cnt_temp        :    in std_logic_vector (4 downto 0);
            cnt_aes_enable    :    out std_logic;
            cnt_reset        :    out std_logic;
            cnt_enable        :    out std_logic;
            we_aes            :    out std_logic;
            we_keyexpansion    :    out std_logic;
            we_subbyte        :    out std_logic;
            fifo_re            :    out std_logic;
            bao_dulieu          :   out std_logic;
            chon_dulieu     :   out std_logic;
            done            :    out std_logic
        );
    end component;
------------------------------
    signal cnt_aes,cnt_temp    :    std_logic_vector (4 downto 0);
    signal we_aes,we_subbyte:    std_logic;
    signal cnt_reset,cnt_enable    :    std_logic;
    signal we_keyexpansion    :    std_logic;
    signal cnt_aes_enable    :    std_logic;
    signal done_temp        :    std_logic;
    signal baodulieu,chon_data,we_IV        :   std_logic;
	 signal IV	:	std_logic_Vector (127 downto 0);
------------------------------
    BEGIN
        U0:component counter_aes 
            port map (clk16,cnt_reset,cnt_aes_enable,cnt_aes);
        U1:component counter_aes
            port map (clk16,cnt_reset,cnt_enable,cnt_temp);
        U2:component fsm_aes
            port map (clk16,reset,fifo_empty,cnt_aes,cnt_temp,cnt_aes_enable,
                        cnt_reset,cnt_enable,we_aes,we_keyexpansion,
                        we_subbyte,fifo_re,baodulieu,chon_data,done_temp);
        
        process (done_temp,reset,clk16,chon_data,fifo_re)
            begin
                if reset = '1' then
                    dataout    <=    (others => '0');
						  IV			<= (others => '0');
                elsif clk16 = '1' and clk16'event then
                    if done_temp = '1' and chon_data = '0' then
                        dataout    <= datain;
                    end if;
                    if done_temp = '0' and chon_data = '1' then
                        IV  <=  datain;
							end if;
							if fifo_re = '1' then
								IV	<= IV+1;
						   end if;
							we_IV	<= chon_data;
                end if;
            end process;
        
        process (clk16)
            begin
                if clk16 = '1' and clk16'event then
                    done    <=    done_temp;
                end if;
            end process;
    END architecture;