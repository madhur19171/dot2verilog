//-----------------------------------------------------------------------
//-- int add, version 0.0
//-----------------------------------------------------------------------
module add_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] + data_in[1];

endmodule



//-----------------------------------------------------------------------
//-- int sub, version 0.0
//-----------------------------------------------------------------------
//If data_in_bus contains two data a and b of 32 bit width such that data_in_bus = {a, b}, then sub_op returns b - a as the answer
module sub_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] - data_in[1];

endmodule


//-----------------------------------------------------------------------
//-- int multiply, version 0.0
//-----------------------------------------------------------------------
//If data_in_bus contains two data a and b of 32 bit width such that data_in_bus = {a, b}, then sub_op returns b * a as the answer
module mul_op #(parameter INPUTS = 2,
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
	localparam LATENCY = 4;

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
	wire [OUTPUTS - 1 : 0]valid_out;
	reg [OUTPUTS - 1 : 0]ready_out = 0;
	
	wire [2 * DATA_OUT_SIZE - 1 : 0] temp_result;
	
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
	
	wire join_valid;
	wire buff_valid, oehb_valid, oehb_ready;
	wire oehb_dataOut, oehb_datain;
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(join_valid), .ready_out(oehb_ready));
	
	mul_4_stage multiply_unit (.clk(clk), .ce(oehb_ready), .a(data_in[0]), .b(data_in[1]), .p(data_out[0]));
	
	delay_buffer #(.SIZE(LATENCY - 1))delay_buff(.clk(clk), .rst(rst), .valid_in(join_valid), .ready_in(oehb_ready), .valid_out(buff_valid));
	
	OEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(1), .DATA_OUT_SIZE(1)) oehb_buffer (.clk(clk), .rst(rst),
										 .data_in_bus(0), .valid_in_bus(buff_valid), .ready_in_bus(oehb_ready),
										 .data_out_bus(oehb_dataOut), .valid_out_bus(valid_out[0]), .ready_out_bus(ready_out[0]));
	


endmodule



//-----------------------------------------------------------------------
//-- logical and, version 0.0
//-----------------------------------------------------------------------
module and_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] & data_in[1];

endmodule



//-----------------------------------------------------------------------
//-- logical or, version 0.0
//-----------------------------------------------------------------------
module or_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] | data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- logical xor, version 0.0
//-----------------------------------------------------------------------
module xor_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] ^ data_in[1];

endmodule


//Sext and Zext to be included. What are they anyway?
//Is Sext for converting Unsigned data to signed data?
//Is zext doing the same thing?

module sext_op #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
		(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg signed [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire signed [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
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
	
	assign data_out[0] = data_in[0];
	assign valid_out[0] = valid_in[0];
	assign ready_in[0] = ~valid_in[0] | valid_out[0] & ready_out[0];
	
	
endmodule



module zext_op #(parameter INPUTS = 1,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32)
		(
		input clk,
		input rst,
		input [INPUTS * (DATA_IN_SIZE)- 1 : 0]data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output reg [INPUTS - 1 : 0] ready_in_bus = 0,
		
		output reg signed [OUTPUTS * (DATA_OUT_SIZE) - 1 : 0]data_out_bus = 0,
		output reg [OUTPUTS - 1 : 0]valid_out_bus = 0,
		input 	[OUTPUTS - 1 : 0] ready_out_bus
);

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
	reg [INPUTS - 1 : 0] valid_in = 0;
	wire [INPUTS - 1 : 0] ready_in;
	
	wire signed [DATA_OUT_SIZE - 1 : 0] data_out[OUTPUTS - 1 : 0];
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
	
	assign data_out[0] = data_in[0];
	assign valid_out[0] = valid_in[0];
	assign ready_in[0] = ready_out[0];
	
	
endmodule


//-----------------------------------------------------------------------
//-- shl, version 0.0
//-----------------------------------------------------------------------
module shl_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));
	
	wire [DATA_IN_SIZE - 1 : 0]temp1, temp0;
	assign temp1 = data_in[1];
	assign temp0 = data_in[0];
	
	assign data_out[0] = temp0 << temp1;

endmodule




//-----------------------------------------------------------------------
//-- lshr, version 0.0
//-----------------------------------------------------------------------
module lshr_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));
	
	wire [DATA_IN_SIZE - 1 : 0]temp1, temp0;
	assign temp1 = data_in[1];
	assign temp0 = data_in[0];
	
	assign data_out[0] = temp0 >> temp1;

