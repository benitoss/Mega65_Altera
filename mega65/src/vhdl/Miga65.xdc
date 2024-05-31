################################################################################
# General configuration options.
################################################################################
set_property CFGBVS                         VCCO    [current_design];
set_property CONFIG_VOLTAGE                 3.3     [current_design];
set_property BITSTREAM.CONFIG.UNUSEDPIN     PULLUP  [current_design];
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH  4       [current_design];
set_property CONFIG_MODE                    SPIx4   [current_design];
set_property BITSTREAM.CONFIG.CONFIGRATE    50      [current_design];

################################################################################
# System clock.
################################################################################
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports CLK_IN];
create_clock -period 20.000 [get_ports CLK_IN];

################################################################################
# Clock and timing constraints.
################################################################################
create_generated_clock -name clock324   [get_pins d0.clocks1/mmcm_adv0/CLKOUT0    ];
create_generated_clock -name clock135p  [get_pins d0.clocks1/mmcm_adv0/CLKOUT1    ];
create_generated_clock -name clock135n  [get_pins d0.clocks1/mmcm_adv0/CLKOUT1B   ];
create_generated_clock -name pixelclock [get_pins d0.clocks1/mmcm_adv0/CLKOUT2    ];
create_generated_clock -name clock81n   [get_pins d0.clocks1/mmcm_adv0/CLKOUT2B   ];
create_generated_clock -name cpuclock   [get_pins d0.clocks1/mmcm_adv0/CLKOUT3    ];
create_generated_clock -name clock27    [get_pins d0.clocks1/mmcm_adv0/CLKOUT4    ];
create_generated_clock -name clock162   [get_pins d0.clocks1/mmcm_adv0/CLKOUT5    ];
create_generated_clock -name clock270   [get_pins d0.clocks1/mmcm_adv0/CLKOUT6    ];
create_generated_clock -name clock100   [get_pins d0.clocks1/mmcm_adv1_eth/CLKOUT0];
create_generated_clock -name ethclock   [get_pins d0.clocks1/mmcm_adv1_eth/CLKOUT1];
create_generated_clock -name clock200   [get_pins d0.clocks1/mmcm_adv1_eth/CLKOUT2];

# Make Ethernet clocks unrelated to other clocks to avoid erroneous timing
# violations, and hopefully make everything synthesise faster.
set_clock_groups -asynchronous \
     -group {cpuclock pixelclock clock27 clock162 clock324} \
     -group {ethclock clock200}

# Relax between Ethernet and CPU.
set_false_path -from [get_clocks cpuclock] -to [get_clocks ethclock];
set_false_path -from [get_clocks ethclock] -to [get_clocks cpuclock];

# Relax between clock domains of the HyperRAM.
set_false_path -from [get_clocks clock324] -to [get_clocks clock162];
set_false_path -from [get_clocks clock162] -to [get_clocks clock324];

create_generated_clock -name clock60  [get_pins d0.AUDIO_TONE/CLOCK/MMCM/CLKOUT1];

# For timing analysis, we approximate the audio clock with a frequency of 60/4 =
# 15 MHz. This is slightly over-constraining the design, but the difference is
# small enough to not cause timing violations.
create_generated_clock -name clock12p228 -source [get_pins d0.AUDIO_TONE/CLOCK/MMCM/CLKOUT1] -divide_by 4 [get_pins d0.AUDIO_TONE/CLOCK/clk_u_reg/Q];

# Fix 12.288MHz clock generation clock domain crossing
set_false_path -from [get_clocks cpuclock] -to [get_clocks clock60];
set_false_path -from [get_clocks cpuclock] -to [get_clocks clock12p228];

create_generated_clock -name clock1   -source [get_pins d0.clocks1/mmcm_adv0/CLKOUT3] -divide_by 41 [get_pins m0.machine0/pixel0/phi_1mhz_ubuf_reg/Q];
create_generated_clock -name clock2   -source [get_pins d0.clocks1/mmcm_adv0/CLKOUT3] -divide_by 20 [get_pins m0.machine0/pixel0/phi_2mhz_ubuf_reg/Q];
create_generated_clock -name clock3p5 -source [get_pins d0.clocks1/mmcm_adv0/CLKOUT3] -divide_by 10 [get_pins m0.machine0/pixel0/phi_3mhz_ubuf_reg/Q];
set_false_path -from [get_clocks cpuclock] -to [get_clocks clock1];

