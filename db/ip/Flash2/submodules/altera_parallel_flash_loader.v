// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//Copyright (C) 1991-2014 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module altera_parallel_flash_loader (
	pfl_flash_access_granted,
	pfl_nreset,
	fpga_conf_done,
	fpga_nstatus,
	fpga_pgm,
	pfl_clk,
	pfl_nreconfigure,
	pfl_reset_watchdog,
	flash_rdy,

	pfl_flash_access_request,
	fpga_data,
	fpga_dclk,
	fpga_nconfig,	
	pfl_watchdog_error,
	flash_addr,
	flash_nreset,
	flash_ncs,
	flash_sck,
	flash_ale,
	flash_cle,
	flash_nce,
	flash_noe,
	flash_nwe,
	flash_clk,
	flash_nadv,

	flash_data,
	flash_io0,
	flash_io1,
	flash_io2,
	flash_io3,
	flash_io);
	
	parameter
		// General
		FLASH_TYPE = "CFI_FLASH",
		N_FLASH = 1,
		FLASH_DATA_WIDTH = 16,
		ADDR_WIDTH = 20,
		FEATURES_PGM = 1,
		FEATURES_CFG = 0,
		TRISTATE_CHECKBOX = 0,
		
		// General (Configuration)
		OPTION_BITS_START_ADDRESS = 0,
		SAFE_MODE_HALT = 0,
		SAFE_MODE_RETRY = 1,
		SAFE_MODE_REVERT = 0,
		SAFE_MODE_REVERT_ADDR = 0,
		CONF_DATA_WIDTH = 1,
		DCLK_DIVISOR = 1,
		CONF_WAIT_TIMER_WIDTH = 16,
		DECOMPRESSOR_MODE = "NONE",
		PFL_RSU_WATCHDOG_ENABLED = 0,
		RSU_WATCHDOG_COUNTER = 100000000,
		
		// CFI Flash (Flash Programming)
		ENHANCED_FLASH_PROGRAMMING = 0,
		FIFO_SIZE = 16,
		DISABLE_CRC_CHECKBOX = 0,
		
		// CFI Flash (Configuration)
		CLK_DIVISOR = 1,
		PAGE_CLK_DIVISOR = 1,
		NORMAL_MODE = 1,
		BURST_MODE = 0,
		PAGE_MODE = 0,
		BURST_MODE_INTEL = 0,
		BURST_MODE_SPANSION = 0,
		BURST_MODE_NUMONYX = 0,
		FLASH_NRESET_CHECKBOX = 0,
		FLASH_NRESET_COUNTER = 1,
		FLASH_BURST_EXTRA_CYCLE = 0,
		BURST_MODE_LATENCY_COUNT = 4,
		
		// Quad Flash (General)
		QFLASH_MFC = "ALTERA",
		EXTRA_ADDR_BYTE = 0,
		QSPI_DATA_DELAY = 0,
		QSPI_DATA_DELAY_COUNT = 1,
		QFLASH_FAST_SPEED = 0,
		FLASH_STATIC_WAIT_WIDTH = 15,
		
		// NAND Flash General
		NRB_ADDR = 65667072,
		FLASH_ECC_CHECKBOX = 0,
		NFLASH_MFC = "NUMONYX",
		US_UNIT_COUNTER = 1;


	// General
	input	pfl_nreset;
	input	pfl_flash_access_granted;
	output	pfl_flash_access_request;
	
	// General (Configuration)
	input	pfl_clk;
	input	fpga_nstatus;
	input	fpga_conf_done;
	input	pfl_nreconfigure;
	input	[2:0] fpga_pgm;
	input	pfl_reset_watchdog;
	output	fpga_nconfig;
	output	fpga_dclk;
	output	[CONF_DATA_WIDTH-1:0] fpga_data;
	output	pfl_watchdog_error;

	// CFI Flash (General)
	input	flash_rdy;
	inout	[FLASH_DATA_WIDTH-1:0] flash_data;
	output	[ADDR_WIDTH-1:0] flash_addr;
	output	flash_nreset;

	// Quad IO (General)
	output	[N_FLASH-1:0] flash_ncs;
	output	[N_FLASH-1:0] flash_sck;
	inout	[N_FLASH-1:0] flash_io0;
	inout	[N_FLASH-1:0] flash_io1;
	inout	[N_FLASH-1:0] flash_io2;
	inout	[N_FLASH-1:0] flash_io3;

	// NAND IO (General)
	inout	[7:0] flash_io;
	output	flash_cle;
	output	flash_ale;

	// CFI Flash (Flash Programming) -- shared by NAND
	output	[N_FLASH-1:0] flash_nce;
	output	flash_noe;
	output	flash_nwe;

	// CFI Flash (Configuration)
	output	flash_clk;
	output	flash_nadv;
		
	tri1	pfl_nreconfigure;
	tri1	pfl_reset_watchdog;


	wire	[ADDR_WIDTH-1:0] sub_wire0;
	wire	sub_wire1;
	wire	sub_wire2;
	wire	sub_wire3;
	wire	sub_wire4;
	wire	[N_FLASH-1:0] sub_wire5;
	wire	[N_FLASH-1:0] sub_wire6;
	wire	sub_wire7;
	wire	sub_wire8;
	wire	sub_wire9;
	wire	[N_FLASH-1:0] sub_wire10;
	wire	[CONF_DATA_WIDTH-1:0] sub_wire11;
	wire	sub_wire12;
	wire	sub_wire13;
	wire	sub_wire14;
	wire	sub_wire15;	
	
	wire	[ADDR_WIDTH-1:0] flash_addr = sub_wire0[ADDR_WIDTH-1:0];
	wire	flash_ale = sub_wire1;
	wire	flash_cle = sub_wire2;
	wire	flash_clk = sub_wire3;
	wire	flash_nadv = sub_wire4;
	wire	[N_FLASH-1:0] flash_nce = sub_wire5[N_FLASH-1:0];
	wire	[N_FLASH-1:0] flash_ncs = sub_wire6[N_FLASH-1:0];
	wire	flash_noe = sub_wire7;
	wire	flash_nreset = sub_wire8;
	wire	flash_nwe = sub_wire9;
	wire	[N_FLASH-1:0] flash_sck = sub_wire10[N_FLASH-1:0];
	wire	[CONF_DATA_WIDTH-1:0] fpga_data = sub_wire11[CONF_DATA_WIDTH-1:0];
	wire	fpga_dclk = sub_wire12;
	wire	fpga_nconfig = sub_wire13;
	wire	pfl_flash_access_request = sub_wire14;
	wire	pfl_watchdog_error = sub_wire15;

	altparallel_flash_loader	altparallel_flash_loader_component (
				.flash_rdy (flash_rdy),
				.fpga_conf_done (fpga_conf_done),
				.fpga_nstatus (fpga_nstatus),
				.fpga_pgm (fpga_pgm),
				.pfl_clk (pfl_clk),
				.pfl_flash_access_granted (pfl_flash_access_granted),
				.pfl_nreconfigure (pfl_nreconfigure),
				.pfl_nreset (pfl_nreset),
				.pfl_reset_watchdog (pfl_reset_watchdog),
				.flash_data (flash_data),
				.flash_io (flash_io),
				.flash_io0 (flash_io0),
				.flash_io1 (flash_io1),
				.flash_io2 (flash_io2),
				.flash_io3 (flash_io3),
				.flash_addr (sub_wire0),
				.flash_ale (sub_wire1),
				.flash_cle (sub_wire2),
				.flash_clk (sub_wire3),
				.flash_nadv (sub_wire4),
				.flash_nce (sub_wire5),
				.flash_ncs (sub_wire6),
				.flash_noe (sub_wire7),
				.flash_nreset (sub_wire8),
				.flash_nwe (sub_wire9),
				.flash_sck (sub_wire10),
				.fpga_data (sub_wire11),
				.fpga_dclk (sub_wire12),
				.fpga_nconfig (sub_wire13),
				.pfl_flash_access_request (sub_wire14),
				.pfl_watchdog_error (sub_wire15)
				);
	defparam
		altparallel_flash_loader_component.addr_width = ADDR_WIDTH,
		altparallel_flash_loader_component.burst_mode = BURST_MODE,
		altparallel_flash_loader_component.burst_mode_intel = BURST_MODE_INTEL,
		altparallel_flash_loader_component.BURST_MODE_LATENCY_COUNT = BURST_MODE_LATENCY_COUNT,
		altparallel_flash_loader_component.burst_mode_numonyx = BURST_MODE_NUMONYX,
		altparallel_flash_loader_component.burst_mode_spansion = BURST_MODE_SPANSION,
		altparallel_flash_loader_component.clk_divisor = CLK_DIVISOR,
		altparallel_flash_loader_component.conf_data_width = CONF_DATA_WIDTH,
		altparallel_flash_loader_component.conf_wait_timer_width = CONF_WAIT_TIMER_WIDTH,
		altparallel_flash_loader_component.dclk_divisor = DCLK_DIVISOR,
		altparallel_flash_loader_component.decompressor_mode = DECOMPRESSOR_MODE,
		altparallel_flash_loader_component.disable_crc_checkbox = DISABLE_CRC_CHECKBOX,
		altparallel_flash_loader_component.enhanced_flash_programming = ENHANCED_FLASH_PROGRAMMING,
		altparallel_flash_loader_component.extra_addr_byte = EXTRA_ADDR_BYTE,
		altparallel_flash_loader_component.features_cfg = FEATURES_CFG,
		altparallel_flash_loader_component.features_pgm = FEATURES_PGM,
		altparallel_flash_loader_component.fifo_size = FIFO_SIZE,
		altparallel_flash_loader_component.flash_burst_extra_cycle = FLASH_BURST_EXTRA_CYCLE,
		altparallel_flash_loader_component.flash_data_width = FLASH_DATA_WIDTH,
		altparallel_flash_loader_component.flash_ecc_checkbox = FLASH_ECC_CHECKBOX,
		altparallel_flash_loader_component.flash_nreset_checkbox = FLASH_NRESET_CHECKBOX,
		altparallel_flash_loader_component.flash_nreset_counter = FLASH_NRESET_COUNTER,
		altparallel_flash_loader_component.flash_static_wait_width = FLASH_STATIC_WAIT_WIDTH,
		altparallel_flash_loader_component.flash_type = FLASH_TYPE,
		altparallel_flash_loader_component.normal_mode = NORMAL_MODE,
		altparallel_flash_loader_component.nflash_mfc = NFLASH_MFC,
		altparallel_flash_loader_component.nrb_addr = NRB_ADDR,
		altparallel_flash_loader_component.n_flash = N_FLASH,
		altparallel_flash_loader_component.option_bits_start_address = OPTION_BITS_START_ADDRESS,
		altparallel_flash_loader_component.page_clk_divisor = PAGE_CLK_DIVISOR,
		altparallel_flash_loader_component.page_mode = PAGE_MODE,
		altparallel_flash_loader_component.pfl_rsu_watchdog_enabled = PFL_RSU_WATCHDOG_ENABLED,
		altparallel_flash_loader_component.qflash_fast_speed = QFLASH_FAST_SPEED,
		altparallel_flash_loader_component.qflash_mfc = QFLASH_MFC,
		altparallel_flash_loader_component.qspi_data_delay = QSPI_DATA_DELAY,
		altparallel_flash_loader_component.qspi_data_delay_count = QSPI_DATA_DELAY_COUNT,
		altparallel_flash_loader_component.rsu_watchdog_counter = RSU_WATCHDOG_COUNTER,
		altparallel_flash_loader_component.safe_mode_halt = SAFE_MODE_HALT,
		altparallel_flash_loader_component.safe_mode_retry = SAFE_MODE_RETRY,
		altparallel_flash_loader_component.safe_mode_revert = SAFE_MODE_REVERT,
		altparallel_flash_loader_component.safe_mode_revert_addr = SAFE_MODE_REVERT_ADDR,
		altparallel_flash_loader_component.tristate_checkbox = TRISTATE_CHECKBOX,
		altparallel_flash_loader_component.us_unit_counter = US_UNIT_COUNTER;

endmodule
