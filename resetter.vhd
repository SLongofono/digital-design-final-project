library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity resetter is
    port(
        clk, rst : in std_logic;
        address : out integer;
        write : out std_logic
    );
end resetter;

architecture Behavioral of resetter is

constant MAX_INDEX : integer := 307199;

type state is (idle, writing);

signal curr_state, next_state : state;

signal index : integer := 0;

begin

process(clk, rst)
begin
    if('1' = rst) then
        curr_state <= idle;
        index <= 0;
    elsif(rising_edge(clk)) then
        curr_state <= next_state;
    end if;
end process;

process(curr_state)
begin
    next_state <= curr_state;
    write <= '0';
    case curr_state is
        when idle =>
            index <= 0;
            -- Do nothing
            
        when writing =>         
            -- increement the address to be written
            index <= index + 1;
            
            -- check if we need to keep going...
            if(index > MAX_INDEX) then
                next_state <= idle;
                
                -- signal that we are still writing
                write <= '1';
            else
                next_state <= writing;
            end if;
            
    end case;

end process;

address <= index;

end Behavioral;
