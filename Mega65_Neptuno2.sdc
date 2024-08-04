#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.1.4 Build 182 03/12/2014 SJ Lite Version
#
#************************************************************

# Copyright (C) 1991-2014 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name CLOCK_27 -period 20.000 [get_ports {CLOCK_27}]
create_clock -name SPI_SCK  -period 41.666 -waveform { 20.8 41.666 } [get_ports {SPI_SCK}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# Clock groups
set_clock_groups -asynchronous \
    -group [get_clocks pll|altpll_component|auto_generated|pll1|clk[*]] \
	-group [get_clocks pll2|altpll_component|auto_generated|pll1|clk[*]] \
	-group [get_clocks {SPI_SCK}]

set_multicycle_path -to {VGA_*[*]} -setup 2
set_multicycle_path -to {VGA_*[*]} -hold 1

set_false_path -from {SDRAM*}
set_false_path -from {SPI*}
set_false_path -from {AUDIO_IN}

#set_false_path -to [get_ports {AUDIO_L}]
#set_false_path -to [get_ports {AUDIO_R}]
#set_false_path -to [get_ports {LED}]
set_false_path -to  {VGA_*}
set_false_path -to  {SDRAM*}
set_false_path -to  {SPI*}
set_false_path -to  {I2S_*}
set_false_path -to  {LED1}
set_false_path -to  {LED2}


 


