----------------------------------------------------------------------------------
-- Engineer: Longofono
-- Create Date: 04/28/2017 07:18:38 PM
-- Description: Mockup to stitch modules together for testing 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee. std_logic_unsigned.all;

entity driver is
    port(
        clk, rst: in std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        red : out std_logic_vector (3 downto 0);
        blue : out std_logic_vector (3 downto 0);
        green : out std_logic_vector (3 downto 0);
        new_color : in std_logic_vector(11 downto 0);
        x_write : in integer;
        y_write : in integer;
        hw_in_up, hw_in_down, hw_in_left, hw_in_right, hw_in_cent : in std_logic;
        SCLK : out std_logic;
        MOSI : out std_logic;
        MISO : in std_logic;
        SS : out std_logic
    );
end driver;

architecture Behavioral of driver is

component vga_ctrl is
port(
    clk : in std_logic;
    rst : in std_logic;
    VGA_HS_O : out std_logic;
    VGA_VS_O : out std_logic;
    VGA_RED_O : out std_logic_vector (3 downto 0);
    VGA_BLUE_O : out std_logic_vector (3 downto 0);
    VGA_GREEN_O : out std_logic_vector (3 downto 0);
    new_color : in std_logic_vector(11 downto 0);
    x_write : in integer;
    y_write : in integer
);
end component;

component accel is
generic(  system_freq 	   : integer := 100000000;  -- System clock speed
	      serial_freq 	   : integer := 1000000;    -- SPI clock speed
	      average_window   : integer := 16;         -- Average this many samples
	      update_frequency : integer := 100);       -- Update at this rate
	
port(	  clk, rst	       : in std_logic;
	      shaking		   : out std_logic;         -- Output to upstream
	      SCLK		       : out std_logic;	        -- SPI clock
	      MOSI		       : out std_logic;	        -- SPI Master output
	      MISO		       : in std_logic;		    -- SPI Master input
	      SS		       : out std_logic);        -- SPI Slave select
end component;

component button is
generic(counter_size : INTEGER := 20); -- debounce time control
port(
    clk     : in  std_logic;        -- system clock, assumed 100 MHz
    rst     : in std_logic;         -- system reset
    hw_in   : in  std_logic;        -- input from physical button
    button_assert  : out std_logic);--debounced signal
end component;

constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

-- VGA interface
signal s_vsync, s_hsync : std_logic;
signal s_red, s_green, s_blue : std_logic_vector(3 downto 0);
signal s_x, s_y : integer := 0;
signal s_color : std_logic_vector(11 downto 0);

-- Button interface
signal s_up, s_down, s_left, s_right, s_cent : std_logic;

-- Accelerometer interface
signal shaking : std_logic;

-- Speed control
signal frame_counter : std_logic_vector(20 downto 0) := (others => '0');
signal frame_clk : std_logic;

begin

VGA_unit: VGA_ctrl port map(
    clk => clk,
    rst => shaking,
    VGA_HS_O => hsync,
    VGA_VS_O => vsync,
    VGA_RED_O => red,
    VGA_BLUE_O => blue,
    VGA_GREEN_O => green,
    new_color => new_color,
    x_write => s_x,
    y_write => s_y
);

BTN_UP : button port map(
    clk => clk,
    rst => rst,
    hw_in => hw_in_up,
    button_assert => s_up
);

BTN_LEFT : button port map(
    clk => clk,
    rst => rst,
    hw_in => hw_in_left,
    button_assert => s_left
);

BTN_RIGHT : button port map(
    clk => clk,
    rst => rst,
    hw_in => hw_in_right,
    button_assert => s_right
);

BUTTON_CENT : button port map(
    clk => clk,
    rst => rst,
    hw_in => hw_in_cent,
    button_assert => s_cent
);

BTN_DOWN : button port map(
    clk => clk,
    rst => rst,
    hw_in => hw_in_down,
    button_assert => s_down
);

ACC : accel port map(
    clk => clk,
    rst => rst,
    shaking => shaking,
    SCLK => SCLK,
    MOSI => MOSI,
    MISO => MISO,
    SS => SS
);

-- Human friendly clock for responding to input
frame_clk <= frame_counter(20);

process(clk, rst)
begin
    if('1' = rst) then
    elsif(rising_edge(clk)) then
        frame_counter <= frame_counter + 1;
    end if;
end process;

-- Handle button inputs
process(s_up, s_down, s_left, s_right, s_cent, frame_clk)
begin

    if(rising_edge(frame_clk)) then
        
        if('1' = s_up and s_y < FRAME_HEIGHT) then
            s_y <= s_y + 1;
        elsif('1' = s_down and s_y > 0) then
            s_y <= s_y - 1;
        elsif('1' = s_right and s_x < FRAME_WIDTH) then
            s_x <= s_x + 1;
        elsif('1' = s_left and s_x > 0) then
            s_x <= s_x - 1;
        end if;
        
    end if;

end process;

end Behavioral;
