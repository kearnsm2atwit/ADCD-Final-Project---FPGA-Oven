module tempConv (input [9:0]A, output reg [3:0] X, Y, Z);
	reg [21:0] temp;
	always @ (A) begin				// Always block to run when input A changes
		temp = A;
		temp = temp << 00000;
		temp = temp + 12'b110000000000;
		temp = temp << 0;
		temp = temp + 12'b110000000000;
		temp = temp << 00;
		temp = temp + 16'b1100000000000000;
		temp = temp << 00;
		X = temp[13:10];
		Y = temp[17:14];
		Z = temp[21:18];
	end
endmodule
