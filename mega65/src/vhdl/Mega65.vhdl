----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:37 12/10/2013 
-- Design Name: 
-- Module Name:    container - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.cputypes.all;
use work.types_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity container is
  Port ( --CLK_IN : STD_LOGIC;         
  
         clock27    : STD_LOGIC;
	      cpuclock   : STD_LOGIC;
	      pixelclock : STD_LOGIC;
	      clock162   : STD_LOGIC;
			clock162m  : STD_LOGIC;  -- phase shifted by -207 degrees for SDRAM read timing
	      clock200   : STD_LOGIC;
	      clock100   : STD_LOGIC;
	      ethclock   : STD_LOGIC;  -- 50 Mhz
  
         btnCpuReset : in  STD_LOGIC;
--         irq : in  STD_LOGIC;
--         nmi : in  STD_LOGIC;


         --debug : out std_logic_vector(4 downto 0);
         
         --KEY1 : in std_logic;
         
         ----------------------------------------------------------------------
         -- PS/2 keyboard interface
         ----------------------------------------------------------------------
         ps2clk : in std_logic;
         ps2data : in std_logic;
         
         ----------------------------------------------------------------------
         -- keyboard/joystick 
         ---------------------------------------------------------------------
         
--         -- Interface for physical keyboard
--         kb_io0 : out std_logic;
--         kb_io1 : out std_logic;
--         kb_io2 : in std_logic;
         --porta_pins : inout std_logic_vector(7 downto 0);
         --portb_pins : inout std_logic_vector(7 downto 0);

         -- Direct joystick lines
        fa_left  : in std_logic;
        fa_right : in std_logic;
        fa_up    : in std_logic;
        fa_down  : in std_logic;
        fa_fire  : in std_logic;
        fb_left  : in std_logic;
        fb_right : in std_logic;
        fb_up    : in std_logic;
        fb_down  : in std_logic;
        fb_fire  : in std_logic;

		  
		  ----------------------------------------------------------------------
         -- SDRAM as expansion RAM
         ----------------------------------------------------------------------
         sdram_clk : out std_logic;
         sdram_cke : out std_logic;
         sdram_ras_n : out std_logic;
         sdram_cas_n : out std_logic;
         sdram_we_n : out std_logic;
         sdram_cs_n : out std_logic;
         sdram_ba : out unsigned(1 downto 0);
         sdram_a : out unsigned(12 downto 0);
         sdram_dqml : out std_logic;
         sdram_dqmh : out std_logic;
         sdram_dq : inout unsigned(15 downto 0);
			
         ---------------------------------------------------------------------------
         -- IO lines to QSPI config flash (used so that we can update bitstreams)
         ---------------------------------------------------------------------------
         QspiDB : inout unsigned(3 downto 0) := (others => '0');
         QspiCSn : out std_logic;

         ---------------------------------------------------------------------------
         -- Dummy VGA output for debug
         ---------------------------------------------------------------------------
         vdac_clk : out std_logic;
         --vdac_sync_n : out std_logic; -- tie low
         vdac_blank_n : out std_logic; -- tie high
         vsync : out  STD_LOGIC;
         hsync : out  STD_LOGIC;
         vgared : out  UNSIGNED (7 downto 0);
         vgagreen : out  UNSIGNED (7 downto 0);
         vgablue : out  UNSIGNED (7 downto 0);

         
         ----------------------------------------------------------------------
         -- AK443 audio DAC output
         ----------------------------------------------------------------------
         --audio_mclk : out std_logic := '1';
         audio_blck : out std_logic := '1';
         audio_lrclk : out std_logic := '1';
         audio_sdata : out std_logic := '1';
         
         
         ---------------------------------------------------------------------------
         -- IO lines to the ethernet controller
         ---------------------------------------------------------------------------
         eth_mdio : inout std_logic;
         eth_mdc : out std_logic;
         eth_reset : out std_logic;
         eth_rxd : in unsigned(1 downto 0);
         eth_txd : out unsigned(1 downto 0);
         eth_rxer : in std_logic;
         eth_txen : out std_logic;
         eth_rxdv : in std_logic;
         eth_interrupt : in std_logic;
         eth_clock : out std_logic;
         
         -------------------------------------------------------------------------
         -- Lines for the SDcard interface itself
         -------------------------------------------------------------------------
         sdReset : out std_logic;--:= '1';  -- must be 0 to power SD controller (cs_bo)
         sdClock : out std_logic;       -- (sclk_o)
         sdMOSI : out std_logic;
         sdMISO : in  std_logic;

         sd2Reset : out std_logic;
         sd2Clock : out std_logic;       -- (sclk_o)
         sd2MOSI : out std_logic;
         sd2MISO : in std_logic;

         -- Left and right headphone port audio
--         pwm_l : out std_logic;
--         pwm_r : out std_logic;

         -- internal speaker
--         pcspeaker_left : out std_logic;
--         pcspeaker_muten : out std_logic;
         
         -- PMOD connectors on the MEGA65 R2 main board
--         p1lo : inout std_logic_vector(3 downto 0);
--         p1hi : inout std_logic_vector(3 downto 0);
--         p2lo : inout std_logic_vector(3 downto 0);
--         p2hi : inout std_logic_vector(3 downto 0);
         
         ----------------------------------------------------------------------
         -- Floppy drive interface
         ----------------------------------------------------------------------
--         f_density : out std_logic := '1';
--         f_motor : out std_logic := '1';
--         f_select : out std_logic := '1';
--         f_stepdir : out std_logic := '1';
--         f_step : out std_logic := '1';
--         f_wdata : out std_logic := '1';
--         f_wgate : out std_logic := '1';
--         f_side1 : out std_logic := '1';
--         f_index : in std_logic;
--         f_track0 : in std_logic;
--         f_writeprotect : in std_logic;
--         f_rdata : in std_logic;
--         f_diskchanged : in std_logic;

         led : out std_logic;
         led2 : out std_logic;

         --TMDS_data_p : out STD_LOGIC_VECTOR(2 downto 0);
         --TMDS_data_n : out STD_LOGIC_VECTOR(2 downto 0);
         --TMDS_clk_p : out STD_LOGIC;
         --TMDS_clk_n : out STD_LOGIC;
         
         ----------------------------------------------------------------------
         -- I2C on-board peripherals
         ----------------------------------------------------------------------
--         fpga_sda : inout std_logic;
--         fpga_scl : inout std_logic;         
         
         ----------------------------------------------------------------------
         -- Serial monitor interface
         ----------------------------------------------------------------------
         --UART_TXD : out std_logic;
         --RsRx : in std_logic
         
         uart_tx: out std_logic;
         uart_rx: in std_logic;
         uart_txd_mon : out std_logic;
         uart_rxd_mon : in std_logic
         
         );
end container;