endmodule




//-----------------------------------------------------------------------
//-- ashr, version 0.0
//-----------------------------------------------------------------------
module ashr_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));
	
	wire [DATA_IN_SIZE - 1 : 0]temp1, temp0;
	assign temp1 = data_in[1];
	assign temp0 = data_in[0];
	assign data_out[0] = temp0 >>> temp1;

endmodule



//-----------------------------------------------------------------------
//-- Antitoken, version 0.0
//-----------------------------------------------------------------------
module antitokens(
	input clk,
	input rst,
	input valid_0, input valid_1,
	output kill_0,	output kill_1,
	input generate_0, input generate_1,
	output stop_valid
);
	wire reg_in_0, reg_in_1;
	reg  reg_out_0, reg_out_1;
	
	always@(posedge clk, posedge rst)
		if(rst) begin
			reg_out_0 <= 0;
			reg_out_1 <= 0;
		end else begin
			reg_out_0 <= reg_in_0;
			reg_out_1 <= reg_in_1;
		end
	
	assign reg_in_0 = ~valid_0 & (generate_0 | reg_out_0);
	assign reg_in_1 = ~valid_1 & (generate_1 | reg_out_1);
	
	assign stop_valid = reg_out_0 | reg_out_1;
	
	assign kill_0 = generate_0 | reg_out_0;
	assign kill_1 = generate_1 | reg_out_1; 

endmodule



//-----------------------------------------------------------------------
//-- Select, version 0.0
//-----------------------------------------------------------------------
//-- llvm select: operand(0) is condition, operand(1) is true, operand(2) is false
//-- here, dataInArray(0) is true, dataInArray(1) is false operand
//Since condition of select is always 1 bit wide, we will use a 32 bit bus for it 
//But utilize only the LSB of that bus for condition
//data_in_bus --> {32'bdataFalse, 32'bdataTrue, 32'bCondition}
module select_op #(parameter INPUTS = 3,
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
	
	wire condition;
	assign condition = data_in[0][0];
	
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
	
	
	wire ee, valid_internal, kill_0, kill_1, antitokenStop;
	wire g_0, g_1;
	
	assign ee = valid_in[1] & ((~condition & valid_in[0]) | (condition & valid_in[2]));
	assign valid_internal = ee & ~antitokenStop;
	
	assign g_0 = ~valid_in[2]  & valid_internal & ready_out[0];
	assign g_1 = ~valid_in[0]  & valid_internal & ready_out[0];
	
	assign valid_out[0] = valid_internal;
	assign ready_in[1] = (~valid_in[1]) | (valid_internal & ready_out[0]);
	assign ready_in[2] = (~valid_in[2]) | (valid_internal & ready_out[0]) | kill_0;
	assign ready_in[0] = (~valid_in[0]) | (valid_internal & ready_out[0]) | kill_1;
	
	assign data_out[0] = condition ? data_in[1] : data_in[2];
	
	antitokens select_antitokens(.clk(clk), .rst(rst),
					.valid_1(valid_in[0]), .valid_0(valid_in[2]), 
					.kill_1(kill_1), .kill_0(kill_0),
					.generate_1(g_1), .generate_0(g_0),
					.stop_valid(antitokenStop));
	
endmodule




