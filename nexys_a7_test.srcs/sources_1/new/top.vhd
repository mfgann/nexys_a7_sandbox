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

    signal en           : std_logic;
    signal en_toggle    : std_logic;
    signal en_ss        : std_logic_vector(7 downto 0);
    signal value        : unsigned(3 downto 0);
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
            if en = '1' then
                en_toggle <= not en_toggle;
            end if;
        end if;
    end if;
end process top_proc;

    -- See if the enable works
    led(15)     <= en_toggle;
    led(14 downto 1) <= (others => '0');

en_generation: ce_gen
    generic map(
        en_div => 100_000 )
    port map(
        clk     => clk,
        rstn    => rstn,
        en_out  => en
    );

ss_gen : for ii in 0 to 7 generate
    ss_ii : sevensegdecode
        port map (
            clk  => clk,
            en   => en_ss(ii),
            rstn => rstn,
            val  => std_logic_vector(value),
            dpi  => '0',
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

    an      <= en_ss;

merge_ss_outs : process(clk, rstn)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            ca      <= '0';
            cb      <= '0';
            cc      <= '0';
            cd      <= '0';
            ce      <= '0';
            cf      <= '0';
            cg      <= '0';
            dp      <= '0';
            en_ss   <= (others => '0');
            value   <= (others => '1');
        else
            ca      <= ca_i(7) or ca_i(6) or ca_i(5) or ca_i(4) or ca_i(3) or ca_i(2) or ca_i(1) or ca_i(0);
            cb      <= cb_i(7) or cb_i(6) or cb_i(5) or cb_i(4) or cb_i(3) or cb_i(2) or cb_i(1) or cb_i(0);
            cc      <= cc_i(7) or cc_i(6) or cc_i(5) or cc_i(4) or cc_i(3) or cc_i(2) or cc_i(1) or cc_i(0);
            cd      <= cd_i(7) or cd_i(6) or cd_i(5) or cd_i(4) or cd_i(3) or cd_i(2) or cd_i(1) or cd_i(0);
            ce      <= ce_i(7) or ce_i(6) or ce_i(5) or ce_i(4) or ce_i(3) or ce_i(2) or ce_i(1) or ce_i(0);
            cf      <= cf_i(7) or cf_i(6) or cf_i(5) or cf_i(4) or cf_i(3) or cf_i(2) or cf_i(1) or cf_i(0);
            cg      <= cg_i(7) or cg_i(6) or cg_i(5) or cg_i(4) or cg_i(3) or cg_i(2) or cg_i(1) or cg_i(0);
            dp      <= dp_i(7) or dp_i(6) or dp_i(5) or dp_i(4) or dp_i(3) or dp_i(2) or dp_i(1) or dp_i(0);
            en_ss(7 downto 1)   <= en_ss(6 downto 0);
            en_ss(0) <= en;
            if en = '1' then
                value   <= value + 1;
            end if;
        end if;
    end if;
end process merge_ss_outs;

end Behavioral;