architecture Behavioral of container is

  -- Use to select SDRAM or hyperram
  signal sdram_t_or_hyperram_f : boolean;
  
  --signal UART_TXD : std_logic := '1';
  
  signal white_dna : std_logic_vector(59 downto 0) := X"04814CE1138705C";  -- My DNA 
  signal dna :       std_logic_vector(59 downto 0) := X"000000000000000";
  --signal dna60 :     std_logic_vector(59 downto 0) := X"000000000000000";
  signal dna_equal : std_logic := '1';
  
  signal reset_high : std_logic := '1';
  
  --signal MATCH_OUT : std_logic := '0';
  --signal CHECK_DONE : std_logic := '0';
  
  signal vga_r_s        : unsigned(7 downto 0);
  signal vga_g_s        : unsigned(7 downto 0);
  signal vga_b_s        : unsigned(7 downto 0);	
  
  signal vga_r_o        : unsigned(7 downto 0); 
  signal vga_g_o        : unsigned(7 downto 0);
  signal vga_b_o        : unsigned(7 downto 0);
  
  signal y_grey         : unsigned(9 downto 0);
  signal vga_grey       : std_logic := '0';
  
  --signal dna_protection : std_logic := '0';      
    
  signal irq : std_logic := '1';
  signal nmi : std_logic := '1';
  signal irq_combined : std_logic := '1';
  signal nmi_combined : std_logic := '1';
  signal irq_out : std_logic := '1';
  signal nmi_out : std_logic := '1';
  signal reset_out : std_logic := '1';
  signal cpu_game : std_logic := '1';
  signal cpu_exrom : std_logic := '1';

  signal fpga_sda : std_logic := '1';
  signal fpga_scl : std_logic := '1';
  signal pcspeaker_muten : std_logic := '1';
  
--  signal ethclock : std_logic;
--  signal cpuclock : std_logic;
--  signal clock27 : std_logic;
--  signal pixelclock : std_logic; -- i.e., clock81p
  signal clock81n : std_logic;
--  signal clock100 : std_logic;
  signal clock135p : std_logic;
  signal clock135n : std_logic;
  signal clock270 : std_logic;
--  signal clock162 : std_logic;
--  signal clock200 : std_logic;
  signal clock324 : std_logic;

  -- XXX Actually connect to new keyboard
  signal restore_key : std_logic := '1';
  -- XXX Note that left and up are active HIGH!
  -- XXX Plumb these into the MEGA65R2 keyboard protocol receiver
  signal keyleft : std_logic := '0';
  signal keyup : std_logic := '0';
  -- On the R2, we don't use the "real" keyboard interface, but instead the
  -- widget board interface, so just have these as dummy all-high place holders
  signal column : std_logic_vector(8 downto 0) := (others => '1');
  signal row : std_logic_vector(7 downto 0) := (others => '1');
  signal column8 : std_logic := '1';
  
  
  signal segled_counter : unsigned(31 downto 0) := (others => '0');

  signal slow_access_request_toggle : std_logic;
  signal slow_access_ready_toggle : std_logic;
  signal slow_access_write : std_logic;
  signal slow_access_address : unsigned(27 downto 0);
  signal slow_access_wdata : unsigned(7 downto 0);
  signal slow_access_rdata : unsigned(7 downto 0);

  signal slow_prefetched_address : unsigned(26 downto 0);
  signal slow_prefetched_data : unsigned(7 downto 0);
  signal slow_prefetched_request_toggle : std_logic;
  
  signal sector_buffer_mapped : std_logic;  

  signal pmoda_dummy :  std_logic_vector(7 downto 0) := (others => '1');

  signal v_vga_hsync : std_logic;
  signal v_vsync : std_logic;
  signal v_red : unsigned(7 downto 0);
  signal v_green : unsigned(7 downto 0);
  signal v_blue : unsigned(7 downto 0);
  signal lcd_dataenable : std_logic;
  signal hdmi_dataenable : std_logic;
  
  signal porta_pins : std_logic_vector(7 downto 0) := (others => '1');
  signal portb_pins : std_logic_vector(7 downto 0) := (others => '1');
  
  -- XXX We should read the real temperature and feed this to the DDR controller
  -- so that it can update timing whenever the temperature changes too much.
  signal fpga_temperature : std_logic_vector(11 downto 0) := (others => '0');

  signal fa_left_drive : std_logic;
  signal fa_right_drive : std_logic;
  signal fa_up_drive : std_logic;
  signal fa_down_drive : std_logic;
  signal fa_fire_drive : std_logic;
  
  signal fb_left_drive : std_logic;
  signal fb_right_drive : std_logic;
  signal fb_up_drive : std_logic;
  signal fb_down_drive : std_logic;
  signal fb_fire_drive : std_logic;

  signal fa_potx : std_logic;
  signal fa_poty : std_logic;
  signal fb_potx : std_logic;
  signal fb_poty : std_logic;
  signal pot_drain : std_logic;

  signal pot_via_iec : std_logic;
  
  signal iec_clk_en_drive : std_logic;
  signal iec_data_en_drive : std_logic;
  signal iec_srq_en_drive : std_logic;
  signal iec_data_o_drive : std_logic;
  signal iec_reset_drive : std_logic;
  signal iec_clk_o_drive : std_logic;
  signal iec_srq_o_drive : std_logic;
  signal iec_data_i_drive : std_logic;
  signal iec_clk_i_drive : std_logic;
  signal iec_srq_i_drive : std_logic;
  signal iec_atn_drive : std_logic;

  signal pwm_l_drive : std_logic;
  signal pwm_r_drive : std_logic;
  signal pcspeaker_left_drive : std_logic;

  signal flopled0_drive : std_logic;
  signal flopled2_drive : std_logic;
  signal flopledsd_drive : std_logic;
  signal flopmotor_drive : std_logic;

  signal joy3 : std_logic_vector(4 downto 0);
  signal joy4 : std_logic_vector(4 downto 0);

  signal cart_access_count : unsigned(7 downto 0);

  signal widget_matrix_col_idx : integer range 0 to 15 := 0;
  signal widget_matrix_col : std_logic_vector(7 downto 0) := (others => '1');
  signal widget_restore : std_logic := '1';
  signal widget_capslock : std_logic := '0';
  signal widget_joya : std_logic_vector(4 downto 0);
  signal widget_joyb : std_logic_vector(4 downto 0);

  signal fastkey : std_logic;
  
  signal expansionram_read : std_logic;
  signal expansionram_write : std_logic;
  signal expansionram_rdata : unsigned(7 downto 0);
  
  signal hyperram_rdata : unsigned(7 downto 0);
  signal sdram_rdata : unsigned(7 downto 0);
  
  signal expansionram_wdata : unsigned(7 downto 0);
  signal expansionram_address : unsigned(26 downto 0);
  signal expansionram_data_ready_toggle : std_logic;
  --signal expansionram_data_ready_strobe : std_logic;
  signal expansionram_busy : std_logic;

  signal hyperram_data_ready_toggle : std_logic;
  signal hyperram_busy : std_logic;
  signal sdram_data_ready_toggle : std_logic;
  signal sdram_busy : std_logic;
  
  
  signal current_cache_line : cache_row_t := (others => (others => '0'));
  signal current_cache_line_address : unsigned(26 downto 3) := (others => '0');
  signal current_cache_line_valid : std_logic := '0';
