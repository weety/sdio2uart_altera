
module uart8n1_rx(
	input rst,
	input clk,
	input rxd,
	input rxen,
	input [15:0] divp,
	input rdrxd,
	output [7:0] dat,
	output rxfull,
	output rxempty
	);
	parameter true = 1'b0, false = 1'b1;
	reg [7:0] rxdata;
	wire [7:0] rxdat = rxdata;
	reg dready;
	wire ien = dready;
	wire rxdlpo;
	fifo8x15 rxfifo(
		.rst(rst),
		.clk(clk),
		.ien(ien),
		.oen(rdrxd),
		.idat(rxdat),
		.odat(dat),
		.full(rxfull),
		.empty(rxempty)
		);
	lowpass lp(
		.clk(clk),
		.lin(rxd),
		.lout(rxdlpo)
		);
	reg [15:0] divcnt = 16'b0;
	
	parameter IDLE = 4'h1, RXSTART = 4'h2, RXBIT0 = 4'h3, RXBIT1 = 4'h4, RXBIT2 = 4'h5, RXBIT3 = 4'h6, 
			 RXBIT4 = 4'h7, RXBIT5 = 4'h8, RXBIT6 = 4'h9, RXBIT7 = 4'hA, RXSTOP = 4'hB;
	reg [3:0] rxstate = IDLE;

	always @ (posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			dready <= false;
			divcnt <= 16'b0;
			rxstate <= IDLE;
			end
		else begin
			case(rxstate)
				IDLE: begin
					dready <= false;
					if(rxen == true && rxdlpo == 1'b0) begin
						divcnt <= 16'b0;
						rxstate <= RXSTART;
						end
					end
				RXSTART: begin
					if(divcnt == divp[15:1]) begin
						divcnt <= 16'b0;
						if(rxdlpo == 1'b0) rxstate <= RXBIT0;
						else rxstate <= IDLE;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT0: begin
					if(divcnt == divp) begin
						rxdata[0] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT1;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT1: begin
					if(divcnt == divp) begin
						rxdata[1] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT2;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT2: begin
					if(divcnt == divp) begin
						rxdata[2] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT3;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT3: begin
					if(divcnt == divp) begin
						rxdata[3] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT4;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT4: begin
					if(divcnt == divp) begin
						rxdata[4] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT5;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT5: begin
					if(divcnt == divp) begin
						rxdata[5] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT6;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT6: begin
					if(divcnt == divp) begin
						rxdata[6] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXBIT7;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXBIT7: begin
					if(divcnt == divp) begin
						rxdata[7] <= rxdlpo;
						divcnt <= 16'b0;
						rxstate <= RXSTOP;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				RXSTOP: begin
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						rxstate <= IDLE;
						if(rxdlpo == 1'b1) begin
							dready <= true;
							end
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
			endcase
			end
		end
endmodule
