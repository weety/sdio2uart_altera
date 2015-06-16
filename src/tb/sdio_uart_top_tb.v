`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:24:53 03/05/2014
// Design Name:   sdio_uart_top
// Module Name:   D:/mywork/FPGA/project/sdio_uart/src/tb/sdio_uart_top_tb.v
// Project Name:  sdio_uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdio_uart_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sdio_uart_top_tb;

	// Inputs
	reg rst;
	reg clk;
	reg rxd;
	reg sd_clk;
	reg cmd_i;

	// Outputs
	wire txd;
	
	parameter period = 20;
	parameter INIT_DELAY = 200;
	parameter BITS_TO_SEND = 48;
	parameter CMD_SIZE = 48;
	parameter RESP_SIZE = 48;
	integer counter;
	
	reg [47:0]cmd_buff;
	reg [47:0]resp_buff;
	
	reg [6:0]current_st;
	reg [6:0]next_st;
	parameter INIT = 7'h01, IDLE = 7'h02, SEND_CMD = 7'h04, SEND_WAIT = 7'h08, 
			SEND_RESP = 7'h10, FINSH_CAP = 7'h20;

	`define cmd_idx  (CMD_SIZE-1-counter) 
	`define resp_idx  (RESP_SIZE-1-counter) 

	// Instantiate the Unit Under Test (UUT)
	sdio_uart_top uut (
		.rst(rst), 
		.clk(clk), 
		.rxd(rxd), 
		.txd(txd), 
		.sd_clk(sd_clk), 
		.cmd_i(cmd_i)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		rxd = 0;
		sd_clk = 0;
		cmd_i = 0;

		// Wait 100 ns for global reset to finish
		#400 rst = 1;
        
		// Add stimulus here

	end
	
	always #(period/2) clk = ~clk;
	always #(period/2) sd_clk = ~sd_clk;
	
	always @(negedge sd_clk or negedge rst)
	begin
		if (!rst) begin
			cmd_buff[47:46] <= 2'b01;
			cmd_buff[45:40] <= 6'd8;
			cmd_buff[39:20] <= 20'h00000;
			cmd_buff[19:16] <= 4'b0001;
			cmd_buff[15:8] <= 8'h5a;
			cmd_buff[7:0] <= 8'h01;
			resp_buff[47:46] <= 2'b00;
			resp_buff[45:40] <= 6'd8;
			resp_buff[39:8] <= 32'h5a01;
			resp_buff[7:0] <= 8'h01;
			counter <= 0;
			current_st <= INIT;
		end
		else begin
			case (current_st)
				INIT: begin
					cmd_i <= 1'b1;
					counter = counter + 1;
					if (counter >= INIT_DELAY) begin
						counter <= 0;
						current_st <= IDLE;
					end
				end
				IDLE: begin
					current_st <= SEND_CMD;
				end
				SEND_CMD: begin
					cmd_i <= cmd_buff[`cmd_idx];
					counter = counter + 1;
					if (counter >= CMD_SIZE) begin
						counter <= 0;
						current_st <= SEND_WAIT;
					end
				end
				SEND_WAIT: begin
					cmd_i <= 1'b1;
					counter = counter + 1;
					if (counter >= INIT_DELAY) begin
						counter <= 0;
						current_st <= SEND_RESP;//IDLE;
					end
				end
				SEND_RESP: begin
					cmd_i <= resp_buff[`resp_idx];
					counter = counter + 1;
					if (counter >= RESP_SIZE) begin
						counter <= 0;
						current_st <= INIT;
					end
				end
				default: current_st <= INIT;
			endcase
		end
	end
      
endmodule

