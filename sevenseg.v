module sevenseg (input [3:0]A, output reg [7:0]Z);

	always @ (A) begin				// Always block to run when input A changes
		case(A)					// Case statement for all possibilities of 4-bit input A
			4'b0000: Z = 8'b11000000;	// 0 on 7-seg
			4'b0001: Z = 8'b11111001;	// 1 on 7-seg
			4'b0010: Z = 8'b10100100;	// 2 on 7-seg
			4'b0011: Z = 8'b10110000;	// 3 on 7-seg
			4'b0100: Z = 8'b10011001;	// 4 on 7-seg
			4'b0101: Z = 8'b10010010;	// 5 on 7-seg
			4'b0110: Z = 8'b10000010;	// 6 on 7-seg
			4'b0111: Z = 8'b11111000;	// 7 on 7-seg
			4'b1000: Z = 8'b10000000;	// 8 on 7-seg
			4'b1001: Z = 8'b10011000;	// 9 on 7-seg
			4'b1010: Z = 8'b10001000;	// A on 7-seg
			4'b1011: Z = 8'b10000011;	// b on 7-seg
			4'b1100: Z = 8'b11000110;	// C on 7-seg
			4'b1101: Z = 8'b10100001;	// d on 7-seg
			4'b1110: Z = 8'b10000110; 	// E on 7-seg
			4'b1111: Z = 8'b10001110;	// F on 7-seg
			default: Z = 8'b11000000;	// 0 on 7-seg
		endcase
	end
endmodule