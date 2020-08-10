module finalproject (input clk, A, B, C, D, E, output Z, output [7:0] H3, H2, H1, H0);
	//A is for turning the oven on and off(display time or turn the oven on)
	//B raises temp
	//C lowers temp
	//D activates the oven with its appropriate temp
	//E toggles setting the cook time


	parameter MAX_COUNT = 25000000;					// 1 second is 50 million clock cycles @ 50 MHz
	reg [27:0] count = 0;								// Store count value
	reg new_clk = 0;										// Clock to be used
	
	
	reg [3:0] Q3, Q2, Q1, Q0 = 0;
	reg [3:0] D3, D2, D1, D0 = 0;
	
	
	
	reg [10:0] temp = 0;									// Need register for clock to display temp
	reg [10:0] targetTemp = 357;
	reg [16:0] bakeTime = 0;
	
	sevenseg s3(Q3, H3);
	sevenseg s2(Q2, H2);
	sevenseg s1(Q1, H1);
	sevenseg s0(Q0, H0);
	
	
	always @ (posedge clk) begin
		if (count <= MAX_COUNT) begin
			count <= count + 1;
		end
		else begin
			count <= 0;
			new_clk <= ~new_clk;
		end
	end

	// Always block to control FSM based on clock cycle

	always @ (posedge new_clk) begin
	
		D0 = D0 + 1;
		if (D0 == 10) begin
			D0 = 0;
			D1 = D1 + 1;
			if (D1 == 6) begin
				D1 = 0;
				D0 = 0;
				D2 = D2 + 1;
				if (D2 == 10) begin
					D2 = 0;
					D3 = D3 + 1;
					if (D3 == 6) begin
						D3 = 0;
						D2 = 0;
					end
				end
			end
		end
			
			
		// If oven is ON and need to set desired temp
		if (A == 1 && B == 0 && C == 0) begin
		
			Q0 = (targetTemp % 10);
			Q1 = (targetTemp % 100) / 10;
			Q2 = (targetTemp / 100);
		
		end
		
		// If oven is ON and need to set desired time
		if (A == 1 && B == 1 && C == 0) begin
		
		end
		
		// If oven is ON and need to be baking
		if (A == 1 && B == 1 && C == 1) begin
		
		end
	
		// If oven is OFF
		if (A == 0) begin
			Q0 = D0;
			Q1 = D1;
			Q2 = D2;
			Q3 = D3;
		end
	end
endmodule
