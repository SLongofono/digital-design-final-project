library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  port (
    clk             : in std_logic;
    rst             : in std_logic;
    write           : in std_logic;
    address_read    : in integer;
    address_write   : in integer;
    write_data      : in std_logic_vector(11 downto 0);
    read_data       : out std_logic_vector(11 downto 0)
  );
end memory;

architecture behav of memory is



   type ram is array (0 to 307199) of std_logic_vector(11 downto 0);
   signal myram : ram := (others => "101010101010");
   signal read_address : integer;

begin

process(clk, rst)
begin
    -- **Note** Not synthesizable if a reset is added
    if rising_edge(clk) then
        if ('1' = write ) then
            myram(address_write) <= write_data;
        end if;
      read_address <= address_read;
    end if;
end process;

read_data <= myram(read_address);

end behav;
