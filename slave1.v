module slave1
	#(parameter ADDWIDTH = 8, DATAWIDTH = 32)(
	input PCLK,
	input PRESETn,
	input PSEL,
	input PWRITE,
	input [ADDWIDTH-1:0]PADDR,
	input [(DATAWIDTH/8)-1:0]PSTRB,
	input [DATAWIDTH-1:0]PWDATA,
	output [DATAWIDTH-1:0]PRDATA,
	);
	
	reg [DATAWIDTH-1:0]mem[0:(2**ADDWIDTH)-1];
	
	always@(posedge PCLK)begin
		if(!PRESETn)
			PRDATA <= 'b0;
		else begin
			if(PSEL) begin
				if(PWRITE) begin
					PRDATA <= 'b0;
					// if(PSTRB[0]) mem[PADDR][7:0] <= PWDATA[7:0];
					// if(PSTRB[1]) mem[PADDR][15:8] <= PWDATA[15:8];
					// if(PSTRB[2]) mem[PADDR][23:16] <= PWDATA[23:16];
					// if(PSTRB[3]) mem[PADDR][31:24] <= PWDATA[31:24];
					
					for(integer i = 0; i < (DATAWIDTH/8); i = i +1)begin
						if(PSTRB[i]) mem[PADDR][(i*8)+7:i*8] <= PWDATA[(i*8)+7:i*8]
					end
					
				end
				else
					PRDATA <= mem[PADDR];
			end
			else
				PRDATA <= 'b0;
		end
	end
endmodule