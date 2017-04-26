-- Engineer: Longofono
-- Create Date: 04/21/2017 03:47:55 PM
-- Module Name: debounce_test - Behavioral
-- Description: Testbench for button debouncing 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_test is

end debounce_test;

architecture Behavioral of debounce_test is

component button is
  Port ( clk, rst, hw_in : in STD_LOGIC;
         button_assert : out STD_LOGIC);
end component;

signal pressed : std_logic := '0';
signal output : std_logic := '0';
signal s_reset : std_logic := '1';
signal clk : std_logic := '0';
constant clk_period : time := 10 ns;

begin
uut: button port map (clk=>clk, rst => s_reset, hw_in => pressed, button_assert => output);

process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;


process
begin
    wait for 30 ms;
    s_reset <= '0';
    pressed <= '1';
    wait for 10 ms;
    pressed <= '0';
    wait for 10 ms;
    pressed <= '1';
    wait for 30 ms;
    s_reset <= '1';
    wait for 30 ms;
    s_reset <= '0';

end process;

end Behavioral;
