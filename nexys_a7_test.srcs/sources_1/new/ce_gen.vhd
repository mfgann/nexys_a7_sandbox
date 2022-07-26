----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/26/2022 08:43:49 AM
-- Design Name:
-- Module Name: ce_gen - Behavioral
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

entity ce_gen is
    Generic (
        en_div   : integer := 1
    );
    Port (
        clk      : in  STD_LOGIC;
        rstn     : in  STD_LOGIC;
        en_out   : out STD_LOGIC);
end ce_gen;

architecture Behavioral of ce_gen is
    signal en_o     : std_logic;
    signal cnt      : integer := 0;
begin

    en_out  <= en_o;

en_generation: process(clk, rstn)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            cnt     <= 0;
            en_o    <= '0';
        else
            if cnt >= en_div then
                en_o    <= '1';
                cnt     <= 0;
            else
                en_o    <= '0';
                cnt     <= cnt + 1;
            end if;
        end if;
    end if;
end process en_generation;

end Behavioral;
