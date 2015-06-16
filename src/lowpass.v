
module lowpass(
	input clk,
	input lin,
	output lout
	);
	reg [3:0] lpbuf;
	always @ (posedge clk) begin lpbuf <= {lpbuf[2:0],lin}; end
	wire lin1 = & lpbuf;
	wire lin0 = | lpbuf;
	assign lout = (lin1 == 1'b1) ? 1'b1 : (lin0 == 1'b0) ? 1'b0 : lout;
endmodule
