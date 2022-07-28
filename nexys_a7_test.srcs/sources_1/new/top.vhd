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

    component sevensegbank is
        generic ( digits    : integer := 8;
                  clkdiv    : integer := 100_000 );
        Port ( clk      : in  std_ulogic;
               en       : in  std_ulogic;
               rstn     : in  std_ulogic;
               values   : in  std_ulogic_vector (digits*4-1 downto 0);
               dpi      : in  std_ulogic_vector (digits-1 downto 0);
               ca       : out std_ulogic;
               cb       : out std_ulogic;
               cc       : out std_ulogic;
               cd       : out std_ulogic;
               ce       : out std_ulogic;
               cf       : out std_ulogic;
               cg       : out std_ulogic;
               dp       : out std_ulogic;
               an       : out std_ulogic_vector (digits-1 downto 0));
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
    signal en_1s        : std_ulogic;
    signal ledb         : std_ulogic_vector(15 downto 0);

    signal dpi_b        : std_ulogic_vector(7 downto 0) := (others => '0');
    signal ca_b         : std_ulogic;
    signal cb_b         : std_ulogic;
    signal cc_b         : std_ulogic;
    signal cd_b         : std_ulogic;
    signal ce_b         : std_ulogic;
    signal cf_b         : std_ulogic;
    signal cg_b         : std_ulogic;
    signal dp_b         : std_ulogic;
    signal en_b_ss        : std_ulogic_vector(7 downto 0);
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

en_1s_generation: ce_gen
    generic map(
        en_div => 100_000_000 )
    port map(
        clk     => clk,
        ce      => '1',
        rstn    => rstn,
        en_out  => en_1s
    );

    an      <= en_b_ss;

ssbank: sevensegbank
    generic map (
        digits  => 8,
        clkdiv  => 100_000 )
    port map (
        clk     => clk,
        en      => en_1s,
        rstn    => rstn,
        values  => valslv,
        dpi     => dpi_b,
        ca      => ca_b,
        cb      => cb_b,
        cc      => cc_b,
        cd      => cd_b,
        ce      => ce_b,
        cf      => cf_b,
        cg      => cg_b,
        dp      => dp_b,
        an      => en_b_ss);

    ca      <= ca_b;
    cb      <= cb_b;
    cc      <= cc_b;
    cd      <= cd_b;
    ce      <= ce_b;
    cf      <= cf_b;
    cg      <= cg_b;
    dp      <= dp_b;
    an      <= en_b_ss;

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
