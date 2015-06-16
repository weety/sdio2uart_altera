
module fifo8x15(
	input rst,
	input clk,
	input ien,
	input oen,
	input [7:0] idat,
	output [7:0] odat,
	output full,
	output empty
	);
	parameter true = 1'b0, false = 1'b1;
	reg [7:0] mem [0:15];
	reg [3:0] wraddr = {4{1'b0}};
	reg [3:0] rdaddr = {4{1'b0}};
	wire [3:0] datnum = wraddr - rdaddr;
	assign empty = datnum == {4{1'b0}} ? true : false;
	assign full  = datnum == {4{1'b1}} ? true : false;
	reg [7:0] odatq;
	assign odat = odatq;
	reg ienbuf = 1'b0, oenbuf = 1'b0;
	wire negedge_ien = ienbuf & ~ien;
	wire negedge_oen = oenbuf & ~oen;
	always @ (posedge clk or negedge rst) begin 
		if(rst == 1'b0) begin //reset
			ienbuf <= 1'b0;
			oenbuf <= 1'b0;
			end
		else begin //buffer
			ienbuf <= ien;
			oenbuf <= oen;
			end
		end
	always @ (posedge clk or negedge rst) begin
		if(rst == 1'b0) begin //reset
			wraddr <= {4{1'b0}};
			rdaddr <= {4{1'b0}};
			end
		else begin
			if(negedge_ien && full == false) begin //push
				mem[wraddr] <= idat;
				wraddr <= wraddr + 1'b1;
				end
			if(negedge_oen && empty == false) begin //pop
				odatq <= mem[rdaddr];
				rdaddr <= rdaddr + 1'b1;
				end
			end
		end
endmodule