//-----------------------------------------------------------------------
//-- icmp eq, version 0.0
//-----------------------------------------------------------------------
module icmp_eq_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] == data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- icmp ne, version 0.0
//-----------------------------------------------------------------------
module icmp_ne_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] != data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- ugt, version 0.0
//-----------------------------------------------------------------------
module icmp_ugt_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] > data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- icmp uge, version 0.0
//-----------------------------------------------------------------------
module icmp_uge_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] >= data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- sgt, version 0.0
//-----------------------------------------------------------------------
module icmp_sgt_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] > data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- icmp sge, version 0.0
//-----------------------------------------------------------------------
module icmp_sge_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] >= data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- ult, version 0.0
//-----------------------------------------------------------------------
module icmp_ult_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] < data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- icmp ule, version 0.0
//-----------------------------------------------------------------------
module icmp_ule_op #(parameter INPUTS = 2,
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] <= data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- slt, version 0.0
//-----------------------------------------------------------------------
module icmp_slt_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] < data_in[1];

endmodule




//-----------------------------------------------------------------------
//-- icmp sle, version 0.0
//-----------------------------------------------------------------------
module icmp_sle_op #(parameter INPUTS = 2,
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

	reg signed [DATA_IN_SIZE - 1 : 0] data_in[INPUTS - 1 : 0];
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
	
	joinC #(.N(INPUTS)) add_fork(.valid_in(valid_in), .ready_in(ready_in), .valid_out(valid_out), .ready_out(ready_out));

	assign data_out[0] = data_in[0] <= data_in[1];

endmodule


//-----------------------------------------------------------------------
//-- getelemntptr, version 0.0
//-----------------------------------------------------------------------
//nodes attribute := constants
//Higher inputs will contain constant values, specifically the dimensions
//Lower inputs will contain variable inputs which will be multiplied with constant dimensions
//to determine the address. This is used to for index translation for N dimensional Array to 1D array? 
module getelementptr_op #(parameter INPUTS = 3,
		parameter OUTPUTS = 1,
		parameter DATA_IN_SIZE = 32,
		parameter DATA_OUT_SIZE = 32,
		parameter CONST_SIZE = 1)
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
	
	
	joinC #(.N(INPUTS - CONST_SIZE)) (.valid_in(valid_in[INPUTS - CONST_SIZE - 1 : 0]),
					.ready_in(ready_in[INPUTS - CONST_SIZE - 1 : 0]),
					.valid_out(valid_out[0]),
					.ready_out(ready_out[0]));
					
	assign ready_in[INPUTS - 1 : INPUTS - CONST_SIZE] = {CONST_SIZE{1'b1}};
	
	integer temp_const = 1, temp_mul = 0;
	integer temp_data_out = 0;//Does it have to be unsigned?
	
	integer j;
	
	always @(*)begin
		temp_data_out = 0;
		for(i = 0; i < INPUTS - CONST_SIZE; i = i + 1)begin
			temp_const = 1;
			for(j = INPUTS - CONST_SIZE + i; j < INPUTS; j = j + 1)
				temp_const = temp_const * data_in[j];
			temp_mul = data_in[i] * temp_const;
			temp_data_out = temp_data_out + temp_mul;
		end
	end
	
	assign data_out[0] = temp_data_out[DATA_OUT_SIZE - 1 : 0];
	
endmodule




//-----------------------------------------------------------------------
//-- return, version 0.0
//-----------------------------------------------------------------------
module ret_op #(parameter INPUTS = 1,
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

	TEHB #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(DATA_IN_SIZE), .DATA_OUT_SIZE(DATA_OUT_SIZE)) ret_tehb
	(
		.clk(clk), .rst(rst),
		.data_in_bus(data_in_bus), .valid_in_bus(valid_in_bus), .ready_in_bus(ready_in_bus),
		.data_out_bus(data_out_bus), .valid_out_bus(valid_out_bus), .ready_out_bus(ready_out_bus)
	);
	
endmodule
