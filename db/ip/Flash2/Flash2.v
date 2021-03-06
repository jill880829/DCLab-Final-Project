// Flash2.v

// Generated using ACDS version 15.0 145

`timescale 1 ps / 1 ps
module Flash2 (
		output wire [18:0] flash_addr,               //               flash_addr.flash_addr
		inout  wire [15:0] flash_data,               //               flash_data.flash_data
		output wire        flash_nce,                //                flash_nce.flash_nce
		output wire        flash_noe,                //                flash_noe.flash_noe
		output wire        flash_nwe,                //                flash_nwe.flash_nwe
		input  wire        pfl_flash_access_granted, // pfl_flash_access_granted.pfl_flash_access_granted
		output wire        pfl_flash_access_request, // pfl_flash_access_request.pfl_flash_access_request
		input  wire        pfl_nreset                //               pfl_nreset.pfl_nreset
	);

	altera_parallel_flash_loader #(
		.TRISTATE_CHECKBOX          (0),
		.FEATURES_PGM               (1),
		.FEATURES_CFG               (0),
		.FLASH_TYPE                 ("CFI_FLASH"),
		.ADDR_WIDTH                 (19),
		.FLASH_DATA_WIDTH           (16),
		.N_FLASH                    (1),
		.FLASH_NRESET_CHECKBOX      (0),
		.ENHANCED_FLASH_PROGRAMMING (0),
		.FIFO_SIZE                  (16),
		.DISABLE_CRC_CHECKBOX       (0)
	) parallel_flash_loader_0 (
		.pfl_nreset               (pfl_nreset),               //               pfl_nreset.pfl_nreset
		.pfl_flash_access_granted (pfl_flash_access_granted), // pfl_flash_access_granted.pfl_flash_access_granted
		.pfl_flash_access_request (pfl_flash_access_request), // pfl_flash_access_request.pfl_flash_access_request
		.flash_addr               (flash_addr),               //               flash_addr.flash_addr
		.flash_data               (flash_data),               //               flash_data.flash_data
		.flash_nce                (flash_nce),                //                flash_nce.flash_nce
		.flash_nwe                (flash_nwe),                //                flash_nwe.flash_nwe
		.flash_noe                (flash_noe)                 //                flash_noe.flash_noe
	);

endmodule
