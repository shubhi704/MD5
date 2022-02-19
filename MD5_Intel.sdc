## Generated SDC file "MD5_Intel.out.sdc"

## Copyright (C) 2019  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"

## DATE    "Sun Nov 28 12:43:01 2021"

##
## DEVICE  "5CGXFC9E7F35C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 600.000 -waveform { 0.000 300.000 } -name {clock} [get_ports {clock}] 


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty

#**************************************************************
# Set Input Delay
#**************************************************************
#set_input_delay -add_delay -clock [get_clocks {clk}] 1.500 [get_ports{async_rst}]
#set_input_delay -add_delay -clock [get_clocks {clk}] 1.200 [get_ports{MSG}]
set_input_delay 2.00 -clock [get_clocks {clock}] [get_ports {MSG}]

#**************************************************************
# Set Output Delay
#**************************************************************
#set_output_delay -add_delay -clock [get_clocks {clock}] 2.000 [get_ports{md}]
set_output_delay 1.00 -clock [get_clocks {clock}] [get_ports {md}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