--  signal expansionram_current_cache_line_next_toggle : std_logic := '0';

  signal expansionram_current_cache_line : cache_row_t := (others => (others => '0'));
  signal expansionram_current_cache_line_address : unsigned(26 downto 3) := (others => '0');
  signal expansionram_current_cache_line_valid : std_logic := '0';
  signal hyperram_cache_line : cache_row_t := (others => (others => '0'));
  signal hyperram_cache_line_address : unsigned(26 downto 3) := (others => '0');
  signal hyperram_cache_line_valid : std_logic := '0';
  signal sdram_cache_line : cache_row_t := (others => (others => '0'));
  signal sdram_cache_line_address : unsigned(26 downto 3) := (others => '0');
  signal sdram_cache_line_valid : std_logic := '0';
  signal expansionram_current_cache_line_next_toggle : std_logic := '0';
  signal expansionram_current_cache_line_prev_toggle : std_logic := '0';

  
  signal audio_left : std_logic_vector(19 downto 0);
  signal audio_right : std_logic_vector(19 downto 0);
  signal audio_left_slow : std_logic_vector(19 downto 0);
  signal audio_right_slow : std_logic_vector(19 downto 0);
  signal h_audio_left : std_logic_vector(19 downto 0);
  signal h_audio_right : std_logic_vector(19 downto 0);
  signal spdif_44100 : std_logic;
  
  signal porto : unsigned(7 downto 0);
  signal portp : unsigned(7 downto 0) := x"FB";

  signal qspi_clock : std_logic;
  signal qspidb_oe : std_logic;
  signal qspidb_out : unsigned(3 downto 0);
  signal qspidb_in : unsigned(3 downto 0);

  signal disco_led_en : std_logic := '0';
  signal disco_led_val : unsigned(7 downto 0);
  signal disco_led_id : unsigned(7 downto 0);

  signal hyper_addr : unsigned(18 downto 3) := (others => '0');
  signal hyper_request_toggle : std_logic := '0';
  signal hyper_data : unsigned(7 downto 0) := x"00";
  signal sdram_data : unsigned(7 downto 0) := x"00";
  signal viciv_attic_data : unsigned(7 downto 0) := x"00";
  signal hyper_data_strobe : std_logic := '0';
  signal sdram_data_strobe : std_logic := '0';
  signal viciv_attic_data_strobe : std_logic := '0';
  
  signal fm_left : signed(15 downto 0);
  signal fm_right : signed(15 downto 0);

  signal cart_ctrl_dir : std_logic := 'Z';
  signal cart_haddr_dir : std_logic := 'Z';
  signal cart_laddr_dir : std_logic := 'Z';
  signal cart_data_dir : std_logic := 'Z';
  signal cart_phi2 : std_logic := 'Z';
  signal cart_dotclock : std_logic := 'Z';
  signal cart_reset : std_logic := 'Z';

  signal cart_nmi : std_logic := 'Z';
  signal cart_irq : std_logic := 'Z';
  signal cart_dma : std_logic := 'Z';

  -- Default to cartridge lines released
  signal cart_exrom : std_logic := '1';
  signal cart_ba : std_logic := '1';
  signal cart_rw : std_logic := '1';
  signal cart_roml : std_logic := '1';
  signal cart_romh : std_logic := '1';
  signal cart_io1 : std_logic := '1';
  signal cart_game : std_logic := '1';
  signal cart_io2 : std_logic := '1';

  signal cart_d : unsigned(7 downto 0) := (others => 'Z');
  signal cart_d_read : unsigned(7 downto 0) := (others => 'Z');
  signal cart_a : unsigned(15 downto 0) := (others => 'Z');

--  signal eth_mdio : std_logic;
--  signal eth_mdc : std_logic;
--  signal eth_reset : std_logic;
--  signal eth_rxd : unsigned(1 downto 0);
--  signal eth_txd : unsigned(1 downto 0);
--  signal eth_rxer : std_logic;
--  signal eth_txen : std_logic;
--  signal eth_rxdv : std_logic;
--  signal eth_interrupt : std_logic;
--    signal eth_clock : std_logic;  

  signal iec_clk_en : std_logic := 'Z';
  signal iec_data_en : std_logic := 'Z';
  signal iec_data_o : std_logic := 'Z';
  signal iec_reset : std_logic := 'Z';
  signal iec_clk_o : std_logic := 'Z';
  signal iec_data_i : std_logic := '1';
  signal iec_clk_i : std_logic := '1';
  signal iec_atn : std_logic := 'Z';  

  signal hdmired : UNSIGNED (7 downto 0);
  signal hdmigreen : UNSIGNED (7 downto 0);
  signal hdmiblue : UNSIGNED (7 downto 0);
  signal hdmi_int : std_logic;
  signal hdmi_scl : std_logic;
  signal hdmi_sda : std_logic;

  signal red_s   : std_logic_vector(0 downto 0);
  signal green_s : std_logic_vector(0 downto 0);
  signal blue_s  : std_logic_vector(0 downto 0);
  signal clock_s : std_logic_vector(0 downto 0);

  signal red_s_n   : std_logic_vector(0 downto 0);
  signal green_s_n : std_logic_vector(0 downto 0);
  signal blue_s_n  : std_logic_vector(0 downto 0);
  
  constant clock_frequency : integer := 40500000; --MYM antes 40500000
  constant target_sample_rate : integer := 48000;
  signal audio_counter : integer := 0;
  signal sample_ready_toggle : std_logic := '0';
  signal audio_counter_interval : unsigned(25 downto 0) := to_unsigned(4*clock_frequency/target_sample_rate,26);
  signal acr_counter : integer range 0 to 12288 := 0;

  signal pcm_clk : std_logic := '0';
  signal pcm_rst : std_logic := '1';
  signal pcm_clken : std_logic := '0';
  signal pcm_l : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0,16));
  signal pcm_r : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(0,16));
  signal pcm_acr : std_logic := '0';
  signal pcm_n   : std_logic_vector(19 downto 0) := std_logic_vector(to_unsigned(0,20));
  signal pcm_cts : std_logic_vector(19 downto 0) := std_logic_vector(to_unsigned(0,20));
  
  
  signal hdmi_is_progressive : boolean := true;
  signal hdmi_is_pal : boolean := true;
  signal hdmi_is_30khz : boolean := true;
  signal hdmi_is_limited : boolean := true;
  signal hdmi_is_widescreen : boolean := true;

  signal vga_blank : std_logic := '0';

  signal tmds : slv_9_0_t(0 to 2);
  
  signal eth_load_enable : std_logic;
  
  signal sdram_slow_clock : std_logic;
  
begin

--STARTUPE2:STARTUPBlock--7Series

