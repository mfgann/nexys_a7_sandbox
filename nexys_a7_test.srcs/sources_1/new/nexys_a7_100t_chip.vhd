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
    Port (  CLK100MHZ    : in  STD_LOGIC;
            CPU_RESETN   : in  STD_LOGIC;

            -- LEDs
            LED          : out STD_LOGIC_VECTOR (15 downto 0);

            -- 7-Segment Display
            CA           : out STD_LOGIC;
            CB           : out STD_LOGIC;
            CC           : out STD_LOGIC;
            CD           : out STD_LOGIC;
            CE           : out STD_LOGIC;
            CF           : out STD_LOGIC;
            CG           : out STD_LOGIC;
            DP           : out STD_LOGIC;
            AN           : out STD_LOGIC_VECTOR (7 downto 0);

            -- Directional buttons
            BTNU         : in  STD_LOGIC;
            BTND         : in  STD_LOGIC;
            BTNL         : in  STD_LOGIC;
            BTNR         : in  STD_LOGIC;
            BTNC         : in  STD_LOGIC);
end nexys_a7_100t_chip;

architecture Behavioral of nexys_a7_100t_chip is
component top is
    port (
        clk          : in  STD_LOGIC;
        rstn         : in  STD_LOGIC;
        led          : out STD_LOGIC_VECTOR(15 downto 0);
        ca           : out STD_LOGIC;
        cb           : out STD_LOGIC;
        cc           : out STD_LOGIC;
        cd           : out STD_LOGIC;
        ce           : out STD_LOGIC;
        cf           : out STD_LOGIC;
        cg           : out STD_LOGIC;
        dp           : out STD_LOGIC;
        an           : out STD_LOGIC_VECTOR(7 downto 0);
        btn_left     : in  STD_LOGIC;
        btn_right    : in  STD_LOGIC;
        btn_up       : in  STD_LOGIC;
        btn_down     : in  STD_LOGIC;
        btn_select   : in  STD_LOGIC
    );
end component;
begin

top_cmp: top port map (
    clk         => CLK100MHZ,
    rstn        => CPU_RESETN,
    led         => LED,
    ca          => CA,
    cb          => CB,
    cc          => CC,
    cd          => CD,
    ce          => CE,
    cf          => CF,
    cg          => CG,
    dp          => DP,
    an          => AN,
    btn_left    => BTNL,
    btn_right   => BTNR,
    btn_up      => BTNU,
    btn_down    => BTND,
    btn_select  => BTNC
);

end Behavioral;
