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
        hw_in_up, hw_in_down, hw_in_left, hw_in_right, hw_in_cent : in std_logic;
        SCLK : out std_logic;
        MOSI : out std_logic;
        MISO : in std_logic;
        SS : out std_logic;
        activity          : out std_logic
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
    address : in integer;
    draw_enable : in std_logic
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

component controller is
	PORT(
		clk               : in std_logic;
		rst			      : in std_logic;
		btn_up			  : in std_logic;
		btn_down		  : in std_logic;
		btn_left		  : in std_logic;
		btn_right		  : in std_logic;
		btn_mode_switch   : in std_logic;
		addr		      : out integer;
		en_write	      : out std_logic);
end component;

constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

-- VGA interface
signal s_vsync, s_hsync : std_logic;
signal s_red, s_green, s_blue : std_logic_vector(3 downto 0);
signal s_x : integer := 320;
signal s_y : integer := 240;
signal s_color : std_logic_vector(11 downto 0);

-- Button controller interface
signal draw_enable : std_logic;
signal s_addr: integer := 153600;

-- Accelerometer interface
signal shaking : std_logic;



begin

activity <= draw_enable;

VGA_unit: VGA_ctrl port map(
    clk => clk,
    rst => shaking,
    VGA_HS_O => hsync,
    VGA_VS_O => vsync,
    VGA_RED_O => red,
    VGA_BLUE_O => blue,
    VGA_GREEN_O => green,
    new_color => new_color,
    address => s_addr,
    draw_enable => draw_enable
);

Ctrl: controller port map(
    clk => clk,
    rst => rst,
    btn_up => hw_in_up,
    btn_down => hw_in_down,
    btn_left => hw_in_left,
    btn_right => hw_in_right,
    btn_mode_switch => hw_in_cent,
    addr => s_addr,
    en_write => draw_enable); -- draw enable

ACC : accel port map(
    clk => clk,
    rst => rst,
    shaking => shaking,
    SCLK => SCLK,
    MOSI => MOSI,
    MISO => MISO,
    SS => SS
);


end Behavioral;
