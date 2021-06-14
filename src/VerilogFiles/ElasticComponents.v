//----------------------------------------------------------------------- 
//-- join, version 0.0
//-----------------------------------------------------------------------

module joinC #(parameter N = 2)(
	input [N - 1 : 0] valid_in,
	output [N - 1 : 0] ready_in,
	output valid_out,
	input ready_out
);
	wire [N - 1 : 0]vo_nand_ro;//can be read as valid_out nand ready_out. This stores valid_out(nand)ready_out replicated N times
	
	assign valid_out = &valid_in;//AND of all the bits in valid_in vector
	assign vo_nand_ro = ~{N{valid_out & ready_out}};
	assign ready_in = ~(valid_in & vo_nand_ro);
endmodule


//----------------------------------------------------------------------- 
//-- tehb, version 0.0
//-----------------------------------------------------------------------
module TEHB #(parameter INPUTS = 2,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire reg_en, mux_sel;
	reg full_reg = 0;
	reg [DATA_IN_SIZE - 1 : 0] data_reg = 0;
	
	always@(posedge clk, posedge rst)
		if(rst)
			full_reg <= 0;
		else
			full_reg <= valid_out[0] & ~ready_in[0];
	
	always@(posedge clk, posedge rst)
		if(rst)
			data_reg <= 0;
		else if(reg_en)
			data_reg <= data_in[0];
			
			
	assign data_out[0] = mux_sel ? data_reg : data_in[0];
	
	assign valid_out[0] = valid_in[0] | full_reg;
	assign ready_in[0] = ~full_reg;
	assign reg_en = ready_in[0] & valid_in[0] & ~ ready_out[0];
	assign mux_sel = full_reg;
	
	
endmodule


//----------------------------------------------------------------------- 
//-- oehb, version 0.0
//-----------------------------------------------------------------------
module OEHB #(parameter INPUTS = 2,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	reg [OUTPUTS - 1 : 0]valid_out = 0;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire reg_en;
	reg [DATA_IN_SIZE - 1 : 0] data_reg = 0;
	
	always@(posedge clk, posedge rst)
		if(rst)
			valid_out[0] <= 0;
		else
			valid_out[0] <= valid_in[0] | ~ready_in[0];
	
	always@(posedge clk, posedge rst)
		if(rst)
			data_reg <= 0;
		else if(reg_en)
			data_reg <= data_in[0];
			
			
	assign data_out[0] = data_reg;
	
	assign ready_in[0] = ~valid_out[0] | ready_out[0];
	assign reg_en = ready_in[0] & valid_in[0];
	
	
endmodule


//----------------------------------------------------------------------- 
//-- elasticBuffer, version 0.0
//-----------------------------------------------------------------------
module elasticBuffer #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire valid_tehb, ready_tehb;
	wire valid_oehb, ready_oehb;
	wire[DATA_IN_SIZE - 1 : 0] data_out_tehb, data_out_oehb;
	
	//First Buffer
	TEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(DATA_IN_SIZE), .DATA_OUT_SIZE(DATA_OUT_SIZE))
	 tehb_elasticBuffer(
		.clk(clk), .rst(rst),
		
		.data_in_bus(data_in[0]),
		.valid_in_bus(valid_in),
		.ready_in_bus(ready_tehb),
		
		.data_out_bus(data_out_tehb),
		.valid_out_bus(valid_tehb),
		.ready_out_bus(ready_oehb)
	);
	
	//Following second buffer
	OEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(DATA_IN_SIZE), .DATA_OUT_SIZE(DATA_OUT_SIZE))
	oehb_elasticBuffer(
		.clk(clk), .rst(rst),
		
		.data_in_bus(data_out_tehb),
		.valid_in_bus(valid_tehb),
		.ready_in_bus(ready_oehb),
		
		.data_out_bus(data_out_oehb),
		.valid_out_bus(valid_oehb),
		.ready_out_bus(ready_out)
	);
	
	assign data_out[0] = data_out_oehb;
	assign valid_out[0] = valid_oehb;
	assign ready_in[0] = ready_tehb;
	
endmodule


