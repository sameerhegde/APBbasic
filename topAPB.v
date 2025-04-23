module topAPB
	#(parameter ADDWIDTH = 8, DATAWIDTH = 32) (
    input PCLK,
    input PRESETn,
    input PWRITE,
    input transfer,
    input [ADDWIDTH:0] PADDR,
    input [DATAWIDTH-1:0] PWDATA,
    input [(DATAWIDTH/8)-1:0] PSTRB,
    output [DATAWIDTH-1:0] PRDATA
);

    wire master_PSEL1, master_PSEL2;
    wire mux_PSEL1out, mux_PSEL2out;
    wire PENABLE;
    wire [DATAWIDTH-1:0] PWDATA_out, PRDATA_mux;
    wire [(DATAWIDTH/8)-1:0] PSTRB_out;
    wire [ADDWIDTH-1:0] PADDR_out;
    wire PWRITE_out;
    wire PREADY_mux;

    wire [DATAWIDTH-1:0] PRDATA1, PRDATA2;
    wire PREADY1, PREADY2;

    // Master
    apbMaster #(ADDWIDTH, DATAWIDTH) master_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PWRITEin(PWRITE),
        .transfer(transfer),
        .PADDRin(PADDR),
        .PWDATAin(PWDATA),
        .PSTRBin(PSTRB),
        .PREADY(PREADY_mux),         
        .PRDATAin(PRDATA_mux),       
        .PRDATAout(PRDATA),
        .PSEL1(master_PSEL1),
        .PSEL2(master_PSEL2),
        .PENABLE(PENABLE),
        .PWRITEout(PWRITE_out),
        .PWDATAout(PWDATA_out),
        .PSTRBout(PSTRB_out),
        .PADDRout(PADDR_out)
    );

    // MUX
    apbMUX #(DATAWIDTH) mux_inst (
        .PSEL1in(master_PSEL1),
        .PSEL2in(master_PSEL2),
        .PREADY1(PREADY1),
        .PREADY2(PREADY2),
        .PRDATAin1(PRDATA1),
        .PRDATAin2(PRDATA2),
        .PSEL1out(mux_PSEL1out),
        .PSEL2out(mux_PSEL2out),
        .PRDATAout(PRDATA_mux),
        .PREADY(PREADY_mux)
    );

    // Slave 1
    slave1 #(ADDWIDTH, DATAWIDTH) slave1_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(mux_PSEL1out),
        .PWRITE(PWRITE_out),
        .PENABLE(PENABLE),
        .PADDR(PADDR_out),
        .PSTRB(PSTRB_out),
        .PWDATA(PWDATA_out),
        .PREADY(PREADY1),
        .PRDATA(PRDATA1)
    );

    // Slave 2
    slave2 #(ADDWIDTH, DATAWIDTH) slave2_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(mux_PSEL2out),
        .PWRITE(PWRITE_out),
        .PENABLE(PENABLE),
        .PADDR(PADDR_out),
        .PSTRB(PSTRB_out),
        .PWDATA(PWDATA_out),
        .PREADY(PREADY2),
        .PRDATA(PRDATA2)
    );

endmodule
