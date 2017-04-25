----------------------------------------------------------------------------------
-- Engineer: Longofono
-- Create Date: 04/20/2017 05:59:28 PM
-- Description: Debouncing Circuit For Buttons 
-- Based on starter code by  Scott Larson of DigiKey 
-- Retrieved 4/25/16
-- https://eewiki.net/pages/viewpage.action?pageId=4980758#DebounceLogicCircuit(withVHDLexample)-ExampleVHDLCode 
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity button is
    generic(counter_size : INTEGER := 20); -- debounce time control
    port(
        clk     : in  std_logic;        -- system clock, assumed 100 MHz
        rst     : in std_logic;         -- system reset
        hw_in   : in  std_logic;        -- input from physical button
        button_assert  : out std_logic);--debounced signal
end button;

architecture behav of button is

signal buf1, buf2   : std_logic;    -- input buffer digits
signal reset_counter : std_logic;        -- toggle reset_counter
signal counter : std_logic_vector(counter_size downto 0);-- := (OTHERS => '0'); --counter output

begin

reset_counter <= buf1 xor buf2;   -- on change, reset_counter is high
  
process(clk)
begin
    if('1' = rst) then
        counter <= (others => '0');
    elsif(rising_edge(clk)) then
        buf1 <= hw_in;
        buf2 <= buf1;
        if(reset_counter = '1') then  --input changed, start timer
            counter <= (others => '0');
        elsif(counter(counter_size) = '1') then -- debounced, output last matched signal
            button_assert <= buf2;
        else
            counter <= counter + 1;  -- not debounced yet, keep waiting
        end if;    
    end if;
end process;

end behav;
