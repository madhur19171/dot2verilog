//----------------------------------------------------------------------- 
//-- LSQ Load Operation, version 0.0
//-----------------------------------------------------------------------
//As always Address is in 1 and data is in 0


//Wrong implementation. There will be problem when data size and address size are not equal
module lsq_load_op #(parameter INPUTS = 2,
		parameter OUTPUTS = 2,
		parameter DATA_SIZE = 32,
		parameter ADDRESS_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_SIZE - 1 -: DATA_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_SIZE - 1 -: DATA_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	assign data_out[1] = data_in[1];
	assign valid_out[1] = valid_in[1];
	assign ready_in[1] = ready_out[1];
	
	assign data_out[0] = data_in[0];
	assign valid_out[0] = valid_in[0];
	assign ready_in[0] = ready_out[0];
endmodule




//----------------------------------------------------------------------- 
//-- LSQ Store Operation, version 0.0
//-----------------------------------------------------------------------
//As always Address is in 1 and data is in 0

//Wrong implementation. There will be problem when data size and address size are not equal
module lsq_store_op #(parameter INPUTS = 2,
		parameter OUTPUTS = 2,
		parameter DATA_SIZE = 32,
		parameter ADDRESS_SIZE = 32)
	(
		input clk,
		input rst,
		input [INPUTS * (DATA_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg [OUTPUTS * (DATA_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg [DATA_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	integer i;

	always @(*) begin
		for(i = INPUTS - 1; i >= 0; i = i - 1) begin
			data_in[i] = data_in_bus[(i + 1) * DATA_SIZE - 1 -: DATA_SIZE];
			valid_in[i] = valid_in_bus[i];
			ready_in_bus[i] = ready_in[i];
		end

		for(i = OUTPUTS - 1; i >= 0; i = i - 1) begin
			data_out_bus[(i + 1) * DATA_SIZE - 1 -: DATA_SIZE] = data_out[i];
			valid_out_bus[i] = valid_out[i];
			ready_out[i] = ready_out_bus[i];
		end

	end
	
	assign data_out[1] = data_in[1];
	assign valid_out[1] = valid_in[1];
	assign ready_in[1] = ready_out[1];
	
	assign data_out[0] = data_in[0];
	assign valid_out[0] = valid_in[0];
	assign ready_in[0] = ready_out[0];
endmodule

