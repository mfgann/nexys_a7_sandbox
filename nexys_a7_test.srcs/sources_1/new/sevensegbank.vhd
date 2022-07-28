----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/27/2022 03:05:27 PM
-- Design Name:
-- Module Name: sevensegbank - Behavioral
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


library IEEE;
use IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevensegbank is
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
end sevensegbank;

architecture Behavioral of sevensegbank is
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

    component onehot_gen is
        generic ( width  : integer );
        port (
            clk     : in std_ulogic;
            en      : in std_ulogic;
            rstn    : in std_ulogic;
            o       : out std_ulogic_vector (width-1 downto 0));
    end component;

    component ce_gen is
        generic (
            en_div : integer );
        port (
            clk      : in  std_ulogic;
            rstn     : in  std_ulogic;
            ce       : in  std_ulogic;
            en_out   : out std_ulogic);
    end component;

    signal en_1ms       : std_ulogic;
    signal en_ss        : std_ulogic_vector(digits-1 downto 0);
    signal ca_i         : std_ulogic_vector(digits-1 downto 0);
    signal cb_i         : std_ulogic_vector(digits-1 downto 0);
    signal cc_i         : std_ulogic_vector(digits-1 downto 0);
    signal cd_i         : std_ulogic_vector(digits-1 downto 0);
    signal ce_i         : std_ulogic_vector(digits-1 downto 0);
    signal cf_i         : std_ulogic_vector(digits-1 downto 0);
    signal cg_i         : std_ulogic_vector(digits-1 downto 0);
    signal dpi_i        : std_ulogic_vector(digits-1 downto 0);
    signal dp_i         : std_ulogic_vector(digits-1 downto 0);
    signal val_i        : std_ulogic_vector(4*digits-1 downto 0);
begin

reg_values : process(clk)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            val_i       <= (others => '0');
            dpi_i       <= (others => '0');
        else
            if en = '0' then
                val_i       <= val_i;
                dpi_i       <= dpi_i;
            else
                val_i       <= values;
                dpi_i       <= dpi;
            end if;
        end if;
    end if;
end process reg_values;

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

sevenseg_gen : for ii in 0 to digits-1 generate
    sevenseg_decoder : sevensegdecode
        port map (
            clk  => clk,
            en   => en_ss(ii),
            rstn => rstn,
            val  => val_i(ii*4+3 downto ii*4),
            dpi  => dpi_i(ii),
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

ss_onehot_gen: onehot_gen
    generic map ( width => 8 )
    port map(
        clk     => clk,
        rstn    => rstn,
        en      => en_1ms,
        o       => en_ss
    );

en_1ms_generation: ce_gen
    generic map(
        en_div => clkdiv )
    port map(
        clk     => clk,
        ce      => '1',
        rstn    => rstn,
        en_out  => en_1ms
    );

    an      <= not en_ss;

end Behavioral;
