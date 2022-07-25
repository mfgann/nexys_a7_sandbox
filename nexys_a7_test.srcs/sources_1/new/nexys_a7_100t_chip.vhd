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
    Port ( CLK100MHZ    : in  STD_LOGIC;
           CPU_RESETN   : in  STD_LOGIC;
           
           LED          : out STD_LOGIC_VECTOR (0 downto 0);
           BTNU         : in  STD_LOGIC;
           BTND         : in  STD_LOGIC;
           BTNL         : in  STD_LOGIC;
           BTNR         : in  STD_LOGIC;
           BTNC         : in  STD_LOGIC);
end nexys_a7_100t_chip;

architecture Behavioral of nexys_a7_100t_chip is
component top is
    port (
        clk          : in STD_LOGIC;
        rstn         : in STD_LOGIC;
        led0         : out STD_LOGIC;
        btn_left     : in STD_LOGIC;
        btn_right    : in STD_LOGIC;
        btn_up       : in STD_LOGIC;
        btn_down     : in STD_LOGIC;
        btn_select   : in STD_LOGIC
    );
end component;
begin

top_cmp: top port map (
    clk         => CLK100MHZ,
    rstn        => CPU_RESETN,
    led0        => LED(0),
    btn_left    => BTNL,
    btn_right   => BTNR,
    btn_up      => BTNU,
    btn_down    => BTND,
    btn_select  => BTNC
);

end Behavioral;
