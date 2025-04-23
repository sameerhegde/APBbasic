`timescale 1ns / 1ps

module tb_topAPB();

    // Parameters
    parameter ADDWIDTH = 8;
    parameter DATAWIDTH = 32;

    // Inputs to DUT
    reg PCLK = 0;
    reg PRESETn = 0;
    reg PWRITE = 0;
    reg transfer = 0;
    reg [ADDWIDTH:0] PADDR = 0;
    reg [DATAWIDTH-1:0] PWDATA = 0;
    reg [(DATAWIDTH/8)-1:0] PSTRB = 4'b1111;

    // Output from DUT
    wire [DATAWIDTH-1:0] PRDATA;

    // Instantiate the DUT
    topAPB #(ADDWIDTH, DATAWIDTH) DUT (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PWRITE(PWRITE),
        .transfer(transfer),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PRDATA(PRDATA)
    );

    // Clock generation: 100MHz
    always #5 PCLK = ~PCLK;

    initial begin
        // Initial reset
        #10 PRESETn = 1;

        // === Write ===
        #10;
        PWRITE = 1;
        transfer = 1;
        PADDR = 9'b0_0000_0000; // Address for Slave 1
        PWDATA = 32'hCAFEBABE; // Written to slave 1 address 0 
        #20 transfer = 0;

        // === Write ===
        #10;
        PWRITE = 1;
        transfer = 1;
        PADDR = 9'b0_0000_0001; // Address for Slave 1
		PSTRB = 4'b1010;
        PWDATA = 32'hFF_FF_FF_FF; // Written to slave 1 address 0, the writeen Data = ffxxffxx because of strobe
        #20 transfer = 0;
        
        // === Write ===
        #10;
        PWRITE = 1;
        transfer = 1;
        PADDR = 9'b0_0000_0001; // Address for Slave 1
		PSTRB = 4'b0101;
        PWDATA = 32'hxx_ee_xx_ee; // Written to slave 1 address 0, the writeen Data = xxeexxee | ffxxffxx = ffeeffee because of strobe and old data
        #20 transfer = 0;
		
		// === Write ===
        #10;
        PWRITE = 1;
        transfer = 1;
        PADDR = 9'b1_0000_0010; // Address for Slave 2
		PSTRB = 4'b0011;
        PWDATA = 32'hFF_FF_CA_FE; // data xxxxCAFE is written to address 2 of slave 2
        #50 transfer = 0;
		
		// === Write ===
        #10;
        PWRITE = 1;
        transfer = 1;
        PADDR = 9'b1_0000_0010; // Address for Slave 2
		PSTRB = 4'b1100;
        PWDATA = 32'hDE_AD_FF_FF; // data DEADxxxx is written to address 2 of slave 2 the previous data was xxxxCAFE so at the address DEADCAFE will be stored
        #10 transfer = 0;

        // === Read ===
        #30;
        PWRITE = 0;
        transfer = 1;
        PADDR = 9'b0_0000_0000;#10 $display("Read data: %h", PRDATA);#10
		PADDR = 9'b0_0000_0001;#10 $display("Read data: %h", PRDATA);#10
		PADDR = 9'b1_0000_0010;#10 $display("Read data: %h", PRDATA);#10
        #30 transfer = 0;

        #20 $finish;
    end

endmodule