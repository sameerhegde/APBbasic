module apbMUX
	#(parameter DATAWIDTH = 32)(
	input PSEL1in,PSEL2in,
	input [DATAWIDTH-1:0]PRDATAin1,PRDATAin2,
	output reg PSEL1out,PSEL2out,
	output reg [DATAWIDTH-1:0]PRDATAout
	);
	
	always@(*)begin
		case({PSEL1in,PSEL2in})
			2'b10:begin
				{PSEL1out,PSEL2out} = 2'b10;
				PRDATAout = PRDATAin1;
				end
			2'b01:begin
				{PSEL1out,PSEL2out} = 2'b01;
				PRDATAout = PRDATAin2;
				end
			default:begin
				{PSEL1out,PSEL2out} = 2'b00;
				PRDATAout = 'b0;
				end
		endcase
	end
endmodule