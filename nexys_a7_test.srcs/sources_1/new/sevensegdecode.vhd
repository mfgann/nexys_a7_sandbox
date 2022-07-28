----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/26/2022 02:00:14 PM
-- Design Name:
-- Module Name: sevensegdecode - Behavioral
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

entity sevensegdecode is
    Port ( clk  : in  std_ulogic;
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
end sevensegdecode;

architecture Behavioral of sevensegdecode is
    signal ss_o             : std_ulogic_vector(7 downto 0);
begin

    ca  <= ss_o(7);
    cb  <= ss_o(6);
    cc  <= ss_o(5);
    cd  <= ss_o(4);
    ce  <= ss_o(3);
    cf  <= ss_o(2);
    cg  <= ss_o(1);
    dp  <= ss_o(0);

gen_digit : process (clk, rstn)
begin
    if rising_edge(clk) then
        if rstn = '0' then
            ss_o    <= (others => '1');
        else
            if en = '0' then
                ss_o    <= ss_o;
            else
                case val is
                    when x"0" =>
                        ss_o    <= b"11111100";
                    when x"1" =>
                        ss_o    <= b"01100000";
                    when x"2" =>
                        ss_o    <= b"11011010";
                    when x"3" =>
                        ss_o    <= b"11110010";
                    when x"4" =>
                        ss_o    <= b"01100110";
                    when x"5" =>
                        ss_o    <= b"10110110";
                    when x"6" =>
                        ss_o    <= b"10111110";
                    when x"7" =>
                        ss_o    <= b"11100000";
                    when x"8" =>
                        ss_o    <= b"11111110";
                    when x"9" =>
                        ss_o    <= b"11100110";
                    when x"a" =>
                        ss_o    <= b"11111010";
                    when x"b" =>
                        ss_o    <= b"00111110";
                    when x"c" =>
                        ss_o    <= b"10011100";
                    when x"d" =>
                        ss_o    <= b"01111010";
                    when x"e" =>
                        ss_o    <= b"11011110";
                    when x"f" =>
                        ss_o    <= b"10001110";
                    when others =>
                        ss_o    <= (others => '1');
                end case;
            end if;
        end if;
    end if;
end process gen_digit;

end Behavioral;
