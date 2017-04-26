----------------------------------------------------------------------------------
-- Engineer: Longofono
-- Create Date: 04/25/2017 09:59:28 PM
-- Description: Accelerometer Interface Circuit
--
--	The circuit makes use of the accelerometer driver and its internal SPI
--	controller to continuously poll the accelerometer for movement.  When 
--	movement beyond a threshold is detected along any axis of motion, the
--	erase signal is asserted, signalling upstream that the canvas should be
--	erased (equivalent to system reset).
--
--  As is, the accelerometer module outputs a 12 bit 2's complement number
--  representing the acceleration in the x, y, and z directions.  We don't
--  necessarily care what direction it is changing in, only that it is not
--  stationary.  The accelerometer is quite sensitive, so we look at the
--  two highest bits in each return value to judge movement.
--
-- Written for use with the SPI interface and ADXL362Ctrl modules provided on
-- the Nexys4 Github site.  Accessed 4/25/2017:
-- https://github.com/Digilent/Nexys4/tree/master/Projects/User_Demo/src/hdl
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity accel is
generic(system_freq 	   : integer := 100000000;  -- System clock speed
	serial_freq 	   : integer := 1000000;    -- SPI clock speed
	average_window   : integer := 16;         -- Average this many samples
	update_frequency : integer := 100);       -- Update at this rate
	
port(clk, rst	       : in std_logic;
     shaking		   : out std_logic;         -- Output to upstream
     SCLK		       : out std_logic;	        -- SPI clock
     MOSI		       : out std_logic;	        -- SPI Master output
     MISO		       : in std_logic;		    -- SPI Master input
     SS		       : out std_logic);        -- SPI Slave select
end accel;

architecture behave of accel is

-- Accelerometer control module
component ADXL362Ctrl
generic(SYSCLK_FREQUENCY_HZ : integer := 100000000;
   	SCLK_FREQUENCY_HZ   : integer := 1000000;
   	NUM_READS_AVG       : integer := 16;
   	UPDATE_FREQUENCY_HZ : integer := 1000);
port(SYSCLK              : in STD_LOGIC; -- System Clock
     RESET               : in STD_LOGIC;
       
     -- Accelerometer data signals
     ACCEL_X              : out STD_LOGIC_VECTOR (11 downto 0);
     ACCEL_Y              : out STD_LOGIC_VECTOR (11 downto 0);
     ACCEL_Z              : out STD_LOGIC_VECTOR (11 downto 0);

     -- Accumulator for temporary sum (averaging)
     ACCEL_TMP            : out STD_LOGIC_VECTOR (11 downto 0);

     -- Flag data is ready to read
     Data_Ready           : out STD_LOGIC;
     
     --SPI Interface Signals for internal SPI controller
     SCLK                 : out STD_LOGIC;
     MOSI                 : out STD_LOGIC;
     MISO                 : in STD_LOGIC;
     SS                   : out STD_LOGIC
);
end component;

-- Catch return values from accelerometer
signal x_val	: std_logic_vector(11 downto 0);
signal y_val	: std_logic_vector(11 downto 0);
signal z_val	: std_logic_vector(11 downto 0);

-- Used for averaging as an accumulator
signal acc_tmp	: std_logic_vector(11 downto 0);

-- Catch value of hightest two acceleration bits
signal out_val  : std_logic;

-- Catch interrupt that data is ready to read
signal s_data	: std_logic;

begin -- architecture

-- Accelerometer unit
ACC_UNIT: ADXL362Ctrl
generic map(SYSCLK_FREQUENCY_HZ => system_freq,
   	    SCLK_FREQUENCY_HZ   => serial_freq,
   	    NUM_READS_AVG       => average_window,
   	    UPDATE_FREQUENCY_HZ => update_frequency)
port map(SYSCLK 		=> clk,
  	 RESET 		=> rst,
       	 ACCEL_X 	=> x_val,
       	 ACCEL_Y 	=> y_val,
       	 ACCEL_Z 	=> z_val,
       	 ACCEL_TMP 	=> acc_tmp,
       	 Data_Ready	=> s_data,
       	 SCLK 		=> SCLK,
       	 MOSI 		=> MOSI,
       	 MISO 		=> MISO,
       	 SS   		=> SS);

-- Poll s_data, then gather values
process(s_data, rst)
begin
    if('1' = rst) then
        out_val <= '0';
    elsif('1' = s_data) then
    
        -- Negative logic...
        out_val <= not( ( (x_val(10) and x_val(9)) or 
                        (y_val(10) and y_val(9)) or
                        (z_val(10) and z_val(9)) ) );
    end if;
end process;

-- Assign output value for upstream modules
shaking <= out_val;

end behave;
