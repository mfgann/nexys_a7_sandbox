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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk          : in STD_LOGIC;
           rstn         : in STD_LOGIC;
           led0         : out STD_LOGIC;
           btn_left     : in STD_LOGIC;
           btn_right    : in STD_LOGIC;
           btn_up       : in STD_LOGIC;
           btn_down     : in STD_LOGIC;
           btn_select   : in STD_LOGIC);
end top;

architecture Behavioral of top is

begin

top : process(clk, rstn, btn_left, btn_right, btn_down, btn_up, btn_select)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            led0 <= '0';
        else
            if btn_select = '1' then
                led0 <= '1';
            else
                led0 <= '0';
            end if;
        end if;
    end if;
end process top;

end Behavioral;
