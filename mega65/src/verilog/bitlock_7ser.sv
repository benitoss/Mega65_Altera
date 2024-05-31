/*-----------------------------------------------------------------
   File: bitlock_7ser.sv

   Lock bistream to a specific device using unique 64bit DNA.

   The Device DNA primitive is factory programmed with bits 63:7 of
   the unique 64bit DNA. The remaining 7 bits need to established
   by reading the FUSE_DNA value via JTAG

-----------------------------------------------------------------*/

`timescale 1ps / 1ps


   module bitlock_7ser (
    output logic        MATCH_OUT,   // hi - device DNA matches expected value
    output logic        CHECK_DONE   // hi - DNA check completed
    );


  // internal signals
  logic        dnaRead;
  logic        dnaData;
  logic        dnaShift;
  logic        dnaShiftDly = 0;
  logic        enable;
  logic        srlCasc0;
  logic        srlCasc1;
  logic        srlCasc2;
  logic        srlCasc3;
  logic        expectedData;
  logic        cfgmclk;
  logic        match = 1;
  logic        matchOut = 0;
  logic        checkDone = 0;
  logic        dnaBits6_0;



  /*------------------------------------------------------------------
    7-Series startup block
  ------------------------------------------------------------------*/
  STARTUPE2 #(
    .PROG_USR       ("FALSE"),
    .SIM_CCLK_FREQ  (10.0)
  )
  u0 (
    .CFGCLK    (),
    .CFGMCLK   (cfgmclk),
    .EOS       (enable),
    .PREQ      (),
    .CLK       (1'b0),
    .GSR       (1'b0),
    .GTS       (1'b0),
    .KEYCLEARB (1'b1),
    .PACK      (),
    .USRCCLKO  (1'b0),
    .USRCCLKTS (1'b0),
    .USRDONEO  (1'b0),
    .USRDONETS (1'b0)
  );


  /*------------------------------------------------------------------
    Device DNA
  ------------------------------------------------------------------*/
  //  bits 63:7 of unique DNA
  // shifted out on DOUT as 0.3.4.3... (from bit 7 to 63)
  DNA_PORT #(
    .SIM_DNA_VALUE  (57'h03431c21141b01c)   // tcl dnaSIMHEX
  )
  u1 (
    .DOUT (dnaData),
    .CLK  (cfgmclk),
    .DIN  (dnaBits6_0),
    .READ (dnaRead),
	.SHIFT(dnaShift)
  );



   // bits 6:0 of unique DNA
  SRLC32E #(
    .INIT(32'h00000012)   // tcl expectedHEX2
  )
  u2 (
    .Q   (dnaBits6_0),
    .Q31 (),
    .A   (5'h06),
    .CE  (dnaShift),
    .CLK (cfgmclk),
    .D   (1'b0)
  );



 /*------------------------------------------------------------------
    Timing control
  ------------------------------------------------------------------*/

  // DNA read pulse
  SRLC32E #(
    .INIT(32'h00080000)
  )
  u4 (
    .Q   (dnaRead),
    .Q31 (),
    .A   (5'h1F),
    .CE  (enable),
    .CLK (cfgmclk),
    .D   (1'b0)
  );



  // DNA shift enable
  // lo for 32 clks, high for 63 clocks, then lo
  SRLC32E #(
    .INIT(32'h00000000)
  )
  u5 (
    .Q   (dnaShift),
    .Q31 (),
    .A   (5'h10),
    .CE  (enable),
    .CLK (cfgmclk),
    .D   (srlCasc1)
  );


  SRLC32E #(
    .INIT(32'hFFFFFFFF)
  )
  u6 (
    .Q   (),
    .Q31 (srlCasc1),
    .A   (5'h1F   ),
    .CE  (enable  ),
    .CLK (cfgmclk ),
    .D   (srlCasc0)
  );


  SRLC32E #(
    .INIT(32'hFFFFFFFF)
  )
  u7 (
    .Q   (),
    .Q31 (srlCasc0),
    .A   (5'h1F   ),
    .CE  (enable  ),
	.CLK (cfgmclk ),
    .D   (1'b0    )
);



 /*------------------------------------------------------------------
    Shift register with expected value
  ------------------------------------------------------------------*/

  SRLC32E #(
    .INIT(32'h003431c2)  // tcl expectedHEX0
  )
  u8 (
    .Q   (expectedData),
    .Q31 (),
    .A   (5'h18   ),
    .CE  (dnaShift),
    .CLK (cfgmclk ),
    .D   (srlCasc2)
  );


  SRLC32E #(
    .INIT(32'h1141b01c)  // tcl expectedHEX1
  )
  u9 (
    .Q   (),
    .Q31 (srlCasc2),
    .A   (5'h1f   ),
    .CE  (dnaShift),
	.CLK (cfgmclk ),
    .D   (srlCasc3)
);


  SRLC32E #(
    .INIT(32'h00000012)  // tcl expectedHEX2
  )
  u10 (
    .Q   (srlCasc3),
    .Q31 (),
    .A   (5'h06   ),
    .CE  (dnaShift),
	.CLK (cfgmclk ),
    .D   (1'b0    )
);



 /*------------------------------------------------------------------
    Compare Device DNA to expected value
  ------------------------------------------------------------------*/
  always_ff @ (posedge cfgmclk) begin : compare

	if (dnaShift == 1) begin

	  if (dnaData != expectedData) begin
	    match <= 0;
	  end

    end

  end : compare



 /*------------------------------------------------------------------
    Flag end of check
  ------------------------------------------------------------------*/
  always_ff @ (posedge cfgmclk) begin : delay

	dnaShiftDly <= dnaShift;

  end : delay



 always_ff @ (posedge cfgmclk) begin : chkEnd

	if (dnaShift == 0 && dnaShiftDly == 1) begin
	  checkDone <= 1;
	end

  end : chkEnd


  assign CHECK_DONE = checkDone;



 always_ff @ (posedge cfgmclk) begin : matchFlag

	if (dnaShift == 0 && dnaShiftDly == 1 && match == 1) begin
	  matchOut <= 1;
	end

  end : matchFlag

  assign MATCH_OUT = matchOut;



endmodule : bitlock_7ser
/*-----------------------------------------------------------------
   End of File: bitlock_7ser.sv
-----------------------------------------------------------------*/
