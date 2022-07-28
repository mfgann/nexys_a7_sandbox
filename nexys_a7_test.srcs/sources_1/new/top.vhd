----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/25/2022 02:42:50 PM
-- Design Name:
-- Module Name: top - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library work;
use work.all;

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk          : in  std_ulogic;
           rstn         : in  std_ulogic;
           -- LEDs
           led          : out std_ulogic_vector(15 downto 0);
           -- Switches
           swx          : in  std_ulogic_vector(15 downto 0);
           -- 7-seg display
           ca           : out std_ulogic;
           cb           : out std_ulogic;
           cc           : out std_ulogic;
           cd           : out std_ulogic;
           ce           : out std_ulogic;
           cf           : out std_ulogic;
           cg           : out std_ulogic;
           dp           : out std_ulogic;
           an           : out std_ulogic_vector(7 downto 0);
           -- Directional buttons
           btn_left     : in  std_ulogic;
           btn_right    : in  std_ulogic;
           btn_up       : in  std_ulogic;
           btn_down     : in  std_ulogic;
           btn_select   : in  std_ulogic);
end top;

architecture Behavioral of top is
    component ce_gen is
        generic (
            en_div : integer );
        port (
            clk      : in  std_ulogic;
            rstn     : in  std_ulogic;
            ce       : in  std_ulogic;
            en_out   : out std_ulogic);
    end component;

    component sevensegdecode is
        port ( clk  : in  std_ulogic;
               en   : in  std_ulogic;
               rstn : in  std_ulogic;
               val  : in  std_ulogic_vector (3 downto 0);
               dpi  : in  std_ulogic;
               ca   : out std_ulogic;
               cb   : out std_ulogic;
               cc   : out std_ulogic;
               cd   : out std_ulogic;
               ce   : out std_ulogic;
               cf   : out std_ulogic;
               cg   : out std_ulogic;
               dp   : out std_ulogic
               );
    end component;

    -- component onehot_gen is
    --     generic ( width  : integer );
    --     port (
    --         clk     : in std_ulogic;
    --         en      : in std_ulogic;
    --         rstn    : in std_ulogic;
    --         o       : out std_ulogic_vector (width-1 downto 0));
    -- end component;

    component onehot_decode is
        Generic ( width : integer := 8 );
        Port (  clk     : in  std_ulogic;
                en      : in  std_ulogic;
                rstn    : in  std_ulogic;
                c       : in  std_ulogic_vector(integer(CEIL(LOG2(real(width)))) downto 0);
                o       : out std_ulogic_vector(width-1 downto 0));
    end component;

    -- Type definitions for arrays
    type ss_val_ary is array(natural range <>) of unsigned(3 downto 0);

    -- Signals
    signal values       : ss_val_ary(7 downto 0);
    signal valslv       : std_ulogic_vector(31 downto 0);
    signal en_1ms       : std_ulogic;
    signal en_1s        : std_ulogic;
    signal en_ss        : std_ulogic_vector(7 downto 0);
    signal ca_i         : std_ulogic_vector(7 downto 0);
    signal cb_i         : std_ulogic_vector(7 downto 0);
    signal cc_i         : std_ulogic_vector(7 downto 0);
    signal cd_i         : std_ulogic_vector(7 downto 0);
    signal ce_i         : std_ulogic_vector(7 downto 0);
    signal cf_i         : std_ulogic_vector(7 downto 0);
    signal cg_i         : std_ulogic_vector(7 downto 0);
    signal dp_i         : std_ulogic_vector(7 downto 0);
    signal ledb         : std_ulogic_vector(15 downto 0);
    signal test_o       : std_ulogic_vector(7 downto 0);
    signal test_c       : unsigned(3 downto 0);
begin

led     <= ledb;
top_proc : process(clk, rstn, btn_left, btn_right, btn_down, btn_up, btn_select)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            ledb        <= (others => '0');
        else
            ledb <= swx;
        end if;
    end if;
end process top_proc;


en_1ms_generation: ce_gen
    generic map(
        en_div => 100_000 )
    port map(
        clk     => clk,
        ce      => '1',
        rstn    => rstn,
        en_out  => en_1ms
    );

en_1s_generation: ce_gen
    generic map(
        en_div => 100_000_000 )
    port map(
        clk     => clk,
        ce      => '1',
        rstn    => rstn,
        en_out  => en_1s
    );

ss_gen : for ii in 0 to 7 generate
    ss_decoder : sevensegdecode
        port map (
            clk  => clk,
            en   => en_ss(ii),
            rstn => rstn,
            val  => std_ulogic_vector(values(ii)),
            dpi  => '1',
            ca   => ca_i(ii),
            cb   => cb_i(ii),
            cc   => cc_i(ii),
            cd   => cd_i(ii),
            ce   => ce_i(ii),
            cf   => cf_i(ii),
            cg   => cg_i(ii),
            dp   => dp_i(ii)
        );
end generate;

    an      <= not en_ss;

merge_ss_outs : process(clk, rstn)
    variable i  : integer := 0;
begin
    if rising_edge(clk) then
        if rstn = '0' then
            i       := 0;
            ca      <= '0';
            cb      <= '0';
            cc      <= '0';
            cd      <= '0';
            ce      <= '0';
            cf      <= '0';
            cg      <= '0';
            dp      <= '0';
            -- en_ss   <= (others => '0');
        else
            ca      <= not ca_i(i);
            cb      <= not cb_i(i);
            cc      <= not cc_i(i);
            cd      <= not cd_i(i);
            ce      <= not ce_i(i);
            cf      <= not cf_i(i);
            cg      <= not cg_i(i);
            dp      <= not dp_i(i);
            -- en_ss(7 downto 1)   <= en_ss(6 downto 0);
            -- en_ss(0) <= en;
            if en_1ms = '1' then
                if i >= 7 then
                    i := 0;
                else
                    i := i + 1;
                end if;
            end if;
        end if;
    end if;
end process merge_ss_outs;

-- ss_onehot_gen: onehot_gen
--     generic map ( width => 8 )
--     port map(
--         clk     => clk,
--         rstn    => rstn,
--         en      => en_1ms,
--         o       => en_ss
--     );

oh_decode: onehot_decode
        Generic map ( width => 8 )
        Port map (
            clk     => clk,
            en      => en_1ms,
            rstn    => rstn,
            c       => std_ulogic_vector(test_c),
            o       => en_ss);

oh_count: process(clk)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            test_c      <= "0001";
        else
            if en_1ms = '0' then
                test_c      <= test_c;
            else
                if test_c >= 8 then
                    test_c      <= "0001";
                else
                    test_c      <= test_c + 1;
                end if;
            end if;
        end if;
    end if;
end process oh_count;

values_increment: process (clk)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            values(7) <= x"7";
            values(6) <= x"6";
            values(5) <= x"5";
            values(4) <= x"4";
            values(3) <= x"3";
            values(2) <= x"2";
            values(1) <= x"1";
            values(0) <= x"0";
            valslv    <= (others => '0');
        else
            val_inc_gen : for ix in 0 to 7 loop
                if en_1s = '0' then
                    values(ix) <= values(ix);
                    valslv(ix*4+3 downto ix*4) <= std_ulogic_vector(values(ix));
                else
                    values(ix) <= values(ix) + 1;
                    valslv(ix*4+3 downto ix*4) <= std_ulogic_vector(values(ix) + 1);
                end if;
            end loop;
        end if;
    end if;
end process values_increment;

end Behavioral;
