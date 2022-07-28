----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/25/2022 03:32:16 PM
-- Design Name:
-- Module Name: nexys_a7_100t_chip - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nexys_a7_100t_chip is
    Port (  CLK100MHZ    : in  std_logic;
            CPU_RESETN   : in  std_logic;

            -- LEDs
            LED          : out std_logic_vector (15 downto 0);

            -- Switches
            SW           : in  std_logic_vector (15 downto 0);

            -- 7-Segment Display
            CA           : out std_logic;
            CB           : out std_logic;
            CC           : out std_logic;
            CD           : out std_logic;
            CE           : out std_logic;
            CF           : out std_logic;
            CG           : out std_logic;
            DP           : out std_logic;
            AN           : out std_logic_vector (7 downto 0);

            -- Directional buttons
            BTNU         : in  std_logic;
            BTND         : in  std_logic;
            BTNL         : in  std_logic;
            BTNR         : in  std_logic;
            BTNC         : in  std_logic);
end nexys_a7_100t_chip;

architecture Behavioral of nexys_a7_100t_chip is
component top is
    port (
        clk          : in  std_ulogic;
        rstn         : in  std_ulogic;
        led          : out std_ulogic_vector(15 downto 0);
        swx          : in  std_ulogic_vector(15 downto 0);
        ca           : out std_ulogic;
        cb           : out std_ulogic;
        cc           : out std_ulogic;
        cd           : out std_ulogic;
        ce           : out std_ulogic;
        cf           : out std_ulogic;
        cg           : out std_ulogic;
        dp           : out std_ulogic;
        an           : out std_ulogic_vector(7 downto 0);
        btn_left     : in  std_ulogic;
        btn_right    : in  std_ulogic;
        btn_up       : in  std_ulogic;
        btn_down     : in  std_ulogic;
        btn_select   : in  std_ulogic
    );
end component;
    signal clk_sul          : std_ulogic;
    signal rstn_sul         : std_ulogic;
    signal led_sul          : std_ulogic_vector(15 downto 0);
    signal swx_sul          : std_ulogic_vector(15 downto 0);
    signal ca_sul           : std_ulogic;
    signal cb_sul           : std_ulogic;
    signal cc_sul           : std_ulogic;
    signal cd_sul           : std_ulogic;
    signal ce_sul           : std_ulogic;
    signal cf_sul           : std_ulogic;
    signal cg_sul           : std_ulogic;
    signal dp_sul           : std_ulogic;
    signal an_sul           : std_ulogic_vector(7 downto 0);
    signal btn_left_sul     : std_ulogic;
    signal btn_right_sul    : std_ulogic;
    signal btn_up_sul       : std_ulogic;
    signal btn_down_sul     : std_ulogic;
    signal btn_select_sul   : std_ulogic;
begin

    -- Inputs
    clk_sul         <= std_ulogic(CLK100MHZ);
    rstn_sul        <= std_ulogic(CPU_RESETN);
    swx_sul         <= std_ulogic_vector(SW);
    btn_left_sul    <= std_ulogic(BTNL);
    btn_right_sul   <= std_ulogic(BTNR);
    btn_up_sul      <= std_ulogic(BTNU);
    btn_down_sul    <= std_ulogic(BTND);
    btn_select_sul  <= std_ulogic(BTNC);

    -- Outputs
    LED     <= std_logic_vector(led_sul);
    CA      <= std_logic(ca_sul);
    CB      <= std_logic(cb_sul);
    CC      <= std_logic(cc_sul);
    CD      <= std_logic(cd_sul);
    CE      <= std_logic(ce_sul);
    CF      <= std_logic(cf_sul);
    CG      <= std_logic(cg_sul);
    DP      <= std_logic(dp_sul);
    AN      <= std_logic_vector(an_sul);

top_cmp: top port map (
    clk         => clk_sul,
    rstn        => rstn_sul,
    led         => led_sul,
    swx         => swx_sul,
    ca          => ca_sul,
    cb          => cb_sul,
    cc          => cc_sul,
    cd          => cd_sul,
    ce          => ce_sul,
    cf          => cf_sul,
    cg          => cg_sul,
    dp          => dp_sul,
    an          => an_sul,
    btn_left    => btn_left_sul,
    btn_right   => btn_right_sul,
    btn_up      => btn_up_sul,
    btn_down    => btn_down_sul,
    btn_select  => btn_select_sul
);

end Behavioral;