--XilinxHDLLibrariesGuide,version2012.4
--  STARTUPE2_inst: STARTUPE2
--    generic map(PROG_USR=>"FALSE", --Activate program event security feature.
--                                   --Requires encrypted bitstreams.
--  SIM_CCLK_FREQ=>10.0 --Set the Configuration Clock Frequency(ns) for simulation.
--    )
--    port map(
----      CFGCLK=>CFGCLK,--1-bit output: Configuration main clock output
----      CFGMCLK=>CFGMCLK,--1-bit output: Configuration internal oscillator
--                              --clock output
----             EOS=>EOS,--1-bit output: Active high output signal indicating the
--                      --End Of Startup.
----             PREQ=>PREQ,--1-bit output: PROGRAM request to fabric output
--             CLK=>'0',--1-bit input: User start-up clock input
--             GSR=>'0',--1-bit input: Global Set/Reset input (GSR cannot be used
--                      --for the port name)
--             GTS=>'0',--1-bit input: Global 3-state input (GTS cannot be used
--                      --for the port name)
--             KEYCLEARB=>'0',--1-bit input: Clear AES Decrypter Key input
--                                  --from Battery-Backed RAM (BBRAM)
--             PACK=>'0',--1-bit input: PROGRAM acknowledge input
--
--             -- Put CPU clock out on the QSPI CLOCK pin
--             USRCCLKO=>qspi_clock,--1-bit input: User CCLK input
--             USRCCLKTS=>'0',--1-bit input: User CCLK 3-state enable input
--
--             -- Assert DONE pin
--             USRDONEO=>'1',--1-bit input: User DONE pin output control
--             USRDONETS=>'1' --1-bit input: User DONE 3-state enable output
--             );
-- End of STARTUPE2_inst instantiation


  -- New clocking setup, using more optimised selection of multipliers
  -- and dividers, as well as the ability of some clock outputs to provide an
  -- inverted clock for free.
  -- Also, the 50 and 100MHz ethernet clocks are now independent of the other
  -- clocks, so that Vivado shouldn't try to meet timing closure in the (already
  -- protected) domain crossings used for those.
  
d0: if true generate
--
--    clocks1: entity work.clocking50mhz
--      port map ( clk_in    => CLK_IN,
--                 clock27   => clock27,    --   27 MHz
--                 clock41   => cpuclock,   --   40.5 MHz
--                 clock50   => ethclock,   --   50     MHz
--                 clock81p  => pixelclock, --   81  MHz
--                 clock81n  => clock81n,   --   81  MHz
--                 clock100  => clock100,   --  100     MHz
--                 clock135p => clock135p,  --  135 MHz
--                 clock135n => clock135n,  --  135 MHz inverted
--                 clock270  => clock270,   --  270 MHz
--                 clock162  => clock162,   -- 162    MHz
--                 clock200  => clock200,
--                 clock324  => clock324    -- 324      MHz
--                 );
   
    
--    get_dna: entity work.get_dna
--    port map ( 
--                clk  => clock27,  --   27 MHz
--                dna  =>  dna(56 downto 0) 
--                );
--    
--    dna60 <= "000" & dna(56 downto 0);
    
    --white_dna <= original_dna(56 downto 0); -- Extract the 57 least significant bits
    
--    VectorComp :  entity work.VectorComparator
--        generic map (
--            WIDTH => 60
--        )
--        port map (
--            vector1 => white_dna(59 downto 0), -- dna in the white list 
--            vector2 => dna60(59 downto 0),    -- obtained dna from actual FPGA device
--            equal   => dna_equal
--        );
    
--    vector_matcher : entity work.VectorMatcher
--        generic map (
--  
--              VECTOR_SIZE => 57 -- Vector size:
--        )
--        port map (
--              vector1 => white_dna(56 downto 0), -- dna in the white list
--              vector2 => dna(56 downto 0),    -- obtained dna from actual FPGA device
--              match => dna_equal  -- 1 for vectors match 
--    );
    
--        get_dna: entity work.bitlock_7ser
--    port map ( 
--                MATCH_OUT  => MATCH_OUT,  --  hi - device DNA matches expected value
--                CHECK_DONE  => CHECK_DONE -- hi - DNA check completed
--                );
    
--    vgared   <= vga_r_o;
--	vgagreen <= vga_g_o;
--	vgablue  <= vga_b_o;
	
--	vga_to_grey: vga_to_greyscale
--	port map (
--		r_in		=> vga_r_s(7 downto 2) & vga_r_s(7 downto 4),
--		g_in		=> vga_g_s(7 downto 2) & vga_g_s(7 downto 4),
--		b_in		=> vga_b_s(7 downto 2) & vga_b_s(7 downto 4),
--		------
--		y_out	   => y_grey
--	);
	
   
	
	-- Change between COLOR to GREYSCALE  pressing F11

--   process ( ps2_kbd_function_keys(11) )
--     begin
--        if rising_edge( ps2_kbd_function_keys(11) ) then
--             vga_grey <= vga_grey + 1; 
--        end if;
--		  case vga_grey is
--		      --color
--		      when "00" =>  vga_r_o	<= vga_r_s; 
--				            vga_g_o	<= vga_g_s;
--							vga_b_o	<= vga_b_s;
--				--gray
--				when "01" =>  vga_r_o	<=  y_grey(9 downto 2);
--				              vga_g_o   <=  y_grey(9 downto 2);
--							  Vga_b_o  	<=  y_grey(9 downto 2);
--				
--				--orange
--				when "10" =>  vga_r_o	<=  y_grey(9 downto 2);
--				              vga_g_o   <=  "00" & y_grey(9 downto 4);
--							  Vga_b_o  	<=  "0000" & y_grey(9 downto 6);
--				--green
--				when "11" =>  vga_r_o	<=  "00000000";
--				              vga_g_o   <=  y_grey(9 downto 2);
--							  Vga_b_o  	<=  "00000000";				
--		  end case;
--		  
--   end process;
 
    
--    -- simple audio test tone
--    AUDIO_TONE: entity work.audio_out_test_tone
--      generic map (
--        -- You have to update audio_clock if you change this
--        fref        => 50.0
--        )
--        port map (
--            select_44100 => '0',
--            ref_rst   => reset_high,
--            ref_clk   => CLK_IN,
--            pcm_rst   => pcm_rst,
--            pcm_clk   => pcm_clk,
--            pcm_clken => pcm_clken,
--
--            i2s_data_out => audio_sdata,
--            i2s_lrclk => audio_lrclk,
--            i2s_bick => audio_blck,
--           
--            audio_left_slow => audio_left_slow,
--            audio_right_slow => audio_right_slow,
--            sample_ready_toggle => sample_ready_toggle,
--            
--            pcm_l     => pcm_l,
--            pcm_r     => pcm_r
--        );

