----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/26/2022 03:48:42 PM
-- Design Name:
-- Module Name: onehot_decode - Behavioral
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
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity onehot_decode is
    Generic ( width : integer := 8 );
    Port (  clk     : in  STD_LOGIC;
            en      : in  STD_LOGIC;
            rstn    : in  STD_LOGIC;
            c       : in  STD_LOGIC_VECTOR(integer(CEIL(LOG2(real(width)))) downto 0);
            o       : out STD_LOGIC_VECTOR(width-1 downto 0));
end onehot_decode;

architecture Behavioral of onehot_decode is
    constant one    : unsigned(width-1 downto 0) := to_unsigned(1, o'length);
begin

    onehot_decode_p : process(clk)
        variable cv     : unsigned(c'length downto 0);
    begin
        if rising_edge(clk) then
            if rstn = '0' then
                cv      := (others => '0');
                o       <= (others => '0');
            else
                if en = '0' then
                    cv      := cv;
                    o       <= (others => '0');
                else
                    cv      := unsigned(c);
                    if cv > width then
                        cv      := (others => '0');
                    end if;
                    o   <= std_logic_vector(one sll cv);
                end if;
            end if;
        end if;
    end process onehot_decode_p;

end Behavioral;
