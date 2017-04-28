----------------------------------------------------------------------------------
-- Engineer: Longofono
-- Create Date: 04/26/2017 06:28:40 PM 
-- Description: VGA control interface
-- 
-- Notes
--
-- Adapted from a starter module provided on
-- the Nexys4 Github site.  Accessed 4/26/2017:
-- https://github.com/Digilent/Nexys4/tree/master/Projects/User_Demo/src/hdl
----------------------------------------------------------------------------------

library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity vga_ctrl is
Port (clk, rst : in STD_LOGIC;
      VGA_HS_O : out STD_LOGIC;
      VGA_VS_O : out STD_LOGIC;
      VGA_RED_O : out STD_LOGIC_VECTOR (3 downto 0);
      VGA_BLUE_O : out STD_LOGIC_VECTOR (3 downto 0);
      VGA_GREEN_O : out STD_LOGIC_VECTOR (3 downto 0);
      new_color : in std_logic_vector(11 downto 0);
      x_write : in integer;
      y_write : in integer
);
end vga_ctrl;

architecture Behavioral of vga_ctrl is

-- 640 x 480 @ 60Hz
constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period, sum of width, fp, sync, bp (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
constant V_MAX : natural := 525; --V total period, sum of height, fp, sync, bp (lines)

constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';

-- Pixel clock, in this case 50 MHz
signal pxl_clk : std_logic;

signal pxl_counter : std_logic := '0';

-- The active signal is used to signal the active region of the screen (when not blank)
signal active  : std_logic;

-- Horizontal and Vertical counters
signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');

-- Indices for memory access
-- Pipe Horizontal and Vertical Counters
signal h_cntr_reg_dly   : std_logic_vector(11 downto 0) := (others => '0');
signal v_cntr_reg_dly   : std_logic_vector(11 downto 0) := (others => '0');

-- Horizontal and Vertical Sync
signal h_sync_reg : std_logic := not(H_POL);
signal v_sync_reg : std_logic := not(V_POL);

-- Pipe Horizontal and Vertical Sync
signal h_sync_reg_dly : std_logic := not(H_POL);
signal v_sync_reg_dly : std_logic :=  not(V_POL);

-- VGA R, G and B signals coming from the main multiplexers
signal vga_red_cmb   : std_logic_vector(3 downto 0);
signal vga_green_cmb : std_logic_vector(3 downto 0);
signal vga_blue_cmb  : std_logic_vector(3 downto 0);

--The main VGA R, G and B signals, validated by active
signal vga_red    : std_logic_vector(3 downto 0);
signal vga_green  : std_logic_vector(3 downto 0);
signal vga_blue   : std_logic_vector(3 downto 0);

-- Register VGA R, G and B signals
signal vga_red_reg   : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_green_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_blue_reg  : std_logic_vector(3 downto 0) := (others =>'0');

-- Colorbar red, greeen and blue signals
signal bg_red                 : std_logic_vector(3 downto 0);
signal bg_blue             : std_logic_vector(3 downto 0);
signal bg_green             : std_logic_vector(3 downto 0);

-- Pipe the colorbar red, green and blue signals
signal bg_red_dly            : std_logic_vector(3 downto 0) := (others => '0');
signal bg_green_dly        : std_logic_vector(3 downto 0) := (others => '0');
signal bg_blue_dly        : std_logic_vector(3 downto 0) := (others => '0');

signal xpos : integer := 0;
signal ypos : integer := 0;
signal pix_write : integer := 5;

-- memory spoof
type ram is array(0 to 307199) of std_logic_vector(11 downto 0);

signal pattern : ram := (others => "010101010101");

signal pxl_write_count : integer := 0;

begin


-- Generate special clock for the VGA
process(clk, rst)
begin
    if('1' = rst) then
        pxl_counter <= '0';
    elsif(rising_edge(clk)) then
        pxl_counter <= not pxl_counter;
        
        -- 25 Mhz
        if( '1' = pxl_counter ) then
            pxl_clk <= not pxl_clk;
        end if;
    end if;
end process;


-- Generate Horizontal, Vertical counters and the Sync signals
-- Horizontal counter
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        if (h_cntr_reg = (H_MAX - 1)) then
            h_cntr_reg <= (others =>'0');
        else
            h_cntr_reg <= h_cntr_reg + 1;
        end if;
    end if;
end process;

-- Vertical counter
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
            v_cntr_reg <= (others =>'0');            
        elsif (h_cntr_reg = (H_MAX - 1)) then
            v_cntr_reg <= v_cntr_reg + 1;
        end if;
    end if;
end process;

-- Horizontal sync
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
            h_sync_reg <= H_POL;
        else
            h_sync_reg <= not(H_POL);
        end if;
    end if;
end process;

-- Vertical sync
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
            v_sync_reg <= V_POL;
        else
            v_sync_reg <= not(V_POL);
        end if;
    end if;
end process;


-- active signal
active <= '1' when h_cntr_reg_dly < FRAME_WIDTH and v_cntr_reg_dly < FRAME_HEIGHT
     else '0';

-- update canvas
-- TODO replace me by function of input write and color
--process(pxl_clk)
--begin
--    if (pxl_write_count >= 307199) then
--        -- increment pixel counter
--        pix_write <= pix_write + 1;
--        if(pix_write > 307199) then
--            pix_write <= 0;
--        end if;
--            
--        pattern(pix_write) <= "110111011101";
--        pxl_write_count <= 0;
--    else
--        pxl_write_count <= pxl_write_count +1;
--    end if;
--    
--end process;


-- update cursor
process(pxl_clk)
begin
    if(rising_edge(pxl_clk)) then
        xpos <= xpos + 1;
        if(xpos > FRAME_WIDTH) then
            xpos <= 0;
            ypos <= ypos + 1;
        end if;
        if(ypos > FRAME_HEIGHT) then
            ypos <= 0;
        end if;
    end if;
end process;

bg_red <= pattern(((ypos * FRAME_HEIGHT) + xpos))(3 downto 0);
bg_green <= pattern(((ypos * FRAME_HEIGHT) + xpos))(7 downto 4);
bg_blue <= pattern(((ypos * FRAME_HEIGHT) + xpos))(11 downto 8);

 
-- Register Outputs coming from the displaying components and the horizontal and vertical counters
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        bg_red_dly            <= bg_red;
        bg_green_dly        <= bg_green;
        bg_blue_dly            <= bg_blue;        

        h_cntr_reg_dly <= h_cntr_reg;
        v_cntr_reg_dly <= v_cntr_reg;
    end if;
end process;

vga_red <= bg_red_dly;
vga_green <= bg_green_dly;
vga_blue <= bg_blue_dly;

-- Turn Off VGA RBG Signals if outside of the active screen
vga_red_cmb <= (active & active & active & active) and vga_red;
vga_green_cmb <= (active & active & active & active) and vga_green;
vga_blue_cmb <= (active & active & active & active) and vga_blue;


-- Register Outputs
process (pxl_clk)
begin
    if (rising_edge(pxl_clk)) then
        v_sync_reg_dly <= v_sync_reg;
        h_sync_reg_dly <= h_sync_reg;
        vga_red_reg    <= vga_red_cmb;
        vga_green_reg  <= vga_green_cmb;
        vga_blue_reg   <= vga_blue_cmb;      
    end if;
end process;

-- Assign outputs
VGA_HS_O     <= h_sync_reg_dly;
VGA_VS_O     <= v_sync_reg_dly;
VGA_RED_O    <= vga_red_reg;
VGA_GREEN_O  <= vga_green_reg;
VGA_BLUE_O   <= vga_blue_reg;

end Behavioral;