# Fix for I2S Sound
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets CLK_IN_IBUF]

################################################################################
# QSPI flash
################################################################################
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {QspiDB[0]}];
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {QspiDB[1]}];
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {QspiDB[2]}];
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {QspiDB[3]}];
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33                } [get_ports QspiCSn    ];

################################################################################
# Dummy VGA interface for debugging on J12.
################################################################################
#set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports vdac_clk     ];
#set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33} [get_ports vdac_sync_n  ];
#set_property -dict {PACKAGE_PIN AA24 IOSTANDARD LVCMOS33} [get_ports vdac_blank_n ];
#set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {vgared[0]}  ];
#set_property -dict {PACKAGE_PIN Y25  IOSTANDARD LVCMOS33} [get_ports {vgared[1]}  ];
#set_property -dict {PACKAGE_PIN W25  IOSTANDARD LVCMOS33} [get_ports {vgared[2]}  ];
#set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports {vgared[3]}  ];
#set_property -dict {PACKAGE_PIN W21  IOSTANDARD LVCMOS33} [get_ports {vgared[4]}  ];
#set_property -dict {PACKAGE_PIN V26  IOSTANDARD LVCMOS33} [get_ports {vgared[5]}  ];
#set_property -dict {PACKAGE_PIN U25  IOSTANDARD LVCMOS33} [get_ports {vgared[6]}  ];
#set_property -dict {PACKAGE_PIN V24  IOSTANDARD LVCMOS33} [get_ports {vgared[7]}  ];
#set_property -dict {PACKAGE_PIN V23  IOSTANDARD LVCMOS33} [get_ports {vgagreen[0]}];
#set_property -dict {PACKAGE_PIN V18  IOSTANDARD LVCMOS33} [get_ports {vgagreen[1]}];
#set_property -dict {PACKAGE_PIN U22  IOSTANDARD LVCMOS33} [get_ports {vgagreen[2]}];
#set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS33} [get_ports {vgagreen[3]}];
#set_property -dict {PACKAGE_PIN T20  IOSTANDARD LVCMOS33} [get_ports {vgagreen[4]}];
#set_property -dict {PACKAGE_PIN T19  IOSTANDARD LVCMOS33} [get_ports {vgagreen[5]}];
#set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS33} [get_ports {vgagreen[6]}];
#set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {vgagreen[7]}];
#set_property -dict {PACKAGE_PIN AB25 IOSTANDARD LVCMOS33} [get_ports {vgablue[0]} ];
#set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {vgablue[1]} ];
#set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS33} [get_ports {vgablue[2]} ];
#set_property -dict {PACKAGE_PIN Y26  IOSTANDARD LVCMOS33} [get_ports {vgablue[3]} ];
#set_property -dict {PACKAGE_PIN Y23  IOSTANDARD LVCMOS33} [get_ports {vgablue[4]} ];
#set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS33} [get_ports {vgablue[5]} ];
#set_property -dict {PACKAGE_PIN W26  IOSTANDARD LVCMOS33} [get_ports {vgablue[6]} ];
#set_property -dict {PACKAGE_PIN U26  IOSTANDARD LVCMOS33} [get_ports {vgablue[7]} ];
#set_property -dict {PACKAGE_PIN W24  IOSTANDARD LVCMOS33} [get_ports {debug[0]}   ];
#set_property -dict {PACKAGE_PIN W23  IOSTANDARD LVCMOS33} [get_ports {debug[1]}   ];
#set_property -dict {PACKAGE_PIN W18  IOSTANDARD LVCMOS33} [get_ports {debug[2]}   ];
#set_property -dict {PACKAGE_PIN V22  IOSTANDARD LVCMOS33} [get_ports {debug[3]}   ];
#set_property -dict {PACKAGE_PIN V21  IOSTANDARD LVCMOS33} [get_ports {debug[4]}   ];
#set_property -dict {PACKAGE_PIN U20  IOSTANDARD LVCMOS33} [get_ports hsync        ];
#set_property -dict {PACKAGE_PIN U19  IOSTANDARD LVCMOS33} [get_ports vsync        ];

################################################################################
# Switches and LEDs.
################################################################################
set_property -dict {PACKAGE_PIN P4  IOSTANDARD LVCMOS33} [get_ports btnCpuReset];
#set_property -dict {PACKAGE_PIN M6  IOSTANDARD LVCMOS33} [get_ports KEY1       ];
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33} [get_ports led        ];
set_property -dict {PACKAGE_PIN R23 IOSTANDARD LVCMOS33} [get_ports led2       ];

