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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk          : in  STD_LOGIC;
           rstn         : in  STD_LOGIC;
           -- LEDs
           led          : out STD_LOGIC_VECTOR(15 downto 0);
           -- 7-seg display
           ca           : out STD_LOGIC;
           cb           : out STD_LOGIC;
           cc           : out STD_LOGIC;
           cd           : out STD_LOGIC;
           ce           : out STD_LOGIC;
           cf           : out STD_LOGIC;
           cg           : out STD_LOGIC;
           dp           : out STD_LOGIC;
           an           : out STD_LOGIC_VECTOR(7 downto 0);
           -- Directional buttons
           btn_left     : in  STD_LOGIC;
           btn_right    : in  STD_LOGIC;
           btn_up       : in  STD_LOGIC;
           btn_down     : in  STD_LOGIC;
           btn_select   : in  STD_LOGIC);
end top;

architecture Behavioral of top is
    component ce_gen is
        generic (
            en_div : integer );
        port (
            clk      : in  STD_LOGIC;
            rstn     : in  STD_LOGIC;
            en_out   : out STD_LOGIC);
    end component;

    component sevensegdecode is
        port ( clk  : in  STD_LOGIC;
               en   : in  STD_LOGIC;
               rstn : in  STD_LOGIC;
               val  : in  STD_LOGIC_VECTOR (3 downto 0);
               dpi  : in  STD_LOGIC;
               ca   : out STD_LOGIC;
               cb   : out STD_LOGIC;
               cc   : out STD_LOGIC;
               cd   : out STD_LOGIC;
               ce   : out STD_LOGIC;
               cf   : out STD_LOGIC;
               cg   : out STD_LOGIC;
               dp   : out STD_LOGIC
               );
    end component;

    component onehot_gen is
        generic ( width  : integer );
        port (
            clk     : in STD_LOGIC;
            en      : in STD_LOGIC;
            rstn    : in STD_LOGIC;
            o       : out STD_LOGIC_VECTOR (width-1 downto 0));
    end component;

    -- Type definitions for arrays
    type ss_val_ary is array(natural range <>) of unsigned(3 downto 0);

    -- Signals
    signal values       : ss_val_ary(7 downto 0);
    signal en_1ms       : std_logic;
    signal en_1s        : std_logic;
    signal en_toggle    : std_logic;
    signal en_ss        : std_logic_vector(7 downto 0);
    signal ca_i         : std_logic_vector(7 downto 0);
    signal cb_i         : std_logic_vector(7 downto 0);
    signal cc_i         : std_logic_vector(7 downto 0);
    signal cd_i         : std_logic_vector(7 downto 0);
    signal ce_i         : std_logic_vector(7 downto 0);
    signal cf_i         : std_logic_vector(7 downto 0);
    signal cg_i         : std_logic_vector(7 downto 0);
    signal dp_i         : std_logic_vector(7 downto 0);
begin


top_proc : process(clk, rstn, btn_left, btn_right, btn_down, btn_up, btn_select)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            led(0)      <= '0';
            en_toggle   <= '1';
        else
            if btn_select = '1' then
                led(0) <= '1';
            else
                led(0) <= '0';
            end if;
            if en_1s = '1' then
                en_toggle <= not en_toggle;
            end if;
        end if;
    end if;
end process top_proc;

    -- See if the enable works
    led(15)     <= en_toggle;
    led(14 downto 1) <= (others => '0');

en_1ms_generation: ce_gen
    generic map(
        en_div => 100_000 )
    port map(
        clk     => clk,
        rstn    => rstn,
        en_out  => en_1ms
    );

en_1s_generation: ce_gen
    generic map(
        en_div => 100_000_000 )
    port map(
        clk     => clk,
        rstn    => rstn,
        en_out  => en_1s
    );

ss_gen : for ii in 0 to 7 generate
    ss_decoder : sevensegdecode
        port map (
            clk  => clk,
            en   => en_ss(ii),
            rstn => rstn,
            val  => std_logic_vector(values(ii)),
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

ss_onehot_gen: onehot_gen
    generic map ( width => 8 )
    port map(
        clk     => clk,
        rstn    => rstn,
        en      => en_1ms,
        o       => en_ss
    );

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
        else
            val_inc_gen : for ix in 0 to 7 loop
                if en_1s = '0' then
                    values(ix) <= values(ix);
                else
                    values(ix) <= values(ix) + 1;
                end if;
            end loop;
        end if;
    end if;
end process values_increment;

end Behavioral;
