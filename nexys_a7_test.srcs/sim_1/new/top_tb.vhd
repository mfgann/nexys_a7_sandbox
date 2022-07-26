----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/25/2022 02:44:08 PM
-- Design Name:
-- Module Name: top_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
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

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal led      : std_logic_vector(15 downto 0);
    signal ca       : STD_LOGIC;
    signal cb       : STD_LOGIC;
    signal cc       : STD_LOGIC;
    signal cd       : STD_LOGIC;
    signal ce       : STD_LOGIC;
    signal cf       : STD_LOGIC;
    signal cg       : STD_LOGIC;
    signal dp       : STD_LOGIC;
    signal an       : STD_LOGIC_VECTOR(7 downto 0);
    signal btn_l    : std_logic := '0';
    signal btn_r    : std_logic := '0';
    signal btn_u    : std_logic := '0';
    signal btn_d    : std_logic := '0';
    signal btn_s    : std_logic := '0';

begin

top_cmp: top port map (
    clk         => clk,
    rstn        => rst,
    led         => led,
    ca          => ca,
    cb          => cb,
    cc          => cc,
    cd          => cd,
    ce          => ce,
    cf          => cf,
    cg          => cg,
    dp          => dp,
    an          => an,
    btn_left    => btn_l,
    btn_right   => btn_r,
    btn_up      => btn_u,
    btn_down    => btn_d,
    btn_select  => btn_s
);

tb_rst_process : process
begin
    wait for 100 ns;
    rst <= '1';
    wait;
end process tb_rst_process;

--tb_clk_process : process
--begin
    clk <= not clk after 10 ns;
--end process tb_clk_process;

tb_input_process: process
begin
    wait for 200 ns;
    btn_s <= '1';
    wait for 75 ns;
    btn_s <= '0';
end process tb_input_process;

end Behavioral;