/*----------------------------------------------------------------------- 
//-- elasticBuffer, version 1.0
//-----------------------------------------------------------------------
module elasticBuffer #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	reg [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire Em, Es;
	reg[DATA_IN_SIZE - 1 : 0] data_int = 0;
	reg valid_buff_low = 0, valid_buff_high = 0;
	reg stop_buff_low = 0, stop_buff_high = 0;
	wire stop_in, stop_out;
	
	//First Buffer
	always @(*)begin
		if(rst)
			data_int <= 0;
		else if(~clk & Em)
			data_int <= data_in[0];
			
	end
	
	//Second Buffer
	always @(*)begin
		if(rst)
			data_out[0] <= 0;
		else if(clk & Es)
			data_out[0] <= data_int;
			
	end
	
	//Low Valid Buffer
	always @(*)
		if(rst)
			valid_buff_low <= 0;
		else if(~clk)
			valid_buff_low <= valid_in[0] | stop_buff_high;
			
	//High Valid Buffer
	always @(*)
		if(rst)
			valid_buff_high <= 0;
		else if(clk)
			valid_buff_high <= valid_buff_low | stop_buff_low;
			
	//Low Stop Buffer
	always @(*)
		if(rst)
			stop_buff_low <= 0;
		else if(~clk)
			stop_buff_low <= valid_buff_high & stop_out;
			
 	//High Stop Buffer
	always @(*)
		if(rst)
			stop_buff_high <= 0;
		else if(clk)
			stop_buff_high <= valid_buff_low & stop_buff_low;
			
	assign stop_out = ~ready_out[0];
	assign stop_in = stop_buff_high;
	assign ready_in[0] = ~stop_in;
	assign valid_out[0] = valid_buff_high;
	
	assign Em = valid_in[0] & ~stop_in;
	assign Es = valid_buff_low & ~stop_buff_low;
			

endmodule*/




//----------------------------------------------------------------------- 
//-- merge, version 0.0
//-----------------------------------------------------------------------
module merge_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	reg [DATA_IN_SIZE - 1 : 0] temp_data_out = 0;
	reg temp_valid_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end
		
		for(i = INPUTS - 1; i >= 0; i = i - 1)begin
			if(valid_in[i])begin
				temp_data_out = data_in[i];
				temp_valid_out = 1;
			end
		end

	end
	
	wire[DATA_IN_SIZE - 1 : 0] tehb_data_in;
	wire tehb_valid_in;
	wire tehb_ready;
	
	assign tehb_data_in = temp_data_out;
	assign temp_valid_in = temp_valid_out;
	assign ready_in = {(INPUTS){tehb_ready}};
	
	TEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(DATA_IN_SIZE), .DATA_OUT_SIZE(DATA_OUT_SIZE)) merge_tehb(.clk(clk), .rst(rst),
	.data_in_bus(tehb_data_in), .valid_in_bus(tehb_valid_in), .ready_in_bus(tehb_ready),
	.data_out_bus(data_out[0]), .valid_out_bus(valid_out[0]), .ready_out_bus(ready_out[0])); 
	
endmodule




//----------------------------------------------------------------------- 
//-- merge_notehb, version 0.0
//-----------------------------------------------------------------------
module merge_notehb_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output [INPUTS - 1 : 0] ready_in_bus,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	reg [DATA_IN_SIZE - 1 : 0] temp_data_out = 0;
	reg temp_valid_out = 0;
	
	integer i;
	
	assign ready_in_bus = {ready_in[1], ready_in[0]};

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			//ready_in_bus[i] = ready_in[i];
			
			if(valid_in[i])begin
				temp_data_out = data_in[i];
				temp_valid_out = 1;
			end
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire[DATA_IN_SIZE - 1 : 0] tehb_data_in;
	wire tehb_valid_in;
	wire tehb_ready;
	
	assign tehb_data_in = temp_data_out;
	assign tehb_valid_in = temp_valid_out;
	assign ready_in = {(INPUTS){tehb_ready}};
	
	assign tehb_ready = ready_out[0];
	assign valid_out[0] = tehb_valid_in;
	assign data_out[0] = tehb_data_in;
	
endmodule




//----------------------------------------------------------------------- 
//-- controlmerge, version 0.0
//-----------------------------------------------------------------------
//data_out_bus will contain {condition, data_out}
module cntrlMerge_node #(parameter INPUTS = 2,
		parameter OUTPUTS = 2,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	wire [DATA_OUT_SIZE - 1 : 0] cond_out;
	wire cond_valid_out;
	reg cond_ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end
		
		
		cond_ready_out = ready_out[1];
	end
	
	
	assign data_out[1] = cond_out;
	assign valid_out[1] = cond_valid_out;
	
	wire [1 : 0] phi_c1_ready_in;
	wire phi_c1_valid_out;
	wire phi_c1_data_out;
	
	wire oehb1_ready_in;
	wire oehb_data_out;
	wire oehb1_valid_out;
	wire index;
	
	wire fork_c1_ready_in;
	wire [1 : 0] fork_c1_data_out;
	wire [1 : 0] fork_c1_valid_out;
	
	assign ready_in = phi_c1_ready_in;
	
	assign index = ~valid_in[0];
	
	merge_notehb_node #(2, 1, 1, 1) cntrlMerge_merge(.clk(clk), .rst(rst),
				 .data_in_bus (2'b11), .valid_in_bus({valid_in[1], valid_in[0]}), .ready_in_bus(phi_c1_ready_in),
				 .data_out_bus(phi_c1_data_out), .valid_out_bus(phi_c1_valid_out), .ready_out_bus(oehb1_ready_in));
			
			
	TEHB #(1, 1, 1, 1) cntrlMerge_tehb(.clk(clk), .rst(rst),
			.data_in_bus(index), .valid_in_bus(phi_c1_valid_out), .ready_in_bus(oehb1_ready_in),
			.data_out_bus(oehb_data_out), .valid_out_bus(oehb1_valid_out), .ready_out_bus(fork_c1_ready_in));	 
	
	fork_node #(1, 2, 1, 1) cntrlMerge_fork(.clk(clk), .rst(rst),
			.data_in_bus(1'b1), .valid_in_bus(oehb1_valid_out), .ready_in_bus(fork_c1_ready_in),
			.data_out_bus(fork_c1_data_out), .valid_out_bus(fork_c1_valid_out), .ready_out_bus({cond_ready_out, ready_out[0]}));
			
	assign valid_out[0] = fork_c1_valid_out[0];
	assign cond_valid_out = fork_c1_valid_out[1];
	
	assign cond_out = oehb_data_out;
	
