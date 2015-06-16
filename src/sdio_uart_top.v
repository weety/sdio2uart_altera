`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:02 03/05/2014 
// Design Name: 
// Module Name:    sdio_uart_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sdio_uart_top(
	input rst,
	input clk,
	input rxd,
	output txd,
	input sd_clk,
	input cmd_i,
	output finsh
    );

	wire [7:0]cmd_o;
	wire [31:0]arg_o;
	wire finsh_o;
	wire [3:0]dat_o;
	wire [7:0]status;
	
	parameter true = 1'b0, false = 1'b1;
	wire [7:0] dat;
	wire txen, rdrxd, txfull, txempty, rxfull, rxempty;

	assign finsh = txfull;
	
	ctrl sdio_ctrl(
		.rst(rst),
		.clk(clk),
		.txfull(txfull),
		.txen(txen),
		.dat_o(dat_o),
		.cmd_dat_i(cmd_o),
		.arg_i(arg_o),
		.finsh_i(finsh_o)
		);

	sdio_sample sdio_sam(
		.rst(rst), 
		.sd_clk(sd_clk), 
		.cmd_i(cmd_i), 
		.cmd_o(cmd_o), 
		.arg_o(arg_o),
		.finsh_o(finsh_o),
		.status(status)
		);
		
	uart8n1_rx rx(
		.rst(rst),
		.clk(clk),
		.rxd(rxd),//rxd
		.rxen(true),
		.divp(50_000_000/115_200), //fclk/baud
		.rdrxd(rdrxd),
		.dat(dat),
		.rxfull(rxfull),
		.rxempty(rxempty)
		);
		
	uart8n1_tx tx(
		.rst(rst),
		.clk(clk),
		.dat(dat_o),
		.txen(txen),
		.divp(50_000_000/115_200),  //fclk/baud
		.txd(txd),
		.txfull(txfull),
		.txempty(txempty)
		);

endmodule
