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
use IEEE.std_logic_1164.ALL;

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
    signal clk      : std_ulogic := '0';
    signal rst      : std_ulogic := '0';
    signal led      : std_ulogic_vector(15 downto 0);
    signal swx      : std_ulogic_vector(15 downto 0) := (others => '0');
    signal ca       : std_ulogic;
    signal cb       : std_ulogic;
    signal cc       : std_ulogic;
    signal cd       : std_ulogic;
    signal ce       : std_ulogic;
    signal cf       : std_ulogic;
    signal cg       : std_ulogic;
    signal dp       : std_ulogic;
    signal an       : std_ulogic_vector(7 downto 0);
    signal btn_l    : std_ulogic := '0';
    signal btn_r    : std_ulogic := '0';
    signal btn_u    : std_ulogic := '0';
    signal btn_d    : std_ulogic := '0';
    signal btn_s    : std_ulogic := '0';

begin

top_cmp: top port map (
    clk         => clk,
    rstn        => rst,
    led         => led,
    swx         => swx,
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
