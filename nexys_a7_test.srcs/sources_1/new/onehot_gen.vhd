----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/26/2022 03:48:42 PM
-- Design Name:
-- Module Name: onehot_gen - Behavioral
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

entity onehot_gen is
    Generic ( width : integer := 8 );
    Port ( clk      : in std_ulogic;
           en       : in std_ulogic;
           rstn     : in std_ulogic;
           o        : out std_ulogic_vector(width-1 downto 0));
end onehot_gen;

architecture Behavioral of onehot_gen is
    signal b    : std_ulogic_vector(width-1 downto 0);
    signal bb   : std_ulogic;
begin
    o <= b;
    onehot_p : process(clk)
    begin
        if rising_edge(clk) then
            if rstn = '0' then
                b   <= (others => '0');
                bb  <= '1';
                -- o   <= (others => '0');
            else
                if en = '0' then
                    b   <= b;
                    bb  <= bb;
                    -- o   <= (others => '0');
                else
                    b(width-1 downto 1)   <= b(width-2 downto 0);
                    bb      <= b(width-2);
                    b(0)    <= bb;
                    -- o       <= b;
                end if;
            end if;
        end if;
    end process onehot_p;
end Behavioral;
