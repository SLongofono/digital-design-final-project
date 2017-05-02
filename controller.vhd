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
		clk           : in std_logic;
		rst			  : in std_logic;
		up			  : in std_logic;
		down		  : in std_logic;
		left		  : in std_logic;
		right		  : in std_logic;
		mode_switch   : in std_logic;
		addr		  : out integer;
		en_write	  : out std_logic);
END controller;

ARCHITECTURE behavioral OF controller IS

constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

signal xpos, ypos : integer := 0;
signal mode : std_logic := '0'; -- Move/ Draw mode (0 = 'move', 1 = 'draw')

BEGIN

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