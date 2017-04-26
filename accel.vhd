----------------------------------------------------------------------------------
-- Engineer: Longofono
-- Create Date: 04/25/2017 09:59:28 PM
-- Description: Accelerometer Interface Circuit
--
--      The circuit makes use of the accelerometer driver and its internal SPI
--      controller to continuously poll the accelerometer for movement.  When
--      movement beyond a threshold is detected along any axis of motion, the
--      erase signal is asserted, signalling upstream that the canvas should be
--      erased (equivalent to system reset).
--
--
-- Adapted to use with the SPI interface and ADXL362Ctrl modules provided on
-- the Nexys4 Github site.  Accessed 4/25/2017:
-- https://github.com/Digilent/Nexys4/tree/master/Projects/User_Demo/src/hdl
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity accel is
        generic(system_freq     : integer := 100000000;
                serial_freq     : integer := 1000000;
                average_window  : integer := 15;
                update_frequency: integer := 100);

        port(   clk, rst        : in std_logic;
                x_val           : out std_logic_vector(11 downto 0);
                y_val           : out std_logic_vector(11 downto 0);
                z_val           : out std_logic_vector(11 downto 0);
                bufr            : out std_logic_vector(11 downto 0);
                data            : out std_logic;
                SCLK            : out std_logic;        -- SPI clock
                MOSI            : out std_logic;        -- SPI Master output
                MISO            : in std_logic;         -- SPI Master input
                SS              : out std_logic         -- SPI Slave select
        );
end accel;

architecture behave of accel is

component ADXL362Ctrl
generic(SYSCLK_FREQUENCY_HZ : integer := 100000000;
        SCLK_FREQUENCY_HZ   : integer := 1000000;
        NUM_READS_AVG       : integer := 16;
        UPDATE_FREQUENCY_HZ : integer := 1000
);
port(   SYSCLK     : in STD_LOGIC; -- System Clock
        RESET      : in STD_LOGIC;

       -- Accelerometer data signals
       ACCEL_X    : out STD_LOGIC_VECTOR (11 downto 0);
       ACCEL_Y    : out STD_LOGIC_VECTOR (11 downto 0);
       ACCEL_Z    : out STD_LOGIC_VECTOR (11 downto 0);

       -- Accumulator for temporary sum (averaging)
       ACCEL_TMP  : out STD_LOGIC_VECTOR (11 downto 0);

       -- Flag data is ready to read
       Data_Ready : out STD_LOGIC;

       --SPI Interface Signals for internal SPI controller
       SCLK       : out STD_LOGIC;
       MOSI       : out STD_LOGIC;
       MISO       : in STD_LOGIC;
       SS         : out STD_LOGIC
);
end component;

--constant reset_period_us : integer := 10;
--constant reset_idle_clock: integer := ((reset_period_us*1000)/(100000000/system_freq));

--signal acc_x  : std_logic_vector(11 downto 0);
--signal acc_y  : std_logic_vector(11 downto 0);
--signal acc_z  : std_logic_vector(11 downto 0);
--signal s_data : std_logic;

--signal counter: integer range 0 to (reset_idle_clock -1) := 0;
--signal reset_interrupt : std_logic;

begin -- architecture

-- Reset counter
--process(clk, counter, rst)
--begin
--      if(rising_edge(clk)) then
--              if('1' = rst) then
--                      counter <= 0;
--                      reset_interrupt <= '1';
--              elsif(counter = (reset_idle_clock - 1)) then
--                      counter <= (reset_idle_clock - 1);
--                      reset_interrupt <= '0';
--              else
--                      counter <= counter + 1;
--                      reset_interrupt <= '1';
--              end if;
--      end if;
--end process;


-- ADC unit
ADC: ADXL362Ctrl
generic map(    SYSCLK_FREQUENCY_HZ => system_freq,
                SCLK_FREQUENCY_HZ   => serial_freq,
                NUM_READS_AVG       => average_window,
                UPDATE_FREQUENCY_HZ => update_frequency
)
port map(       SYSCLK          => clk,
                RESET           => rst,
                ACCEL_X         => x_val,
                ACCEL_Y         => y_val,
                ACCEL_Z         => z_val,
                ACCEL_TMP       => ACCEL_TMP,
                Data_Ready      => s_data,
                SCLK            => SCLK,
                MOSI            => MOSI,
                MISO            => MISO,
                SS              => SS
);

end behave;
