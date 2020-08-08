module final (input clk, A, B, C, D, output Z, output [7:0] H5, H4, H3, H2, H1, H0);
	//A is for turning the oven on and off(display time or turn the oven on)
	//B raises temp
	//C lowers temp
	//D activates the oven with its appropriate temp


	parameter MAX_COUNT = 50000000;					// 1 second is 50 million clock cycles @ 50 MHz
	reg [27:0] count = 0;						// Store count value
	reg new_clk = 0;										// Clock to be used
	
	reg [4:0] Q3, Q2, Q1, Q0 = 0;
	
	reg [16:0] clock = 0;								// Need register for clock to display time. Time will be an integer of seconds
	reg [8:0] temp = 0;									// Need register for clock to display temp
	reg [8:0] targetTemp = 350;
	

	// Put each register into the seven segment module
//	sevenseg s5 (Q5, H5);
//	sevenseg s4 (Q4, H4);
	sevenseg s3 (Q3, H3);
	sevenseg s2 (Q2, H2);
	sevenseg s1 (Q1, H1);
	sevenseg s0 (Q0, H0);	
	
	always @ (posedge clk) begin
		if (count <= MAX_COUNT) begin
			count <= count + 1;
		end
		else begin
			count <= 0;
			
			new_clk <= ~new_clk;
		end
	end
	
	
	reg [1:0] current_state, next_state;					
	localparam A00 = 0, A01 = 1, A10 = 2, A11 = 3;
	
	
	// Always block to control FSM based on clock cycle
	always @ (posedge new_clk) begin
		if (A == 0) begin
			current_state <= A00;
		end
		else begin
			current_state <= next_state;
		end
	end

	
	
	// Need to find next state
	
	always @ (*) begin
		next_state = current_state;
		if (A == 1) begin
			Q0 = Q0 + 1;
				if (Q0 == 10) begin
					Q0 = 0;
					Q1 = Q1 + 1;
					if (Q1 == 6) begin
						Q1 = 0;
						Q0 = 0;
						Q2 = Q2 + 1;
						if (Q2 == 10) begin
							Q2 = 0;
							Q3 = Q3 + 1;
							if (Q3 == 6) begin
								Q3 = 0;
								Q2 = 0;
							end
						end
					end
				end
			end
		else begin
			case (current_state)
				A00: begin
					if (temp < targetTemp - 2) begin
						temp = temp + 2;
						next_state = A00;
					end
					else begin
						temp = temp + 2;
						next_state = A01;
					end
				end
				A01: begin
					if (temp > targetTemp - 2) begin
						temp = temp - (1/2);
						next_state = A01;
					end
					else begin
						temp = temp - (1/2);
						next_state = A00;
					end
				end
				A10: begin
					// In State 10, Oven is ON, preheating to the desired temp
				end
				A11: begin
					// In State 11, Oven is ON, needs to bake for desired time
				end
			endcase
		end
	end
	
	
endmodule







	