################################################################################
# SD-card interface.
################################################################################
# Internal SD-card on PMOD (J10).
#set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports sdMOSI ];
#set_property -dict {PACKAGE_PIN G5 IOSTANDARD LVCMOS33} [get_ports sdClock];
#set_property -dict {PACKAGE_PIN G7 IOSTANDARD LVCMOS33} [get_ports sdReset];
#set_property -dict {PACKAGE_PIN G8 IOSTANDARD LVCMOS33} [get_ports sdMISO ];

# External SD-card on micro SD-card slot (J9).
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports sd2MOSI ];
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports sd2Clock];
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports sd2Reset];
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports sd2MISO ];

################################################################################
#Keyboard and mouse
################################################################################

set_property PACKAGE_PIN K23 [get_ports ps2clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2clk]
set_property PULLUP true [get_ports ps2clk]
set_property PACKAGE_PIN K22 [get_ports ps2data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2data]
#set_property PACKAGE_PIN K26 [get_ports mouse_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports mouse_clk]
#set_property PULLUP true [get_ports ps2_data]
#set_property PACKAGE_PIN K25 [get_ports mouse_data]
#set_property PULLUP true [get_ports mouse_data]
#set_property IOSTANDARD LVCMOS33 [get_ports mouse_data]



################################################################################
# USB serial interface.
################################################################################
#set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports UART_TXD];
#set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports RsRx    ];

################################################################################
# HDMI interface.
################################################################################
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD TMDS_33} [get_ports TMDS_clk_n      ];
#set_property -dict {PACKAGE_PIN D4 IOSTANDARD TMDS_33} [get_ports TMDS_clk_p      ];
#set_property -dict {PACKAGE_PIN D1 IOSTANDARD TMDS_33} [get_ports {TMDS_data_n[0]}];
#set_property -dict {PACKAGE_PIN E1 IOSTANDARD TMDS_33} [get_ports {TMDS_data_p[0]}];
#set_property -dict {PACKAGE_PIN E2 IOSTANDARD TMDS_33} [get_ports {TMDS_data_n[1]}];
#set_property -dict {PACKAGE_PIN F2 IOSTANDARD TMDS_33} [get_ports {TMDS_data_p[1]}];
#set_property -dict {PACKAGE_PIN G1 IOSTANDARD TMDS_33} [get_ports {TMDS_data_n[2]}];
#set_property -dict {PACKAGE_PIN G2 IOSTANDARD TMDS_33} [get_ports {TMDS_data_p[2]}];

################################################################################
# VGA interface.
################################################################################

set_property PACKAGE_PIN R26 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN P26 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

set_property PACKAGE_PIN M25 [get_ports vdac_blank_n]
set_property IOSTANDARD LVCMOS33 [get_ports vdac_blank_n]
set_property PACKAGE_PIN M24 [get_ports vdac_clk]
set_property IOSTANDARD LVCMOS33 [get_ports vdac_clk]

