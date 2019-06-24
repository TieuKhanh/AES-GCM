library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyexpansion is
    port(
        keyin   :   in  std_logic_vector (127 downto 0);
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        counter :   in  std_logic_vector (4 downto 0);
        cnt_aes :   in  std_logic_vector (4 downto 0);
        we      :   in  std_logic;
        keyout  :   out std_logic_vector (127 downto 0)
    );
end entity;

architecture taokey of keyexpansion is

    ---------khai bao tin hieu----------------
    signal keymux,keyin1,k_out                  :   std_logic_vector (127 downto 0);
    signal w0,w1,w2,w3,temp,rotword,data_sbox   :   std_logic_vector (31 downto 0);
    signal key0,key1,key2,key3                  :   std_logic_vector (31 downto 0);
    signal temp_rcon2,datadich,temp_mux         :   std_logic_vector (31 downto 0);
    signal temp_sbox,rcon                       :   std_logic_vector (7 downto 0);
    signal we_dich,enable                       :   std_logic;
    ------------------------------------------

    ---------khai bao component---------------
    component s_box is
        port(
            x : in  std_logic_vector(7 downto 0);
            y : out  std_logic_vector(7 downto 0)
        );
    end component;
    ------------------------------------------

    BEGIN
        K_tinhieuchophep:process(cnt_aes)
            begin
                if cnt_aes = "00000" then
                    we_dich <=  '1';
                else
                    we_dich <=  '0';
                end if;
                if cnt_aes < "00100" then
                    enable  <= '1';
                else
                    enable  <= '0';
                end if;
            end process K_tinhieuchophep;
            
        K_mux:process(we,keyin,keyin1)
            begin
                if we = '1' then
                    keymux  <=  keyin;
                else
                    keymux  <=  keyin1;
                end if;
            end process K_mux;

        w0<=keymux (31 downto 0);
        w1<=keymux (63 downto 32);
        w2<=keymux (95 downto 64);
        w3<=keymux (127 downto 96);

        temp    <=  keymux(31 downto 0);
        rotword<= temp(23 downto 0) & temp (31 downto 24);

        K_muxdich:process(we_dich,rotword,datadich)
            begin
                if we_dich = '1' then
                    temp_mux    <=  rotword;
                else
                    temp_mux    <=  datadich;
                end if;
            end process K_muxdich;

        K_sbox:component s_box
            port map (temp_mux(7 downto 0),temp_sbox);

        K_dich:process(clk,reset)
            begin
                if reset = '1' then
                    datadich    <=  (others => '0');
                elsif clk = '1' and clk'event then
                    if enable = '1' then
                        datadich    <=  temp_sbox & temp_mux(31 downto 8);
                    end if;
                end if;
            end process K_dich;
        data_sbox   <=  datadich;
        
       K_rcon:process(counter)
            begin
                    case counter is
                        when "00000"    =>  rcon <= x"01";
                        when "00001"    =>  rcon <= x"02";
                        when "00010"    =>  rcon <= x"04";
                        when "00011"    =>  rcon <= x"08";
                        when "00100"    =>  rcon <= x"10";
                        when "00101"    =>  rcon <= x"20";
                        when "00110"    =>  rcon <= x"40";
                        when "00111"    =>  rcon <= x"80";
                        when "01000"    =>  rcon <= x"1b";
                        when "01001"    =>  rcon <= x"36";
                        when others     =>  rcon <= x"00";
                    end case;
            end process K_rcon;
        
        temp_rcon2   <=  (data_sbox(31 downto 24) xor rcon) & data_sbox(23 downto 0);

        key0 <= w3 xor temp_rcon2;
        key1 <= w2 xor key0;
        key2 <= w1 xor key1;
        key3 <= w0 xor key2;

        process(clk,reset,cnt_aes)
            begin
                if (reset = '1') then
                    keyin1<=(others => '0');
                elsif clk = '1' and clk'event then
                    if cnt_aes = "00100" then
                        keyin1  <=  key0 & key1 & key2 & key3;
                    end if;
                end if;
            end process;

        process(clk,counter)
            begin
                if clk = '1' and clk'event then
                    if counter = "01010" then
                        k_out   <=  k_out;
                    else
                        k_out   <=  keyin1;
                    end if;
                end if;
            end process;
            
        keyout  <=  k_out;
    END architecture;