-- megafunction wizard: %ROM: 2-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altsyncram 

-- ============================================================
-- File Name: Resolve_VDC2VICIV_2Port.vhd
-- Megafunction Name(s):
-- 			altsyncram
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 17.1.0 Build 590 10/25/2017 SJ Lite Edition
-- ************************************************************


--Copyright (C) 2017  Intel Corporation. All rights reserved.
--Your use of Intel Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Intel Program License 
--Subscription Agreement, the Intel Quartus Prime License Agreement,
--the Intel FPGA IP License Agreement, or other applicable license
--agreement, including, without limitation, that your use is for
--the sole purpose of programming logic devices manufactured by
--Intel and sold by Intel or its authorized distributors.  Please
--refer to the applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Resolve_VDC2VICIV_2Port IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END Resolve_VDC2VICIV_2Port;


ARCHITECTURE SYN OF resolve_vdc2viciv_2port IS

	SIGNAL sub_wire0_bv	: BIT_VECTOR (15 DOWNTO 0);
	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL sub_wire1	: STD_LOGIC ;
	SIGNAL sub_wire2	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL sub_wire3	: STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
	sub_wire0_bv(15 DOWNTO 0) <= "0000000000000000";
	sub_wire0    <= To_stdlogicvector(sub_wire0_bv);
	sub_wire1    <= '0';
	q_a    <= sub_wire2(15 DOWNTO 0);
	q_b    <= sub_wire3(15 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_reg_b => "CLOCK0",
		clock_enable_input_a => "BYPASS",
		clock_enable_input_b => "BYPASS",
		clock_enable_output_a => "BYPASS",
		clock_enable_output_b => "BYPASS",
		indata_reg_b => "CLOCK0",
		init_file => "Resolve_VDP2VICIV.mif",
		intended_device_family => "Cyclone IV GX",
		lpm_type => "altsyncram",
		numwords_a => 65536,
		numwords_b => 65536,
		operation_mode => "BIDIR_DUAL_PORT",
		outdata_aclr_a => "NONE",
		outdata_aclr_b => "NONE",
		outdata_reg_a => "CLOCK0",
		outdata_reg_b => "CLOCK0",
		power_up_uninitialized => "FALSE",
		widthad_a => 16,
		widthad_b => 16,
		width_a => 16,
		width_b => 16,
		width_byteena_a => 1,
		width_byteena_b => 1,
		wrcontrol_wraddress_reg_b => "CLOCK0"
	)
	PORT MAP (
		address_a => address_a,
		address_b => address_b,
		clock0 => clock,
		data_a => sub_wire0,
		data_b => sub_wire0,
		wren_a => sub_wire1,
		wren_b => sub_wire1,
		q_a => sub_wire2,
		q_b => sub_wire3
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "1"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLRdata NUMERIC "0"
-- Retrieval info: PRIVATE: CLRq NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrren NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwren NUMERIC "0"
-- Retrieval info: PRIVATE: Clock NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_A NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_B NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "1"
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: MEMSIZE NUMERIC "1048576"
-- Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
-- Retrieval info: PRIVATE: MIFfilename STRING "Resolve_VDP2VICIV.mif"
-- Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "3"
-- Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "1"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
-- Retrieval info: PRIVATE: REGdata NUMERIC "1"
-- Retrieval info: PRIVATE: REGq NUMERIC "1"
-- Retrieval info: PRIVATE: REGrdaddress NUMERIC "0"
-- Retrieval info: PRIVATE: REGrren NUMERIC "0"
-- Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGwren NUMERIC "1"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: USE_DIFF_CLKEN NUMERIC "0"
-- Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
-- Retrieval info: PRIVATE: VarWidth NUMERIC "0"
-- Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "16"
-- Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "16"
-- Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "16"
-- Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "16"
-- Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "1"
-- Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: enable NUMERIC "0"
-- Retrieval info: PRIVATE: rden NUMERIC "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: ADDRESS_REG_B STRING "CLOCK0"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_A STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_B STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_A STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_B STRING "BYPASS"
-- Retrieval info: CONSTANT: INDATA_REG_B STRING "CLOCK0"
-- Retrieval info: CONSTANT: INIT_FILE STRING "Resolve_VDP2VICIV.mif"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
-- Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "65536"
-- Retrieval info: CONSTANT: NUMWORDS_B NUMERIC "65536"
-- Retrieval info: CONSTANT: OPERATION_MODE STRING "BIDIR_DUAL_PORT"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_B STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_REG_A STRING "CLOCK0"
-- Retrieval info: CONSTANT: OUTDATA_REG_B STRING "CLOCK0"
-- Retrieval info: CONSTANT: POWER_UP_UNINITIALIZED STRING "FALSE"
-- Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "16"
-- Retrieval info: CONSTANT: WIDTHAD_B NUMERIC "16"
-- Retrieval info: CONSTANT: WIDTH_A NUMERIC "16"
-- Retrieval info: CONSTANT: WIDTH_B NUMERIC "16"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_B NUMERIC "1"
-- Retrieval info: CONSTANT: WRCONTROL_WRADDRESS_REG_B STRING "CLOCK0"
-- Retrieval info: USED_PORT: address_a 0 0 16 0 INPUT NODEFVAL "address_a[15..0]"
-- Retrieval info: USED_PORT: address_b 0 0 16 0 INPUT NODEFVAL "address_b[15..0]"
-- Retrieval info: USED_PORT: clock 0 0 0 0 INPUT VCC "clock"
-- Retrieval info: USED_PORT: q_a 0 0 16 0 OUTPUT NODEFVAL "q_a[15..0]"
-- Retrieval info: USED_PORT: q_b 0 0 16 0 OUTPUT NODEFVAL "q_b[15..0]"
-- Retrieval info: CONNECT: @address_a 0 0 16 0 address_a 0 0 16 0
-- Retrieval info: CONNECT: @address_b 0 0 16 0 address_b 0 0 16 0
-- Retrieval info: CONNECT: @clock0 0 0 0 0 clock 0 0 0 0
-- Retrieval info: CONNECT: @data_a 0 0 16 0 GND 0 0 16 0
-- Retrieval info: CONNECT: @data_b 0 0 16 0 GND 0 0 16 0
-- Retrieval info: CONNECT: @wren_a 0 0 0 0 GND 0 0 0 0
-- Retrieval info: CONNECT: @wren_b 0 0 0 0 GND 0 0 0 0
-- Retrieval info: CONNECT: q_a 0 0 16 0 @q_a 0 0 16 0
-- Retrieval info: CONNECT: q_b 0 0 16 0 @q_b 0 0 16 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL Resolve_VDC2VICIV_2Port.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL Resolve_VDC2VICIV_2Port.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL Resolve_VDC2VICIV_2Port.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL Resolve_VDC2VICIV_2Port.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL Resolve_VDC2VICIV_2Port_inst.vhd FALSE
-- Retrieval info: LIB_FILE: altera_mf
