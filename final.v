module final (input clk, A, B, C, D, E, F, output X, output Z, output [7:0] H3, H2, H1, H0);
	//A is for turning the oven on and off(display time or turn the oven on)
	//B raises temp
	//C lowers temp
	//D activates the oven with its appropriate temp
	//E toggles setting the cook time


	parameter MAX_COUNT = 25000000;					// 1 second is 50 million clock cycles @ 50 MHz
	reg [27:0] count = 0;								// Store count value
	reg new_clk = 0;										// Clock to be used
	reg tempX, tempZ = 0;
	assign X = tempX;
	assign Z = tempZ;
	
	reg [3:0] Q3, Q2, Q1, Q0 = 0;
	reg [3:0] D3, D2, D1, D0 = 0;
	
	
	
	
	reg [10:0] targetTemp = 300;
	reg [10:0] temp = 65;	
	reg [15:0] bakeTime = 0;
	reg [4:0] loopCount = 0;
	
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
		
			
			if (temp >= (targetTemp - 2) && (temp <= targetTemp + 2)) begin
				tempX = 1;
			end
			else begin
				tempX = 0;
			end
			
		
			if (temp >= 67) begin
				loopCount = loopCount + 1;
				if (loopCount > 1) begin
					temp = temp - 1;
					loopCount = 0;
				end
			end
			
			if (D == 1 && targetTemp < 900) begin
				targetTemp = targetTemp - 10;
			end
			if (E == 1 && targetTemp > 60) begin
				targetTemp = targetTemp + 10;
			end
		
			Q0 = (targetTemp % 10);
			Q1 = (targetTemp % 100) / 10;
			Q2 = (targetTemp / 100);
			Q3 = 0;

			if (F == 1) begin
				Q0 = (temp % 10) % 10;
				Q1 = (temp % 100) / 10;
				Q2 = (temp / 100);
				Q3 = 0;
			end
		
		end
		
		// If oven is ON and is preheating
		if (A == 1 && B == 1 && C == 0) begin
			
			if (temp >= (targetTemp - 2) && (temp <= targetTemp + 2)) begin
				tempX = 1;
			end
			else begin
				tempX = 0;
			end
			
			// Preheat stage, temp needs to be less than 5 degrees off of target temp
			if (temp <= (targetTemp)) begin
				temp = temp + 2;
			end
			else begin
				loopCount = loopCount + 1;
				if (loopCount > 1) begin
					temp = temp - 1;
					loopCount = 0;
				end
			end
			
			if (E == 1 && bakeTime < 3600) begin
				bakeTime = bakeTime + 60;
			end
			if (D == 1) begin
				if (bakeTime >= 60) begin
					bakeTime = bakeTime - 60;
				end
				else begin
					bakeTime = 0;
				end
			end
			
			// Displaying bake time
			// MM:SS
			// Max time would be 60:00
			// 60 minutes is 3600 seconds
			Q0 = (bakeTime % 60) % 10;
			Q1 = (bakeTime % 60) / 10;
			Q2 = (bakeTime / 60) % 10;
			Q3 = (bakeTime / 600) % 10;
		
			if (F == 1) begin
				Q0 = (temp % 10) % 10;
				Q1 = (temp % 100) / 10;
				Q2 = (temp / 100);
				Q3 = 0;
			end
			tempZ = 0;
		
		end
		
		// If oven is ON and timer is going
		if (A == 1 && B == 1 && C == 1) begin
			
			if (temp >= (targetTemp - 2) && (temp <= targetTemp + 2)) begin
				tempX = 1;
			end
			else begin
				tempX = 0;
			end
			
			// Preheat stage, temp needs to be less than 5 degrees off of target temp
			if (temp <= (targetTemp)) begin
				temp = temp + 2;
			end
			else begin
				loopCount = loopCount + 1;
				if (loopCount > 1) begin
					temp = temp - 1;
					loopCount = 0;
				end
			end
			
			if (bakeTime >= 0) begin
			
				if (bakeTime > 0) begin
					bakeTime = bakeTime - 1;
				end
				else begin
					// Baking timer is over, output to LED
				end
				
				if (E == 1 && bakeTime < 3600) begin
					bakeTime = bakeTime + 60;
				end
				if (D == 1) begin
					if (bakeTime >= 60) begin
						bakeTime = bakeTime - 60;
					end
					else begin
						bakeTime = 0;
					end
				end
				
				if (bakeTime == 0) begin
					tempZ = 1;
				end
				else begin
					tempZ = 0;
				end
				
			end
			
			Q0 = (bakeTime % 60) % 10;
			Q1 = (bakeTime % 60) / 10;
			Q2 = (bakeTime / 60) % 10;
			Q3 = (bakeTime / 600) % 10;
			
			if (F == 1) begin
				Q0 = (temp % 10) % 10;
				Q1 = (temp % 100) / 10;
				Q2 = (temp / 100);
				Q3 = 0;
			end
		end
		
		// If oven is OFF
		if (A == 0) begin
		
			if (temp >= 67) begin
				loopCount = loopCount + 1;
				if (loopCount > 1) begin
					temp = temp - 1;
					loopCount = 0;
				end
			end
	
			Q0 = D0;
			Q1 = D1;
			Q2 = D2;
			Q3 = D3;
			if (F == 1) begin
				Q0 = (temp % 10) % 10;
				Q1 = (temp % 100) / 10;
				Q2 = (temp / 100);
				Q3 = 0;
			end
			tempZ = 0;
			tempX = 0;
		end
		
	
	end
endmodule
