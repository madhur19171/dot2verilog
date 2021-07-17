`timescale 1ns/1ps


module single_argument
	#(
		parameter TV_IN = "",
		TV_OUT = "",
		DATA_WIDTH = 32
	)
	(
		input clk,
		input rst,
		input ce0,
		input we0,
		output reg [DATA_WIDTH - 1 : 0] mem_dout0,
		input[DATA_WIDTH - 1 : 0] mem_din0,
		input done
	);

//----------------------------------------------------------------------------

	reg[DATA_WIDTH - 1 : 0] mem = 0;
	reg[DATA_WIDTH - 1 : 0] mem_temp = 0;
	reg write_done_flag = 0;
	
	integer temp_fp;
	integer i;
	
	
//----------------------------------------------------------------------------
//-----------------------------------Read array-------------------------------
//-- Read data from file to array

	integer transaction_idx_read;	
	integer fp_read;
	integer i_read;
	reg [8 * 128 : 1] token_read = 0;
	
	initial begin
		if (TV_IN != "" && TV_IN != "../../../../../") begin
			wait(!rst);
			
			transaction_idx_read = 0;
			fp_read = $fopen(TV_IN, "r");
			
			if (fp_read == 0)begin
				$display("Failed to open file %s", TV_IN);
				$finish;
			end


			temp_fp = $fscanf(fp_read, "%s\n", token_read);
			if (token_read[13 * 8 : 1] != "[[[runtime]]]") begin
				$display("ERROR: Simulation using HLS TB failed.");
				$finish;
			end
			
			
			temp_fp = $fscanf(fp_read, "%s\n", token_read);
			while (token_read[14 * 8 : 1] != "[[[/runtime]]]") begin
				if (token_read[15 * 8 : 1] != "[[transaction]]") begin
					$display("ERROR: Simulation using HLS TB failed.");
					$finish;
				end
				
				//esl_read_token(fp, token_line, token); -- Skip transaction number
				//-- Start to read data for every transaction round
				while(~done) 
					@(posedge clk);

				temp_fp = $fscanf(fp_read, "%s\n", token_read);				

				temp_fp = $fscanf(fp_read, "0x%x\n", token_read);
				mem = token_read[DATA_WIDTH : 1];
				
				temp_fp = $fscanf(fp_read, "%s\n", token_read);
				wait(done == 0);

				if (token_read[16 * 8 : 1] != "[[/transaction]]") begin
					$display("ERROR: Simulation using HLS TB failed.");
					$finish;
				end
				
				temp_fp = $fscanf(fp_read, "%s\n", token_read);
				transaction_idx_read = transaction_idx_read + 1;
			end
			$fclose(fp_read);
		end
	end
//----------------------------------------------------------------------------
//	-- Read data from array to RTL
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			mem_dout0 <= 0;
		else if (ce0)begin
				mem_temp = mem;
				#0.1 mem_dout0 = mem_temp;
			end
	end
//----------------------Write array-------------------------------------------

//	--Write data from RTL to array
	always @(posedge clk)
	begin
		if (ce0 & we0)
			mem <= mem_din0;
	end


//----------------------------------------------------------------------------
//	-- Write data from array to file

	integer transaction_idx_write;	
	integer fp_write;
	integer i_write;
	reg [8 * 128 : 1] token_write = 0;
	
initial 
	begin
		if (TV_OUT != "" && TV_OUT != "../../../../../")begin
			wait(~rst);
			
			transaction_idx_write = 0;
			
			while(~done)
				@(posedge clk);
				
			wait(~done);       

			while(1) begin
				while (~done)
					@(posedge clk);

				fp_write = $fopen(TV_OUT, "a+");
				
				
				if(fp_write == 0)begin
					$display("Failed to open file %s", TV_OUT);
					$finish;
				end
				
				$fwrite(fp_write, "[[transaction]] %d\n", transaction_idx_write);
				
				$fwrite(fp_write, "0x%x\n", mem);
					
				$fwrite(fp_write, "[[/transaction]]\n");
				
				transaction_idx_write = transaction_idx_write + 1;
				$fclose(fp_write);
				
				wait(~done);
			end
		end
	end
	
endmodule
