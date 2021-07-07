`timescale 1ns/1ps

module two_port_RAM
	#( 
		parameter TV_IN = "", 
		TV_OUT = "", 
		DATA_WIDTH = 32,
		ADDR_WIDTH = 32,
		DEPTH      = 32
	)
	(
		input clk,
		input rst,
		input ce0,
		input we0,
		input[ADDR_WIDTH - 1 : 0] address0,
		output reg [DATA_WIDTH - 1 : 0] mem_dout0,
		input[DATA_WIDTH - 1 : 0] mem_din0,
		input ce1,
		input we1,
		input[ADDR_WIDTH - 1 : 0] address1,
		output reg [DATA_WIDTH - 1 : 0] mem_dout1,
		input[DATA_WIDTH - 1 : 0] mem_din1,
		input done   
	);

	reg[DATA_WIDTH - 1 : 0] mem [0 : DEPTH - 1];
	reg[DATA_WIDTH - 1 : 0] mem_temp0 = 0;
	reg[DATA_WIDTH - 1 : 0] mem_temp1 = 0;
	reg write_done_flag = 0;
	
	integer i, file_temp;
	
	initial begin
		for(i = 0; i < DEPTH; i = i + 1)
			mem[i] = 0;
	end


//----------------------------------------------------------------------------
//-----------------------------------Read array-------------------------------
//-- Read data from file to array

	integer transaction_idx_read;	
	integer fp_read;
	integer i_read;
	reg [8 * 128 : 1] token_read = 0;
	
	initial begin
		if (TV_IN != "")begin
			wait(!rst);
			
			transaction_idx_read = 0;
			fp_read = $fopen(TV_IN, "r");
			
			if (fp_read == 0)begin
				$display("Failed to open file %s", TV_IN);
				$finish;
			end


			file_temp = $fscanf(fp_read, "%s\n", token_read);
			$display("%s\n", token_read[8 * 13 : 1]);
			if (token_read[8 * 13 : 1] != "[[[runtime]]]") begin
				$display("ERROR: Simulation using HLS TB failed.");
				$finish;
			end
			
			
			file_temp = $fscanf(fp_read, "%s\n", token_read);
			while (token_read[8 * 14 : 1] != "[[[/runtime]]]") begin
				if (token_read[15 * 8 : 1] != "[[transaction]]") begin
					$display("ERROR: Simulation using HLS TB failed.");
					$finish;
				end
				
				//esl_read_token(fp, token_line, token); -- Skip transaction number
				//-- Start to read data for every transaction round
				while(~done) 
					@(posedge clk);

				file_temp = $fscanf(fp_read, "%s\n", token_read);
				for(i_read = 0; i_read < DEPTH; i_read = i_read + 1)begin
					file_temp = $fscanf(fp_read, "0x%x\n", token_read);
					mem[i_read] = token_read[DATA_WIDTH : 1];
				end
				
				file_temp = $fscanf(fp_read, "%s\n", token_read);
				wait(done == 0);

				if (token_read[16 * 8 : 1] != "[[/transaction]]") begin
					$display("ERROR: Simulation using HLS TB failed.");
					$finish;
				end
				
				file_temp = $fscanf(fp_read, "%s\n", token_read);
				transaction_idx_read = transaction_idx_read + 1;
			end
			$fclose(fp_read);
		end
	end
//----------------------------------------------------------------------------
//	-- Read data from array to RTL
	
always @(posedge clk, posedge rst)
    begin
        if(rst)
            mem_dout0 <= 0;
        else if((ce0 === 1) & (ce1 === 1) & (we1 === 1) & (address0 == address1))begin//Case equality because ce0 and we0 may be x
			mem_temp0 = mem_din1;
                	#0.1 mem_dout0 = mem_temp0;
		end
             else if((ce0 === 1) & (address0 < DEPTH))begin
			mem_temp0 = mem[address0];
                	#0.1 mem_dout0 = mem_temp0;
		end
    end

always @(posedge clk, posedge rst)
    begin
        if(rst)
            mem_dout1 <= 0;
        else if((ce0 === 1) & (ce1 === 1) & (we0 === 1) & (address0 == address1))begin
			mem_temp1 = mem_din0;
                	#0.1 mem_dout1 = mem_temp1;
		end
             else if(ce1 & (address1 < DEPTH))begin
			mem_temp1 = mem[address1];
                	#0.1 mem_dout1 = mem_temp1;
		end
    end


//----------------------Write array-------------------------------------------

//	--Write data from RTL to array

always @(posedge clk)
    begin
    	if((ce0 === 1) & (we0 === 1) & (ce1 === 1) & (we1 === 1) & (address0 == address1))
    		mem[address0] <= mem_din1;
    	else if((ce0 === 1) & (we0 === 1))
    		mem[address0] <= mem_din0;
    end

  always@(posedge clk)
    begin
    	if((ce1 === 1) & (we1 === 1))
    		mem[address1] <= mem_din1;
    end
    
    
//----------------------------------------------------------------------------
//	-- Write data from array to file

	integer transaction_idx_write;	
	integer fp_write;
	integer i_write;
	reg [8 * 128 : 1] token_write = 0;
initial 
	begin
		if (TV_OUT != "")begin
			wait(~rst);
			
			transaction_idx_write = 0;
			
			while(~done)
				@(posedge clk);
				
			wait(~done);       

			while (1) begin
				while (~done)
					@(posedge clk);
					
				fp_write = $fopen(TV_OUT, "a");
				
				if(fp_write == 0)begin
					$display("Failed to open file %s", TV_OUT);
					$finish;
				end
				
				$display("Transaction: %d", transaction_idx_write);
				
				$fwrite(fp_write, "[[transaction]] %d\n", transaction_idx_write);
				
				for(i_write = 0; i_write < DEPTH; i_write = i_write + 1)begin
					$fwrite(fp_write, "0x%x\n", mem[i_write]);
				end
				$fwrite(fp_write, "[[/transaction]]\n");
				
				transaction_idx_write = transaction_idx_write + 1;
				$fclose(fp_write);
				
				wait(~done);
			end
		end
	end
	
endmodule
