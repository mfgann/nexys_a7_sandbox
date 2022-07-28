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
use IEEE.std_logic_1164.ALL;
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
    Port (  clk     : in  std_ulogic;
            en      : in  std_ulogic;
            rstn    : in  std_ulogic;
            c       : in  std_ulogic_vector(integer(CEIL(LOG2(real(width)))) downto 0);
            o       : out std_ulogic_vector(width-1 downto 0));
end onehot_decode;

architecture Behavioral of onehot_decode is
    -- Using unsigned because sll is defined for unsigned
    constant one    : unsigned(width-1 downto 0) := to_unsigned(1, o'length);
begin

    onehot_decode_p : process(clk)
        variable cv     : integer range 0 to width;
    begin
        if rising_edge(clk) then
            if rstn = '0' then
                o       <= (others => '0');
                cv      := 0;
            else
                if en = '0' then
                    o       <= std_ulogic_vector(one sll cv);
                    cv      := cv;
                else
                    o   <= std_ulogic_vector(one sll cv);
                    cv      := to_integer(unsigned(c))-1;
                    if cv > width then
                        cv      := 0;
                    end if;
                end if;
            end if;
        end if;
    end process onehot_decode_p;

end Behavioral;
