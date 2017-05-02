----------------------------------------------------------------------------------
-- Engineer: Gibbons
-- Create Date: 04/30/2017 11:58:17 AM
-- Description: Controller for user input to track location on board.
--				Updates memory based on location and if write is enabled.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY controller IS
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
END controller;

ARCHITECTURE behavioral OF controller IS

component button is
    port(
        clk     : in  std_logic;        -- system clock, assumed 100 MHz
        rst     : in std_logic;         -- system reset
        hw_in   : in  std_logic;        -- input from physical button
        button_assert  : out std_logic);--debounced signal
end component;

constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

signal xpos, ypos : integer := 0;
signal mode : std_logic := '1'; -- Move/ Draw mode (0 = 'move', 1 = 'draw')
signal mode_switch, up, down, left, right : std_logic := '0';

BEGIN

    uut_mode : button
        port map(clk, rst, btn_mode_switch, mode_switch);        
    uut_up : button
        port map(clk, rst, btn_up, up);
    uut_down : button
        port map(clk, rst, btn_down, down);
    uut_left : button
        port map(clk, rst, btn_left, left);
    uut_right : button
        port map(clk, rst, btn_right, right);

PROCESS (clk)
BEGIN
    xpos <= xpos;
    ypos <= ypos;
	IF (rst = '1') THEN
		xpos <= 0;
		ypos <= 0;
		mode <= '0';
	ELSIF rising_edge(clk) THEN
        IF (mode_switch = '1') THEN
            mode <= not(mode);
        END IF;
        IF (left = '1' AND xpos > 0) THEN
            xpos <= xpos - 1;
        ELSIF (right = '1' AND xpos < FRAME_WIDTH-1) THEN
            xpos <= xpos + 1;
        END IF;
        IF (up = '1' AND ypos > 0) THEN
            ypos <= ypos - 1;
        ELSIF (down = '1' AND ypos < FRAME_HEIGHT-1) THEN
            ypos <= ypos + 1;
        END IF;
	END IF;
END process;

addr <= xpos+ypos*FRAME_WIDTH;
en_write <= mode;

END behavioral;