endmodule




//----------------------------------------------------------------------- 
//-- Branch, version 0.0
//-----------------------------------------------------------------------
//data_out_bus is organized as {out2-:32, out1+:32}
//data_in_bus is organized as {condition, data_in}
module branch_node #(parameter INPUTS = 2,
		parameter OUTPUTS = 2,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	reg [INPUTS - 1 : 0] ready_in;
	
	reg cond = 0;
	reg cond_valid = 0;
	wire cond_ready;
	
	reg [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	wire ready_in_0;
	
	integer i;

	always @(*) begin
	
		cond = data_in[1][0];
		cond_valid = valid_in[1];
		ready_in[1] = cond_ready;
		ready_in[0] = ready_in_0;
	
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out[i] = data_in[0];
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	wire join_valid;
	wire join_ready;
	
	joinC #(.N(2)) join_branch(.valid_in({valid_in[0], cond_valid}), .ready_in({ready_in_0, cond_ready}), 
				    .valid_out(join_valid), .ready_out(join_ready));
				    
	assign valid_out[1] = ~cond & join_valid;
	assign valid_out[0] = cond & join_valid;
	
	assign join_ready = ready_out[1] & ~cond | ready_out[0] & cond;
	 
	
endmodule




//----------------------------------------------------------------------- 
//-- MUX, version 0.0
//-----------------------------------------------------------------------
//The data_in_bus will be {condition, data_in[N-1], data_in[N-2]......data_in[0]}
//Condition will be at the top of bus. This is done so that the data_in array can be indexed easily with condition
module mux_node #(parameter INPUTS = 3,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32,
		parameter COND_SIZE = 1)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 2 : 0];
	reg [INPUTS - 2 : 0] valid_in = 0;
	reg [INPUTS - 2 : 0] ready_in;
	
	reg [DATA_IN_SIZE - 1 : 0] cond = 0;
	wire [DATA_IN_SIZE - 1 : 0] cond_wire;
	reg cond_valid = 0;
	wire cond_ready;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	
	reg [DATA_OUT_SIZE - 1 : 0] temp_data_out = 0;
	reg temp_valid_out = 0;
	
	wire tehb_ready;
	wire[DATA_IN_SIZE - 1 : 0] tehb_data_in;
	wire tehb_valid;
	
	integer i;

	always @(*) begin
	
		cond = data_in_bus[INPUTS * (DATA_IN_SIZE)- 1 -: 32];
		cond_valid = valid_in_bus[INPUTS - 1];
		ready_in_bus[INPUTS - 1] = cond_ready;
 	
		for(i = INPUTS - 2; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			if((i == cond & cond_valid & tehb_ready & valid_in[i]) | ~valid_in[i])
				ready_in[i] = 1;
			else
				ready_in[i] = 0;
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end
		

	end
	

	
	always@(*)begin
		temp_data_out = data_in[0];
		temp_valid_out = 0;
		if(cond_valid & valid_in[cond])begin
			temp_data_out = data_in[cond];
			temp_valid_out = 1;
		end
	end
	
	assign cond_ready = ~cond_valid | (temp_valid_out & tehb_ready);
	
	assign tehb_data_in = temp_data_out;
	assign tehb_valid = temp_valid_out;
	
	TEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) mux_tehb(
		.clk(clk), .rst(rst),
		.data_in_bus(tehb_data_in), .valid_in_bus(tehb_valid), .ready_in_bus(tehb_ready),
		.data_out_bus(data_out[0]), .valid_out_bus(valid_out[0]), .ready_out_bus(ready_out[0])
	);
	
endmodule


//----------------------------------------------------------------------- 
//-- end, version 0.0
//-----------------------------------------------------------------------