--    pcm_n <= std_logic_vector(to_unsigned(6144,pcm_n'length));
--    pcm_cts <= std_logic_vector(to_unsigned(27000,pcm_cts'length));
    
    
     -- I2S out
   i2s : entity work.i2s_transmitter
	generic map (
		mclk_rate		=> 50000000, --50000000,		-- unusual values
		sample_rate		=> 97656, --54687,
		preamble		=> 0,
		word_length		=> 24 --16
	)
	port map (
		clock_i			=> ethclock, --CLK_28 ,	-- 28.000 MHz (2xMCLK)
		reset_i			=> reset_high,
		-- Parallel input
		pcm_l_i			=> "0" & audio_left_slow  & "000" , --"0" & pcm_l(15 downto 1),
		pcm_r_i			=> "0" & audio_right_slow & "000", -- "0" & pcm_r(15 downto 1), 
		i2s_mclk_o		=> open, --i2s_mclk_o,
		i2s_lrclk_o		=> audio_lrclk,
		i2s_bclk_o		=> audio_blck,
		i2s_d_o			=> audio_sdata
	); 
    
    
--    hdmi0: entity work.vga_to_hdmi
--      port map (
--        select_44100 => '0', -- 48.0 kHz audio
--        dvi => '0',   -- Enable HDMI-style audio
--        vic => std_logic_vector(to_unsigned(17,8)), -- CEA/CTA VIC 17=576p50 PAL, 2 = 480p60 NTSC
--        aspect => "01", -- 01=4:3, 10=16:9
--        pix_rep => '0', -- no pixel repetition
--        vs_pol => '1',  -- 1=active high
--        hs_pol => '1',
--
--        vga_rst => reset_high, -- active high reset
--        vga_clk => clock27, -- VGA pixel clock
--        vga_vs => v_vsync, -- active high vsync
--        vga_hs => v_vga_hsync, -- active high hsync
--        vga_de => hdmi_dataenable,   -- pixel enable
--        vga_r => std_logic_vector(v_red),
--        vga_g => std_logic_vector(v_green),
--        vga_b => std_logic_vector(v_blue),
--
--        -- XXX For now the audio stuff is all dummy
--        pcm_rst => pcm_rst, -- active high audio reset
--        pcm_clk => pcm_clk, -- audio clock at fs
--        pcm_clken => pcm_clken, -- audio clock enable
--        pcm_l => pcm_l,
--        pcm_r => pcm_r,
--        pcm_acr => pcm_acr, -- 1KHz
--        pcm_n => pcm_n, -- ACR N value
--        pcm_cts => pcm_cts, -- ACR CTS value
--
--        tmds => tmds
--        );
--   
--     -- serialiser: in this design we use TMDS SelectIO outputs
--    GEN_HDMI_DATA: for i in 0 to 2 generate
--    begin
--        HDMI_DATA: entity work.serialiser_10to1_selectio
--            port map (
--                clk_x10  => clock270,
--                d       => tmds(i),
--                out_p   => TMDS_data_p(i),
--                out_n   => TMDS_data_n(i)
--            );
--    end generate GEN_HDMI_DATA;
--    HDMI_CLK: entity work.serialiser_10to1_selectio
--        port map (
--            clk_x10  => clock270,
--            d       => "0000011111",
--            out_p   => TMDS_clk_p,
--            out_n   => TMDS_clk_n
--        );

    
--    fpgatemp0: entity work.fpgatemp
--      generic map (DELAY_CYCLES => 480)
--      port map (
--        rst => '0',
--        clk => cpuclock,
--        temp => fpga_temperature);

    kbd0: entity work.mega65kbd_to_matrix
      port map (
        cpuclock => cpuclock,
        
        disco_led_en => disco_led_en,
        disco_led_id => disco_led_id,
        disco_led_val => disco_led_val,
        
        powerled => '1',
        flopled0 => flopled0_drive,
        flopmotor => flopmotor_drive,
            
--      kio8 => kb_io0,
--      kio9 => kb_io1,
        kio10 => '1', -- no keys pressed

        matrix_col => widget_matrix_col,
        matrix_col_idx => widget_matrix_col_idx,
        restore => widget_restore,
        fastkey_out => fastkey,
        capslock_out => widget_capslock,
        upkey => keyup,
        leftkey => keyleft,

        flopled2 => flopled2_drive,
        flopledsd => flopledsd_drive,
        eth_load_enable => eth_load_enable
        );

   
--	altddio_out_sdram_inst : work.altddio_out_sdram 
--	  PORT MAP (
--		aclr	      => '0',
--		datain_h	   => "0",
--		datain_l	   => "1",
--		oe	         => '1',
--		outclock	   => clock162,
--		outclocken	=> '1',
--		dataout(0)  => sdram_clk
--	);
	 
   sdram_clk <= clock162m;

--  altddio_out #(
--    .extend_oe_disable("OFF"),
--    .intended_device_family("Cyclone IV"),
--    .invert_output("OFF"),
--    .lpm_hint("UNUSED"),
--    .lpm_type("altddio_out"),
--    .oe_reg("UNREGISTERED"),
--    .power_up_high("OFF"),
--    .width(1)
--   )
--   sdramclk_ddr (
--    .datain_h(1'b0),
--    .datain_l(1'b1),
--    .outclock(clk),
--    .dataout(SDRAM_CLK),
--    .aclr(1'b0),
--    .aset(1'b0),
--    .oe(1'b1),
--    .outclocken(1'b1),
--    .sclr(1'b0),
--    .sset(1'b0)
--   );
		  
  sdramctl0:
  if true generate
  sdramctrl0: entity work.sdram_controller
    port map (
      pixelclock => pixelclock,
      identical_clocks => sdram_slow_clock,
      clock162 => clock162,
      clock162r => clock162m,

      -- XXX Debug by showing if expansion RAM unit is receiving requests or not
--      request_counter => led,

      viciv_addr => hyper_addr,
      viciv_request_toggle => hyper_request_toggle,
      viciv_data_out => sdram_data,
      viciv_data_strobe => sdram_data_strobe,

      -- reset => reset_out,
      address => expansionram_address,
      wdata => expansionram_wdata,
      read_request => expansionram_read,
      write_request => expansionram_write,
      rdata => sdram_rdata,
      data_ready_toggle => sdram_data_ready_toggle,
      busy => sdram_busy,

      current_cache_line => sdram_cache_line,
      current_cache_line_address => sdram_cache_line_address,
      current_cache_line_valid => sdram_cache_line_valid,
      expansionram_current_cache_line_next_toggle  => expansionram_current_cache_line_next_toggle,
      expansionram_current_cache_line_prev_toggle  => expansionram_current_cache_line_prev_toggle,


      sdram_a => sdram_a,
      sdram_ba => sdram_ba,
      sdram_dq => sdram_dq,
      sdram_cke => sdram_cke,
      sdram_cs_n => sdram_cs_n,
      sdram_ras_n => sdram_ras_n,
      sdram_cas_n => sdram_cas_n,
      sdram_we_n => sdram_we_n,
      sdram_dqml => sdram_dqml,
      sdram_dqmh => sdram_dqmh

      );
  end generate;

  
    slow_devices0: entity work.slow_devices
      generic map (
        target => wukong
        )
      port map (
        cpuclock => cpuclock,
        pixelclock => pixelclock,
        reset => iec_reset_drive,
        cpu_exrom => cpu_exrom,
        cpu_game => cpu_game,
        sector_buffer_mapped => sector_buffer_mapped,
        
        cart_nmi => '1',
        cart_irq => '1',
        cart_dma => '1',
        
        cart_exrom => cart_exrom,
        cart_ba => cart_ba,
        cart_rw => cart_rw,
        cart_roml => cart_roml,
        cart_romh => cart_romh,
        cart_io1 => cart_io1,
        cart_game => cart_game,
        cart_io2 => cart_io2,
        
        cart_d_in => cart_d_read,
        cart_d => cart_d,
        cart_a => cart_a,
        
        irq_out => irq_out,
        nmi_out => nmi_out,
        
        joya => joy3,
        joyb => joy4,
        
        fm_left => fm_left,
        fm_right => fm_right,
        
--      cart_busy => led,
        cart_access_count => cart_access_count,
        
        slow_access_request_toggle => slow_access_request_toggle,
        slow_access_ready_toggle => slow_access_ready_toggle,
        slow_access_write => slow_access_write,
        slow_access_address => slow_access_address,
        slow_access_wdata => slow_access_wdata,
        slow_access_rdata => slow_access_rdata,
        
        slow_prefetched_address => slow_prefetched_address,
        slow_prefetched_data => slow_prefetched_data,
        slow_prefetched_request_toggle => slow_prefetched_request_toggle,
        
        ----------------------------------------------------------------------
        -- Expansion RAM interface (upto 127MB)
        ----------------------------------------------------------------------
--        expansionram_busy => '1',
--        expansionram_data_ready_toggle => '1'
        expansionram_data_ready_toggle => expansionram_data_ready_toggle,
        expansionram_busy => expansionram_busy,
        expansionram_read => expansionram_read,
        expansionram_write => expansionram_write,
        expansionram_address => expansionram_address,
        expansionram_rdata => expansionram_rdata,
        expansionram_wdata => expansionram_wdata,

        expansionram_current_cache_line => expansionram_current_cache_line,
        expansionram_current_cache_line_address => expansionram_current_cache_line_address
--      expansionram_current_cache_line_valid => current_cache_line_valid,
        
		  ----------------------------------------------------------------------
      -- Expansion/cartridge port
      ----------------------------------------------------------------------
--        cart_ctrl_dir => cart_ctrl_dir,
--        cart_ctrl_en => cart_ctrl_en,
--        cart_haddr_dir => cart_haddr_dir,
--        cart_laddr_dir => cart_laddr_dir,
--        cart_data_dir => cart_data_dir,
--        cart_data_en => cart_data_en,
--        cart_addr_en => cart_addr_en,
--        cart_phi2 => cart_phi2,
--        cart_dotclock => cart_dotclock,
--        cart_reset => cart_reset_int,
--
--        cart_nmi => cart_nmi,
--        cart_irq => cart_irq,
--        cart_dma => cart_dma,
--
--        cart_exrom => cart_exrom,
--        cart_ba => cart_ba,
--        cart_rw => cart_rw,
--        cart_roml => cart_roml_int,
--        cart_romh => cart_romh_int,
--        cart_io1 => cart_io1,
--        cart_game => cart_game,
--        cart_io2 => cart_io2,
--
--        cart_d_in => cart_d,
--        cart_d => cart_d,
--        cart_a => cart_a
        );
  end generate;
    
  red_s_n <= red_s;
  green_s_n <= green_s;
  blue_s_n <= blue_s;
  
  --debug(0) <= clock27;
  --debug(1) <= cpuclock;
  --debug(2) <= clock270;
  --debug(3) <= clock135p;
  --debug(4) <= clock135n;

  
  pd0: if false generate
    pixeldriver0: entity work.pixel_driver port map (
      cpuclock => cpuclock,
      clock81 => pixelclock,
      clock27 => clock27,
      
      pal50_select => '1', --KEY1,
      vga60_select => '0',
      test_pattern_enable => '1',
      hsync_invert => '0',
      vsync_invert => '0',
      narrow_dataenable => hdmi_dataenable,

      red_i => to_unsigned(0,8),
      green_i => to_unsigned(0,8),
      blue_i => to_unsigned(0,8),

      std_logic_vector(red_o) => v_red,
      std_logic_vector(green_o) => v_green,
      std_logic_vector(blue_o) => v_blue,
      vga_hsync => v_vga_hsync,
      vsync => v_vsync,
      vga_blank   => vga_blank

  );

  end generate;
  
  m0: if true generate
  machine0: entity work.machine
    generic map (cpu_frequency => clock_frequency, --MYM Antes 40500000,
                 target => wukong,
					  -- MEGA65R3 - R5 has A200T which has plenty of spare BRAM.
                     -- We can thus increase the number of eth RX buffers from
                     -- 4x2KB to 32x2KB = 64KB.
                     -- This will, inpractice, allow the reception of ~32x1.3K
                     -- = ~40KB of data in a burst, before the RX buffers are
                     -- filled.
                 num_eth_rx_buffers => 16,
                 hyper_installed => true --true -- For VIC-IV to know it can use
                                         -- hyperram for full-colour glyphs
                 )                 
    port map (
      pixelclock      => pixelclock,
      cpuclock        => cpuclock,
      uartclock       => cpuclock, -- Match CPU clock
      clock162 => clock162,
      clock200 => clock200,
      clock27 => clock27,
      clock50mhz      => ethclock,

	   sdram_t_or_hyperram_f => sdram_t_or_hyperram_f,
      sdram_slow_clock => sdram_slow_clock,
		
		eth_load_enabled => eth_load_enable,
		
----      hyper_addr => hyper_addr,
----      hyper_request_toggle => hyper_request_toggle,
--      hyper_data => (others => 'Z'),
--      hyper_data_strobe => '1',
      
		hyper_addr => hyper_addr,
      hyper_request_toggle => hyper_request_toggle,
      hyper_data => viciv_attic_data,
      hyper_data_strobe => viciv_attic_data_strobe,
		
      fast_key => fastkey,
      
      btncpureset => btncpureset,
      reset_out => reset_out,
      irq => irq_combined,
      nmi => nmi_combined,
      restore_key => restore_key,
      sector_buffer_mapped => sector_buffer_mapped,

      qspi_clock => qspi_clock,
      qspicsn => qspicsn,
      qspidb => qspidb_out,
      qspidb_in => qspidb_in,
      qspidb_oe => qspidb_oe,
      
      joy3 => joy3,
      joy4 => joy4,

      fm_left => fm_left,
      fm_right => fm_right,
      
      no_hyppo => '0',

      vga_blank => vga_blank,
      vsync           => v_vsync,
      vga_hsync       => v_vga_hsync,
      vgared          => v_red,
      vgagreen        => v_green,
      vgablue         => v_blue,
--      hdmi_sda        => hdmi_sda,
--      hdmi_scl        => hdmi_scl,
--      hpd_a           => hpd_a,
      lcd_dataenable => lcd_dataenable,
      hdmi_dataenable =>  hdmi_dataenable,
      
      ----------------------------------------------------------------------
      -- CBM floppy  std_logic_vectorerial port
      ----------------------------------------------------------------------
      iec_clk_en => iec_clk_en_drive,
      iec_data_en => iec_data_en_drive,
      iec_data_o => iec_data_o_drive,
      iec_reset => iec_reset_drive,
      iec_clk_o => iec_clk_o_drive,
      iec_data_external => iec_data_i_drive,
      iec_clk_external => iec_clk_i_drive,
      iec_atn_o => iec_atn_drive,
      iec_bus_active => '0', -- No IEC port on this target

--      buffereduart_rx => '1',
      buffereduart_ringindicate => (others => '0'),

      porta_pins => column(7 downto 0),
      portb_pins => row(7 downto 0),
      keyboard_column8 => column(8),
      --porta_pins => porta_pins,
      --portb_pins => portb_pins,
      --keyboard_column8 => column8,
      caps_lock_key => '1',
      keyleft => keyleft,
      keyup => keyup,

      fa_fire => fa_fire_drive,
      fa_up => fa_up_drive,
      fa_left => fa_left_drive,
      fa_down => fa_down_drive,
      fa_right => fa_right_drive,

      fb_fire => fb_fire_drive,
      fb_up => fb_up_drive,
      fb_left => fb_left_drive,
      fb_down => fb_down_drive,
      fb_right => fb_right_drive,

      fa_potx => fa_potx,
      fa_poty => fa_poty,
      fb_potx => fb_potx,
      fb_poty => fb_poty,
      pot_drain => pot_drain,
      pot_via_iec => pot_via_iec,

      f_index => '1',
      f_track0 => '1',
      f_writeprotect => '1',
      f_rdata => '1',
      f_diskchanged => '1',

      ---------------------------------------------------------------------------
      -- IO lines to the ethernet controller
      ---------------------------------------------------------------------------
      eth_mdio => eth_mdio,
      eth_mdc => eth_mdc,
      eth_reset => eth_reset,
      eth_rxd => eth_rxd,
      eth_txd => eth_txd,
      eth_txen => eth_txen,
      eth_rxer => eth_rxer,
      eth_rxdv => eth_rxdv,
      eth_interrupt => '0',
      
      -------------------------------------------------------------------------
      -- Lines for the SDcard interfaces
      -------------------------------------------------------------------------
      -- External one is bus 0, so that it has priority.
      -- Internal SD card:
      cs_bo => sdReset,
      sclk_o => sdClock,
      mosi_o => sdMOSI,
      miso_i => sdMISO,
      --miso_i => '1',
      -- External microSD
      cs2_bo => sd2reset,
      sclk2_o => sd2Clock,
      mosi2_o => sd2MOSI,
      miso2_i => sd2MISO,

      slow_access_request_toggle => slow_access_request_toggle,
      slow_access_ready_toggle => slow_access_ready_toggle,
      slow_access_address => slow_access_address,
      slow_access_write => slow_access_write,
      slow_access_wdata => slow_access_wdata,
      slow_access_rdata => slow_access_rdata,

      slow_prefetched_address => slow_prefetched_address,
      slow_prefetched_data => slow_prefetched_data,
      slow_prefetched_request_toggle => slow_prefetched_request_toggle,
      
		slowram_cache_line => expansionram_current_cache_line,
      slowram_cache_line_valid => expansionram_current_cache_line_valid,
      slowram_cache_line_addr => expansionram_current_cache_line_address,
      slowram_cache_line_inc_toggle => expansionram_current_cache_line_next_toggle,
      slowram_cache_line_dec_toggle => expansionram_current_cache_line_prev_toggle,
	
      cpu_exrom => cpu_exrom,      
      cpu_game => cpu_game,
      cart_access_count => cart_access_count,

--      aclMISO => aclMISO,
      aclMISO => '1',
--      aclMOSI => aclMOSI,
--      aclSS => aclSS,
--      aclSCK => aclSCK,
--      aclInt1 => aclInt1,
--      aclInt2 => aclInt2,
      aclInt1 => '1',
      aclInt2 => '1',
    
      micData0 => '1',
      micData1 => '1',
--      micClk => micClk,
--      micLRSel => micLRSel,

      disco_led_en => disco_led_en,
      disco_led_id => disco_led_id,
      disco_led_val => disco_led_val,      
      
      flopled0 => flopled0_drive,
      flopled2 => flopled2_drive,
      flopledsd => flopledsd_drive,
      flopmotor => flopmotor_drive,
      ampPWM_l => pwm_l_drive,
      ampPWM_r => pwm_r_drive,
      ampSD => pcspeaker_muten,
      pcspeaker_left => pcspeaker_left_drive,
      audio_left => audio_left,
      audio_right => audio_right,

      -- Normal connection of I2C peripherals to dedicated address space
      i2c1sda => fpga_sda,
      i2c1scl => fpga_scl,

--      tmpsda => fpga_sda,
--      tmpscl => fpga_scl,

      portp_out => portp,
      
      -- No PS/2 keyboard for now
      ps2data =>      ps2data,
      ps2clock =>     ps2clk,

      fpga_temperature => fpga_temperature,
      
      --UART_TXD => UART_TXD_mon,
      --RsRx => RsRx,

      uart_txd_mon => uart_txd_mon,
      uart_rxd_mon => uart_rxd_mon,
      
      uart_rx => uart_rx,
      uart_tx => uart_tx,

      -- Ignore widget board interface and other things
      tmpint => '1',
      tmpct => '1',

      -- Connect MEGA65 smart keyboard via JTAG-like remote GPIO interface
      widget_matrix_col_idx => widget_matrix_col_idx,
      widget_matrix_col => widget_matrix_col,
      widget_restore => widget_restore,
      widget_capslock => widget_capslock,
      widget_joya => (others => '1'),
      widget_joyb => (others => '1'),      

      dipsw => "00000", --"00100",
      sw => (others => '0'),--"1001000000000000",--(others => '0'),
      btn => (others => '1'),

      iec_srq_external => '0',
      kbd_commit => (others => '0'),
      kbd_datestamp => (others => '0'),
      max10_fpga_commit => (others => '0'),
      max10_fpga_date => (others => '0')
      );
  end generate;

  qspidb <= qspidb_out when qspidb_oe='1' else "ZZZZ";
  qspidb_in <= qspidb;

--  process (pixelclock,cpuclock,pcm_clk,
--           irq,irq_out,nmi,nmi_out,
--           audio_right,audio_left, 
--			  sdram_t_or_hyperram_f) is
  process (pixelclock,cpuclock,pcm_clk,sdram_t_or_hyperram_f) is
  begin
    --vdac_sync_n <= '0';  -- no sync on green
    vdac_blank_n <= '1'; -- was: not (v_hsync or v_vsync);

    -- VGA output at full pixel clock
    vdac_clk <= pixelclock;

	 
	  if sdram_t_or_hyperram_f = true then
      expansionram_current_cache_line <= sdram_cache_line;
      expansionram_current_cache_line_valid <= sdram_cache_line_valid;
      expansionram_current_cache_line_address <= sdram_cache_line_address;
      expansionram_busy <= sdram_busy;
      expansionram_data_ready_toggle <= sdram_data_ready_toggle;
      expansionram_rdata <= sdram_rdata;
      viciv_attic_data_strobe <= sdram_data_strobe;
      viciv_attic_data <= sdram_data;
    else
      expansionram_current_cache_line <= hyperram_cache_line;
      expansionram_current_cache_line_valid <= hyperram_cache_line_valid;
      expansionram_current_cache_line_address <= hyperram_cache_line_address;
      expansionram_busy <= hyperram_busy;
      expansionram_data_ready_toggle <= hyperram_data_ready_toggle;
      expansionram_rdata <= hyperram_rdata;
      viciv_attic_data_strobe <= hyper_data_strobe;
      viciv_attic_data <= hyper_data;
    end if;
	 
	 	 
    -- HDMI output at 27MHz
--    hdmi_clk <= clock27;

    -- Ethernet clock at 50MHz
    eth_clock <= ethclock;

    -- Use both real and cartridge IRQ and NMI signals
    irq_combined <= irq and irq_out;
    nmi_combined <= nmi and nmi_out;
    
    if rising_edge(pcm_clk) then
      -- Generate 1KHz ACR pulse train from 12.288MHz
      if acr_counter /= (12288 - 1) then
        acr_counter <= acr_counter + 1;
        pcm_acr <= '0';
      else
        pcm_acr <= '1';
        acr_counter <= 0;
      end if;
    end if;

    -- Drive most ports, to relax timing
    if rising_edge(cpuclock) then

      reset_high <= not btncpureset;
      
      -- We need to pass audio to 12.288 MHz clock domain.
      -- Easiest way is to hold samples constant for 16 ticks, and
      -- have a slow toggle
      -- At 40.5MHz and 48KHz sample rate, we have a ratio of 843.75
      -- Thus we need to calculate the remainder, so that we can get the
      -- sample rate EXACTLY 48KHz.
      -- Otherwise we end up using 844, which gives a sample rate of
      -- 40.5MHz / 844 = 47.986KHz, which might just be enough to throw
      -- some monitors out, since it means that the CTS / N rates will
      -- be wrong.
      -- (Or am I just chasing my tail, because this is only used to set the
      -- rate at which we LATCH the samples?)
      if audio_counter < to_integer(audio_counter_interval) then
        audio_counter <= audio_counter + 4;
      else
        audio_counter <= audio_counter - to_integer(audio_counter_interval);
        sample_ready_toggle <= not sample_ready_toggle;
        audio_left_slow <= h_audio_left;
        audio_right_slow <= h_audio_right;
      end if;
      
      segled_counter <= segled_counter + 1;
      led2 <= segled_counter(22);
      
--      led <= cart_exrom;
--      led <= flopled_drive;
      
      fa_left_drive <= fa_left;
      fa_right_drive <= fa_right;
      fa_up_drive <= fa_up;
      fa_down_drive <= fa_down;
      fa_fire_drive <= fa_fire;  
      fb_left_drive <= fb_left;
      fb_right_drive <= fb_right;
      fb_up_drive <= fb_up;
      fb_down_drive <= fb_down;
      fb_fire_drive <= fb_fire;  

      -- The CIAs drive these lines naively, so we need to apply the inverters
      -- on the outputs here, and also deal with the particulars of how the
      -- MEGA65 PCB drives these lines.
      -- Note that the MEGA65 PCB lacks pull-ups on these lines, and relies on
      -- the connected disk drive(s) having pull-ups of their own.
      -- Here is the truth table for behaviour with a pull-up on the pin:
      -- +----+-----++----+
      -- | _o | _en || _i |
      -- +----+-----++----+
      -- |  0 |   X || 0  |
      -- |  1 |   0 || 1* |
      -- |  1 |   1 || 1  |
      -- +----+-----++----+
      -- * Value provided by pin up, or equivalently device on the bus
      --
      -- End result is simple: Invert output bit, and copy output enable
      -- Except, that the CIA always thinks it is driving the line, so
      -- we need to ignore the _en lines, and instead use the _o lines
      -- (before inversion) to indicate when we should be driving the pin
      -- to ground.

      iec_reset <= iec_reset_drive;
      iec_atn <= not iec_atn_drive;

      if pot_via_iec = '0' then
        -- Normal IEC port operation
        iec_clk_en <= iec_clk_o_drive;
        iec_clk_o <= not iec_clk_o_drive;
        iec_clk_i_drive <= iec_clk_i;
        iec_data_en <= iec_data_o_drive;
        iec_data_o <= not iec_data_o_drive;
        iec_data_i_drive <= iec_data_i;
        -- So pots act like infinite resistance
        fa_potx <= '0';
        fa_poty <= '0';
        fb_potx <= '0';
        fb_poty <= '0';
      else
        -- IEC lines being used as POT inputs
        iec_clk_i_drive <= '1';
        iec_data_i_drive <= '1';
        if pot_drain = '1' then
          -- IEC lines being used to drain pots
          iec_clk_en <= '1';
          iec_clk_o <= '0';
          iec_data_en <= '1';
          iec_data_o <= '0';
        else
          -- Stop draining
          iec_clk_en <= '0';
          iec_clk_o <= '0';
          iec_data_en <= '0';
          iec_data_o <= '0';
        end if;
        -- Copy IEC input values to POT inputs
        fa_potx <= iec_data_i;
        fa_poty <= iec_clk_i;
        fb_potx <= iec_data_i;
        fb_poty <= iec_clk_i;
      end if;

--      pwm_l <= pwm_l_drive;
--      pwm_r <= pwm_r_drive;
--      pcspeaker_left <= pcspeaker_left_drive;
      
    end if;

    h_audio_right <= audio_right;
    h_audio_left <= audio_left;
    -- toggle signed/unsigned audio flipping
    if portp(7)='1' then
      h_audio_right(19) <= not audio_right(19);
      h_audio_left(19) <= not audio_left(19);
    end if;

    
--    if portp(3)='1' then
--      hdmi_is_progressive <= true;
--    else
--      hdmi_is_progressive <= false;
--    end if;
--    if portp(4)='1' then
--      hdmi_is_pal <= true;
--    else
--      hdmi_is_pal <= false;
--    end if;
--    if portp(5)='1' then
--      hdmi_is_30khz <= true;
--    else
--      hdmi_is_30khz <= false;
--    end if;
--    if portp(6)='1' then
--      hdmi_is_limited <= true;
--    else
--      hdmi_is_limited <= false;
--    end if;
--    if portp(7)='1' then
--      hdmi_is_widescreen <= true;
--    else
--      hdmi_is_widescreen <= false;
--    end if;
  
  
    if rising_edge(pixelclock) then
      hsync <= v_vga_hsync;
      vsync <= v_vsync;
		
      vgared <= v_red;
      vgagreen <= v_green;
      vgablue <= v_blue;
		
--   vga_r_s <= v_red; 
--	  vga_g_s <= v_green;
--	  vga_b_s <= v_blue;
--	  vga_grey <= not dna_equal; 
--	  
--	  case vga_grey is
--		      --color
--	      when '0' =>  vga_r_o	<= vga_r_s; 
--	    	           vga_g_o	<= vga_g_s;
--					   vga_b_o	<= vga_b_s;
--				--gray
--		  when '1' =>  vga_r_o	<=  y_grey(9 downto 2);
--				       vga_g_o  <=  y_grey(9 downto 2);
--					   vga_b_o 	<=  y_grey(9 downto 2);
--	  end case;
	  
      hdmired <= v_red;
      hdmigreen <= v_green;
      hdmiblue <= v_blue;
    end if;

    -- XXX DEBUG: Allow showing audio samples on video to make sure they are
    -- getting through
--    if portp(2)='1' then
--      vgagreen <= unsigned(audio_left(15 downto 8));
--      vgared <= unsigned(audio_right(15 downto 8));
--      hdmigreen <= unsigned(audio_left(15 downto 8));
--      hdmired <= unsigned(audio_right(15 downto 8));
--    end if;
    
  end process;    
  
end Behavioral;
