----------------------------------------------------------------------------------
-- Engineer: Gibbons
-- Create Date: 04/30/2017 11:58:17 AM
-- Description: Controller for user input to track location on board.
--				Updates memory based on location and if write is enabled.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY controller IS
	PORT(
		clk			: in std_logic;
		rst			: in std_logic;
		up			: in std_logic;
		down		: in std_logic;
		left		: in std_logic;
		right		: in std_logic;
		en_draw		: in std_logic;
		addr		: out std_logic_vector(18 downto 0);
		en_write	: out std_logic);
END controller;

ARCHITECTURE behavioral OF controller IS

signal xpos, ypos : std_logic_vector(9 downto 0);

BEGIN

PROCESS (clk)
BEGIN
	IF (rst = '1') THEN
		xpos <= (others => '0');
		ypos <= (others => '0');
	ELSIF rising_edge(clk) THEN

	END IF;
END process;

END behavioral;