module end_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter MEMORY_INPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus,
		
		input [MEMORY_INPUTS - 1 : 0] e_valid_bus,
		output reg [MEMORY_INPUTS - 1 : 0] e_ready_bus = 0
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	reg [MEMORY_INPUTS - 1 : 0] e_valid;
	wire [MEMORY_INPUTS - 1 : 0] e_ready;

	reg inp_valid = 0;
	reg [DATA_IN_SIZE - 1 : 0]inp_data = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end
		
		if(MEMORY_INPUTS != 0)
			for(i = MEMORY_INPUTS - 1; i >= 0; i = i - 1) begin
				e_valid[i] = e_valid_bus[i];
				e_ready_bus[i] = e_ready[i];
			end
		else
			e_valid = 2'b11;

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end
		
		
		for(i = 0; i <= INPUTS - 1; i = i + 1)begin
			if(valid_in[i])begin
				inp_valid = valid_in[i];
				inp_data = data_in[i];
			end
		end

	end

	
	assign data_out[0] = inp_data;
	
	
	wire mem_valid;
	assign mem_valid = &e_valid;
	
	wire [1 : 0]join_ready_in;
	wire join_valid_out, join_ready_out;
	assign join_ready_out = ready_out[0];
	assign ready_in = { (INPUTS){join_ready_in[1]} };
	assign valid_out[0] = join_valid_out;
	
	joinC #(.N(2)) join_end_node(
		.valid_in({inp_valid, mem_valid}),
		.ready_in(join_ready_in),
		.valid_out(join_valid_out),
		.ready_out(join_ready_out)
	); 
	
endmodule



//----------------------------------------------------------------------- 
//-- Start, version 0.0
//-----------------------------------------------------------------------
module start_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always@(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	reg set = 0, start_internal = 0;
	
	always@(posedge clk, posedge rst) begin
		if(rst)begin
			start_internal <= 0;
			set <= 0;
		end else if(valid_in[0] & ~set) begin
			start_internal <= 1;
			set <= 1;
		end else
			start_internal <= 0;
	end
	
	elasticBuffer #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(DATA_IN_SIZE), .DATA_OUT_SIZE(DATA_OUT_SIZE))
	start_elasticBuffer (
		.clk(clk), .rst(rst),
		
		.data_in_bus(data_in[0]),
		.valid_in_bus(start_internal),
		.ready_in_bus(ready_in[0]),
		
		.data_out_bus(data_out[0]),
		.valid_out_bus(valid_out[0]),
		.ready_out_bus(ready_out[0])
	);
	
endmodule




//----------------------------------------------------------------------- 
//-- Eager Fork, version 0.0
//-----------------------------------------------------------------------
module fork_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 3,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	reg [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always@(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out[i] = data_in[0];
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	
	wire [OUTPUTS - 1 : 0] temp_or, temp_and, out_and;
	wire validAndReady;
	reg [OUTPUTS - 1 : 0] out_ff = 0;
	
	always@(posedge clk, posedge rst)begin
		if(rst)
			out_ff <= 0;
		else
			out_ff <= temp_or;
	end
	
	assign valid_out = {OUTPUTS{valid_in[0]}} & out_ff;
	
	assign temp_and = ~ready_out & out_ff;
	
	assign ready_in = ~(|temp_and);
	
	assign validAndReady = ~(valid_in & ~ready_in);
	
	assign temp_or = {OUTPUTS{validAndReady}} | temp_and;
	
	
endmodule



//----------------------------------------------------------------------- 
//-- source, version 0.0
//-----------------------------------------------------------------------
module source_node #(parameter INPUTS = 0,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		
		output reg [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always@(*) begin

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end

	
	assign valid_out[0] = 1;

endmodule


//----------------------------------------------------------------------- 
//-- sink, version 0.0
//-----------------------------------------------------------------------
module sink_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end
	end
	
	assign ready_in[0] = 1;

endmodule



//----------------------------------------------------------------------- 
//-- Const, version 0.0
//-----------------------------------------------------------------------
module const_node #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output [INPUTS - 1 : 0] ready_in_bus,
		
		output [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus,
		output [OUTPUTS - 1 : 0]valid_out_bus,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	/*always@(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_IN_SIZE - 1 -: DATA_IN_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_OUT_SIZE - 1 -: DATA_OUT_SIZE] <= data_out[i];
			valid_out_bus[i] <= valid_out[i];
			ready_out[i] <= ready_out_bus[i];
		end

	end
	
	assign data_out[0] = data_in[0];
	assign valid_out[0] = valid_in[0];
	assign ready_in[0] = ready_out[0];*/
	
	assign data_out_bus = data_in_bus;
	assign valid_out_bus = valid_in_bus;
	assign ready_in_bus = ready_out_bus;
	
endmodule








