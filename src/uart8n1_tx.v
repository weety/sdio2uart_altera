
module uart8n1_tx(
	input rst,
	input clk,
	input [7:0] dat,
	input txen,
	input [15:0] divp,
	output reg txd,
	output txfull,
	output txempty
	);
	parameter true = 1'b0, false = 1'b1;
	wire [7:0] txdat;
	reg rdfifo = false;
	fifo8x15 txfifo(
		.rst(rst),
		.clk(clk),
		.ien(txen),
		.oen(rdfifo),
		.idat(dat),
		.odat(txdat),
		.full(txfull),
		.empty(txempty)
		);
	reg [15:0] divcnt = 16'b0;
	
	parameter IDLE = 4'h1, TXSTART = 4'h2, TXBIT0 = 4'h3, TXBIT1 = 4'h4, TXBIT2 = 4'h5, TXBIT3 = 4'h6, 
	          TXBIT4 = 4'h7, TXBIT5 = 4'h8, TXBIT6 = 4'h9, TXBIT7 = 4'hA, TXSTOP = 4'hB;
	reg [3:0] txstate = IDLE;
	
	always @ (posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			txd <= 1'b1;
			rdfifo <= false;
			divcnt <= 16'b0;
			txstate <= IDLE;
			end
		else begin
			case(txstate)
				IDLE: begin
					txd <= 1'b1;
					if(txempty == false) begin
						rdfifo <= true;
						divcnt <= 16'b0;
						txstate <= TXSTART;
						end
					end
				TXSTART: begin
					txd <= 1'b0;
					rdfifo <= false;
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT0;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT0: begin
					txd <= txdat[0];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT1;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT1: begin
					txd <= txdat[1];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT2;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT2: begin
					txd <= txdat[2];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT3;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT3: begin
					txd <= txdat[3];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT4;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT4: begin
					txd <= txdat[4];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT5;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT5: begin
					txd <= txdat[5];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT6;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT6: begin
					txd <= txdat[6];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXBIT7;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXBIT7: begin
					txd <= txdat[7];
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= TXSTOP;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
				TXSTOP: begin
					txd <= 1'b1;
					rdfifo <= false;
					if(divcnt == divp) begin
						divcnt <= 16'b0;
						txstate <= IDLE;
						end
					else begin
						divcnt <= divcnt + 1'b1;
						end
					end
			endcase
			end
		end
endmodule