set_property PACKAGE_PIN AB24 [get_ports {vgared[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[7]}]
set_property PACKAGE_PIN AC24 [get_ports {vgared[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[6]}]
set_property PACKAGE_PIN W21 [get_ports {vgared[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[5]}]
set_property PACKAGE_PIN Y21 [get_ports {vgared[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[4]}]
set_property PACKAGE_PIN W25 [get_ports {vgared[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[3]}]
set_property PACKAGE_PIN Y26 [get_ports {vgared[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[2]}]
set_property PACKAGE_PIN AB26 [get_ports {vgared[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[1]}]
set_property PACKAGE_PIN AC26 [get_ports {vgared[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgared[0]}]

set_property PACKAGE_PIN U21 [get_ports {vgagreen[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[7]}]
set_property PACKAGE_PIN V21 [get_ports {vgagreen[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[6]}]
set_property PACKAGE_PIN V23 [get_ports {vgagreen[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[5]}]
set_property PACKAGE_PIN W23 [get_ports {vgagreen[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[4]}]
set_property PACKAGE_PIN Y22 [get_ports {vgagreen[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[3]}]
set_property PACKAGE_PIN Y23 [get_ports {vgagreen[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[2]}]
set_property PACKAGE_PIN Y25 [get_ports {vgagreen[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[1]}]
set_property PACKAGE_PIN AA25 [get_ports {vgagreen[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgagreen[0]}]

set_property PACKAGE_PIN N21 [get_ports {vgablue[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[7]}]
set_property PACKAGE_PIN N22 [get_ports {vgablue[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[6]}]
set_property PACKAGE_PIN P23 [get_ports {vgablue[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[5]}]
set_property PACKAGE_PIN P24 [get_ports {vgablue[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[4]}]
set_property PACKAGE_PIN R25 [get_ports {vgablue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[3]}]
set_property PACKAGE_PIN P25 [get_ports {vgablue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[2]}]
set_property PACKAGE_PIN T24 [get_ports {vgablue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[1]}]
set_property PACKAGE_PIN T25 [get_ports {vgablue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vgablue[0]}]

################################################################################
#Audio I2S
################################################################################
#set_property PACKAGE_PIN P9 [get_ports MCLK]
#set_property IOSTANDARD LVCMOS33 [get_ports MCLK]
set_property PACKAGE_PIN E26 [get_ports audio_blck]
set_property IOSTANDARD LVCMOS33 [get_ports audio_blck]
set_property PACKAGE_PIN D26 [get_ports audio_lrclk]
set_property IOSTANDARD LVCMOS33 [get_ports audio_lrclk]
set_property PACKAGE_PIN D25 [get_ports audio_sdata]
set_property IOSTANDARD LVCMOS33 [get_ports audio_sdata]


################################################################################
# C64 keyboard interface on J12.
################################################################################
#set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[3]}]; # J12:3  | IO_L3P_T0_DQS_13
#set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[6]}]; # J12:5  | IO_L9P_T1_DQS_13
#set_property -dict {PACKAGE_PIN AA24 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[5]}]; # J12:7  | IO_L7P_T1_13
#set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[4]}]; # J12:9  | IO_L8P_T1_13
#set_property -dict {PACKAGE_PIN Y25  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[7]}]; # J12:11 | IO_L5P_T0_13
#set_property -dict {PACKAGE_PIN W25  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[2]}]; # J12:13 | IO_L4P_T0_13
#set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[1]}]; # J12:15 | IO_L11P_T1_SRCC_13
#set_property -dict {PACKAGE_PIN W21  IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports {portb_pins[0]}]; # J12:17 | IO_L14P_T2_SRCC_13
#set_property -dict {PACKAGE_PIN V26  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[0]}]; # J12:19 | IO_L2P_T0_13
#set_property -dict {PACKAGE_PIN U25  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[6]}]; # J12:21 | IO_L1P_T0_13
#set_property -dict {PACKAGE_PIN V24  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[5]}]; # J12:23 | IO_L6P_T0_13
#set_property -dict {PACKAGE_PIN V23  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[4]}]; # J12:25 | IO_L10P_T1_13
#set_property -dict {PACKAGE_PIN V18  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[3]}]; # J12:27 | IO_L19P_T3_13
#set_property -dict {PACKAGE_PIN U22  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[2]}]; # J12:29 | IO_L12P_T1_MRCC_13
#set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[1]}]; # J12:31 | IO_L13P_T2_MRCC_13
#set_property -dict {PACKAGE_PIN T20  IOSTANDARD LVCMOS33 DRIVE 16       } [get_ports {porta_pins[7]}]; # J12:33 | IO_L15P_T2_DQS_13

################################################################################
# Control port 1 (PMOD) (J10).
################################################################################
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fa_up   ]; # J10:1  | IO_L13N_T2_MRCC_35
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fa_left ]; # J10:2  | IO_L12P_T1_MRCC_35
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fa_down ]; # J10:7  | IO_L13P_T2_MRCC_35
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fa_right]; # J10:8  | IO_L1P_T0_AD4P_35
set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fa_fire ]; # J10:9  | IO_L1N_T0_AD4N_35

################################################################################
# Control port 2 (PMOD) (J11).
################################################################################
set_property -dict {PACKAGE_PIN J26 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fb_up   ]; # J11:1  | IO_L9N_T1_DQS_AD7N_35
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fb_left ]; # J11:2  | IO_L11N_T1_SRCC_35
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fb_down ]; # J11:7  | IO_L9P_T1_DQS_AD7P_35
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fb_right]; # J11:8  | IO_L11P_T1_SRCC_35
set_property -dict {PACKAGE_PIN E23 IOSTANDARD LVCMOS33 PULLTYPE PULLUP} [get_ports fb_fire ]; # J11:9  | IO_L16P_T2_35
