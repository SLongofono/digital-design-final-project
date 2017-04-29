## This file is a general .xdc for the Nexys4 DDR Rev. C
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
#Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]

##Switches

#Bank = 34, Pin name = IO_L21P_T3_DQS_34,					Sch name = SW0
set_property PACKAGE_PIN U9 [get_ports {rst}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
#Bank = 34, Pin name = IO_25_34,							Sch name = SW1
 set_property PACKAGE_PIN U8 [get_ports {new_color[0]}]    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[0]}]
 #Bank = 34, Pin name = IO_L23P_T3_34,                        Sch name = SW2
 set_property PACKAGE_PIN R7 [get_ports {new_color[1]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[1]}]
 #Bank = 34, Pin name = IO_L19P_T3_34,                        Sch name = SW3
 set_property PACKAGE_PIN R6 [get_ports {new_color[2]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[2]}]
 #Bank = 34, Pin name = IO_L19N_T3_VREF_34,                    Sch name = SW4
 set_property PACKAGE_PIN R5 [get_ports {new_color[3]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[3]}]
 #Bank = 34, Pin name = IO_L20P_T3_34,                        Sch name = SW5
 set_property PACKAGE_PIN V7 [get_ports {new_color[4]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[4]}]
 #Bank = 34, Pin name = IO_L20N_T3_34,                        Sch name = SW6
 set_property PACKAGE_PIN V6 [get_ports {new_color[5]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[5]}]
 #Bank = 34, Pin name = IO_L10P_T1_34,                        Sch name = SW7
 set_property PACKAGE_PIN V5 [get_ports {new_color[6]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[6]}]
 #Bank = 34, Pin name = IO_L8P_T1-34,                        Sch name = SW8
 set_property PACKAGE_PIN U4 [get_ports {new_color[7]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[7]}]
 #Bank = 34, Pin name = IO_L9N_T1_DQS_34,                    Sch name = SW9
 set_property PACKAGE_PIN V2 [get_ports {new_color[8]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[8]}]
 #Bank = 34, Pin name = IO_L9P_T1_DQS_34,                    Sch name = SW10
 set_property PACKAGE_PIN U2 [get_ports {new_color[9]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[9]}]
 #Bank = 34, Pin name = IO_L11N_T1_MRCC_34,                    Sch name = SW11
 set_property PACKAGE_PIN T3 [get_ports {new_color[10]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[10]}]
 #Bank = 34, Pin name = IO_L17N_T2_34,                        Sch name = SW12
 set_property PACKAGE_PIN T1 [get_ports {new_color[11]}]                    
     set_property IOSTANDARD LVCMOS33 [get_ports {new_color[11]}]


##Buttons

#Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports {hw_in_cent}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {hw_in_cent}]
#Bank = 15, Pin name = IO_L14P_T2_SRCC_15,					Sch name = BTNU
set_property PACKAGE_PIN F15 [get_ports {hw_in_up}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {hw_in_up}]
#Bank = CONFIG, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,	Sch name = BTNL
set_property PACKAGE_PIN T16 [get_ports {hw_in_left}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {hw_in_left}]
#Bank = 14, Pin name = IO_25_14,							Sch name = BTNR
set_property PACKAGE_PIN R10 [get_ports {hw_in_right}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {hw_in_right}]
#Bank = 14, Pin name = IO_L21P_T3_DQS_14,					Sch name = BTND
set_property PACKAGE_PIN V10 [get_ports {hw_in_down}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {hw_in_down}]
 
##Accelerometer
##Bank = 15, Pin name = IO_L6N_T0_VREF_15,                    Sch name = ACL_MISO
set_property PACKAGE_PIN D13 [get_ports MISO]                    
    set_property IOSTANDARD LVCMOS33 [get_ports MISO]
##Bank = 15, Pin name = IO_L2N_T0_AD8N_15,                    Sch name = ACL_MOSI
set_property PACKAGE_PIN B14 [get_ports MOSI]                    
    set_property IOSTANDARD LVCMOS33 [get_ports MOSI]
##Bank = 15, Pin name = IO_L12P_T1_MRCC_15,                    Sch name = ACL_SCLK
set_property PACKAGE_PIN D15 [get_ports SCLK]                    
    set_property IOSTANDARD LVCMOS33 [get_ports SCLK]
##Bank = 15, Pin name = IO_L12N_T1_MRCC_15,                    Sch name = ACL_CSN
set_property PACKAGE_PIN C15 [get_ports SS]                        
    set_property IOSTANDARD LVCMOS33 [get_ports SS]

#VGA Connector

set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { red[0] }]; #IO_L8N_T1_AD14N_35 Sch=vga_r[0]
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { red[1] }]; #IO_L7N_T1_AD6N_35 Sch=vga_r[1]
set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { red[2] }]; #IO_L1N_T0_AD4N_35 Sch=vga_r[2]
set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { red[3] }]; #IO_L8P_T1_AD14P_35 Sch=vga_r[3]

set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { green[0] }]; #IO_L1P_T0_AD4P_35 Sch=vga_g[0]
set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { green[1] }]; #IO_L3N_T0_DQS_AD5N_35 Sch=vga_g[1]
set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { green[2] }]; #IO_L2N_T0_AD12N_35 Sch=vga_g[2]
set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { green[3] }]; #IO_L3P_T0_DQS_AD5P_35 Sch=vga_g[3]

set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { blue[0] }]; #IO_L2P_T0_AD12P_35 Sch=vga_b[0]
set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { blue[1] }]; #IO_L4N_T0_35 Sch=vga_b[1]
set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { blue[2] }]; #IO_L6N_T0_VREF_35 Sch=vga_b[2]
set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { blue[3] }]; #IO_L4P_T0_35 Sch=vga_b[3]

set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { hsync }]; #IO_L4P_T0_15 Sch=vga_hs
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports { vsync }]; #IO_L3N_T0_DQS_AD1N_15 Sch=vga_vs
