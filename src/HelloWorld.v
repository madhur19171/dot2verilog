module /media/madhur/CommonSpace/Work/Dynamatic/Installation/etc/dynamatic/dot2verilog/dot2verilog/src/HelloWorld(
	input clk,
	input rst,

	input [31 : 0]a_din,
	input a_pvalid,
	output a_pready,

	input [31 : 0]b_din,
	input b_pvalid,
	output b_pready,

	output [31 : 0]end_0_dout,
	output end_0_pvalid,
	input end_0_pready,

	input [0 : 0]start_0_din,
	input start_0_pvalid,
	output start_0_pready

);

	wire a_clk;
	wire a_rst;
	wire [31 : 0]a_in1_data;
	wire a_in1_ready;
	wire a_in1_valid;
	wire [31 : 0]a_out1_data;
	wire a_out1_ready;
	wire a_out1_valid;

	wire b_clk;
	wire b_rst;
	wire [31 : 0]b_in1_data;
	wire b_in1_ready;
	wire b_in1_valid;
	wire [31 : 0]b_out1_data;
	wire b_out1_ready;
	wire b_out1_valid;

	wire icmp_0_clk;
	wire icmp_0_rst;
	wire [31 : 0]icmp_0_in1_data;
	wire icmp_0_in1_ready;
	wire icmp_0_in1_valid;
	wire [31 : 0]icmp_0_in2_data;
	wire icmp_0_in2_ready;
	wire icmp_0_in2_valid;
	wire [0 : 0]icmp_0_out1_data;
	wire icmp_0_out1_ready;
	wire icmp_0_out1_valid;

	wire cst_0_clk;
	wire cst_0_rst;
	wire [31 : 0]cst_0_in1_data;
	wire cst_0_in1_ready;
	wire cst_0_in1_valid;
	wire [31 : 0]cst_0_out1_data;
	wire cst_0_out1_ready;
	wire cst_0_out1_valid;

	wire sub_1_clk;
	wire sub_1_rst;
	wire [31 : 0]sub_1_in1_data;
	wire sub_1_in1_ready;
	wire sub_1_in1_valid;
	wire [31 : 0]sub_1_in2_data;
	wire sub_1_in2_ready;
	wire sub_1_in2_valid;
	wire [31 : 0]sub_1_out1_data;
	wire sub_1_out1_ready;
	wire sub_1_out1_valid;

	wire select_0_clk;
	wire select_0_rst;
	wire [0 : 0]select_0_in1_data;
	wire select_0_in1_ready;
	wire select_0_in1_valid;
	wire [31 : 0]select_0_in2_data;
	wire select_0_in2_ready;
	wire select_0_in2_valid;
	wire [31 : 0]select_0_in3_data;
	wire select_0_in3_ready;
	wire select_0_in3_valid;
	wire [31 : 0]select_0_out1_data;
	wire select_0_out1_ready;
	wire select_0_out1_valid;

	wire add_2_clk;
	wire add_2_rst;
	wire [31 : 0]add_2_in1_data;
	wire add_2_in1_ready;
	wire add_2_in1_valid;
	wire [31 : 0]add_2_in2_data;
	wire add_2_in2_ready;
	wire add_2_in2_valid;
	wire [31 : 0]add_2_out1_data;
	wire add_2_out1_ready;
	wire add_2_out1_valid;

	wire ret_0_clk;
	wire ret_0_rst;
	wire [31 : 0]ret_0_in1_data;
	wire ret_0_in1_ready;
	wire ret_0_in1_valid;
	wire [31 : 0]ret_0_out1_data;
	wire ret_0_out1_ready;
	wire ret_0_out1_valid;

	wire fork_0_clk;
	wire fork_0_rst;
	wire [31 : 0]fork_0_in1_data;
	wire fork_0_in1_ready;
	wire fork_0_in1_valid;
	wire [31 : 0]fork_0_out1_data;
	wire fork_0_out1_ready;
	wire fork_0_out1_valid;
	wire [31 : 0]fork_0_out2_data;
	wire fork_0_out2_ready;
	wire fork_0_out2_valid;

	wire fork_1_clk;
	wire fork_1_rst;
	wire [31 : 0]fork_1_in1_data;
	wire fork_1_in1_ready;
	wire fork_1_in1_valid;
	wire [31 : 0]fork_1_out1_data;
	wire fork_1_out1_ready;
	wire fork_1_out1_valid;
	wire [31 : 0]fork_1_out2_data;
	wire fork_1_out2_ready;
	wire fork_1_out2_valid;
	wire [31 : 0]fork_1_out3_data;
	wire fork_1_out3_ready;
	wire fork_1_out3_valid;

	wire end_0_clk;
	wire end_0_rst;
	wire [31 : 0]end_0_in1_data;
	wire end_0_in1_ready;
	wire end_0_in1_valid;
	wire [31 : 0]end_0_out1_data;
	wire end_0_out1_ready;
	wire end_0_out1_valid;

	wire start_0_clk;
	wire start_0_rst;
	wire [0 : 0]start_0_in1_data;
	wire start_0_in1_ready;
	wire start_0_in1_valid;
	wire [0 : 0]start_0_out1_data;
	wire start_0_out1_ready;
	wire start_0_out1_valid;

	wire sink_0_clk;
	wire sink_0_rst;
	wire [0 : 0]sink_0_in1_data;
	wire sink_0_in1_ready;
	wire sink_0_in1_valid;

	wire source_0_clk;
	wire source_0_rst;
	wire [31 : 0]source_0_out1_data;
	wire source_0_out1_ready;
	wire source_0_out1_valid;

	start_node #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) start_node_a
		(.clk(a_clk), .rst(a_rst),
		.data_in_bus({a_in1_data}), .valid_in_bus({a_in1_valid}), .ready_in_bus({a_in1_ready}), 
		.data_out_bus({a_out1_data}), .valid_out_bus({a_out1_valid}), .ready_out_bus({a_out1_ready}));

	start_node #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) start_node_b
		(.clk(b_clk), .rst(b_rst),
		.data_in_bus({b_in1_data}), .valid_in_bus({b_in1_valid}), .ready_in_bus({b_in1_ready}), 
		.data_out_bus({b_out1_data}), .valid_out_bus({b_out1_valid}), .ready_out_bus({b_out1_ready}));

	icmp_sgt_op #(.INPUTS(2), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(1)) icmp_sgt_op_icmp_0
		(.clk(icmp_0_clk), .rst(icmp_0_rst),
		.data_in_bus({icmp_0_in2_data, icmp_0_in1_data}), .valid_in_bus({icmp_0_in2_valid, icmp_0_in1_valid}), .ready_in_bus({icmp_0_in2_ready, icmp_0_in1_ready}), 
		.data_out_bus({icmp_0_out1_data}), .valid_out_bus({icmp_0_out1_valid}), .ready_out_bus({icmp_0_out1_ready}));

	const_node #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) const_node_cst_0
		(.clk(cst_0_clk), .rst(cst_0_rst),
		.data_in_bus({32'd0}), .valid_in_bus({cst_0_in1_valid}), .ready_in_bus({cst_0_in1_ready}), 
		.data_out_bus({cst_0_out1_data}), .valid_out_bus({cst_0_out1_valid}), .ready_out_bus({cst_0_out1_ready}));

	sub_op #(.INPUTS(2), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) sub_op_sub_1
		(.clk(sub_1_clk), .rst(sub_1_rst),
		.data_in_bus({sub_1_in2_data, sub_1_in1_data}), .valid_in_bus({sub_1_in2_valid, sub_1_in1_valid}), .ready_in_bus({sub_1_in2_ready, sub_1_in1_ready}), 
		.data_out_bus({sub_1_out1_data}), .valid_out_bus({sub_1_out1_valid}), .ready_out_bus({sub_1_out1_ready}));

	select_op #(.INPUTS(3), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) select_op_select_0
		(.clk(select_0_clk), .rst(select_0_rst),
		.data_in_bus({select_0_in3_data, select_0_in2_data, {31'b0, select_0_in1_data}}), .valid_in_bus({select_0_in3_valid, select_0_in2_valid, select_0_in1_valid}), .ready_in_bus({select_0_in3_ready, select_0_in2_ready, select_0_in1_ready}), 
		.data_out_bus({select_0_out1_data}), .valid_out_bus({select_0_out1_valid}), .ready_out_bus({select_0_out1_ready}));

	add_op #(.INPUTS(2), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) add_op_add_2
		(.clk(add_2_clk), .rst(add_2_rst),
		.data_in_bus({add_2_in2_data, add_2_in1_data}), .valid_in_bus({add_2_in2_valid, add_2_in1_valid}), .ready_in_bus({add_2_in2_ready, add_2_in1_ready}), 
		.data_out_bus({add_2_out1_data}), .valid_out_bus({add_2_out1_valid}), .ready_out_bus({add_2_out1_ready}));

	ret_op #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) ret_op_ret_0
		(.clk(ret_0_clk), .rst(ret_0_rst),
		.data_in_bus({ret_0_in1_data}), .valid_in_bus({ret_0_in1_valid}), .ready_in_bus({ret_0_in1_ready}), 
		.data_out_bus({ret_0_out1_data}), .valid_out_bus({ret_0_out1_valid}), .ready_out_bus({ret_0_out1_ready}));

	fork_node #(.INPUTS(1), .OUTPUTS(2), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) fork_node_fork_0
		(.clk(fork_0_clk), .rst(fork_0_rst),
		.data_in_bus({fork_0_in1_data}), .valid_in_bus({fork_0_in1_valid}), .ready_in_bus({fork_0_in1_ready}), 
		.data_out_bus({fork_0_out2_data, fork_0_out1_data}), .valid_out_bus({fork_0_out2_valid, fork_0_out1_valid}), .ready_out_bus({fork_0_out2_ready, fork_0_out1_ready}));

	fork_node #(.INPUTS(1), .OUTPUTS(3), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) fork_node_fork_1
		(.clk(fork_1_clk), .rst(fork_1_rst),
		.data_in_bus({fork_1_in1_data}), .valid_in_bus({fork_1_in1_valid}), .ready_in_bus({fork_1_in1_ready}), 
		.data_out_bus({fork_1_out3_data, fork_1_out2_data, fork_1_out1_data}), .valid_out_bus({fork_1_out3_valid, fork_1_out2_valid, fork_1_out1_valid}), .ready_out_bus({fork_1_out3_ready, fork_1_out2_ready, fork_1_out1_ready}));

	end_node #(.INPUTS(1), .OUTPUTS(1), .MEMORY_INPUTS(0), .DATA_IN_SIZE(32), .DATA_OUT_SIZE(32)) end_node_end_0
		(.clk(end_0_clk), .rst(end_0_rst),
		.data_in_bus({end_0_in1_data}), .valid_in_bus({end_0_in1_valid}), .ready_in_bus({end_0_in1_ready}), 
		.data_out_bus({end_0_out1_data}), .valid_out_bus({end_0_out1_valid}), .ready_out_bus({end_0_out1_ready}));

	start_node #(.INPUTS(1), .OUTPUTS(1), .DATA_IN_SIZE(1), .DATA_OUT_SIZE(1)) start_node_start_0
		(.clk(start_0_clk), .rst(start_0_rst),
		.data_in_bus({start_0_in1_data}), .valid_in_bus({start_0_in1_valid}), .ready_in_bus({start_0_in1_ready}), 
		.data_out_bus({start_0_out1_data}), .valid_out_bus({start_0_out1_valid}), .ready_out_bus({start_0_out1_ready}));

	sink_node #(.INPUTS(1), .OUTPUTS(0), .DATA_IN_SIZE(1))sink_node_sink_0
		(.clk(sink_0_clk), .rst(sink_0_rst),
		.data_in_bus({sink_0_in1_data}), .valid_in_bus({sink_0_in1_valid}), .ready_in_bus({sink_0_in1_ready}));

	source_node #(.INPUTS(0), .OUTPUTS(1), .DATA_OUT_SIZE(32))source_node_source_0
		(.clk(source_0_clk), .rst(source_0_rst),
		.data_out_bus({source_0_out1_data}), .valid_out_bus({source_0_out1_valid}), .ready_out_bus({source_0_out1_ready}));



	assign a_clk = clk;
	assign a_rst = rst;
	assign a_in1_data = a_din;
	assign a_in1_valid = a_pvalid;
	assign a_pready = a_in1_ready;
	assign fork_0_in1_data = a_out1_data;
	assign fork_0_in1_valid = a_out1_valid;
	assign a_out1_ready = fork_0_in1_ready;

	assign b_clk = clk;
	assign b_rst = rst;
	assign b_in1_data = b_din;
	assign b_in1_valid = b_pvalid;
	assign b_pready = b_in1_ready;
	assign fork_1_in1_data = b_out1_data;
	assign fork_1_in1_valid = b_out1_valid;
	assign b_out1_ready = fork_1_in1_ready;

	assign icmp_0_clk = clk;
	assign icmp_0_rst = rst;
	assign select_0_in1_data = icmp_0_out1_data;
	assign select_0_in1_valid = icmp_0_out1_valid;
	assign icmp_0_out1_ready = select_0_in1_ready;

	assign cst_0_clk = clk;
	assign cst_0_rst = rst;
	assign sub_1_in1_data = cst_0_out1_data;
	assign sub_1_in1_valid = cst_0_out1_valid;
	assign cst_0_out1_ready = sub_1_in1_ready;

	assign sub_1_clk = clk;
	assign sub_1_rst = rst;
	assign select_0_in3_data = sub_1_out1_data;
	assign select_0_in3_valid = sub_1_out1_valid;
	assign sub_1_out1_ready = select_0_in3_ready;

	assign select_0_clk = clk;
	assign select_0_rst = rst;
	assign add_2_in1_data = select_0_out1_data;
	assign add_2_in1_valid = select_0_out1_valid;
	assign select_0_out1_ready = add_2_in1_ready;

	assign add_2_clk = clk;
	assign add_2_rst = rst;
	assign ret_0_in1_data = add_2_out1_data;
	assign ret_0_in1_valid = add_2_out1_valid;
	assign add_2_out1_ready = ret_0_in1_ready;

	assign ret_0_clk = clk;
	assign ret_0_rst = rst;
	assign end_0_in1_data = ret_0_out1_data;
	assign end_0_in1_valid = ret_0_out1_valid;
	assign ret_0_out1_ready = end_0_in1_ready;

	assign fork_0_clk = clk;
	assign fork_0_rst = rst;
	assign icmp_0_in1_data = fork_0_out1_data;
	assign icmp_0_in1_valid = fork_0_out1_valid;
	assign fork_0_out1_ready = icmp_0_in1_ready;
	assign add_2_in2_data = fork_0_out2_data;
	assign add_2_in2_valid = fork_0_out2_valid;
	assign fork_0_out2_ready = add_2_in2_ready;

	assign fork_1_clk = clk;
	assign fork_1_rst = rst;
	assign icmp_0_in2_data = fork_1_out1_data;
	assign icmp_0_in2_valid = fork_1_out1_valid;
	assign fork_1_out1_ready = icmp_0_in2_ready;
	assign sub_1_in2_data = fork_1_out2_data;
	assign sub_1_in2_valid = fork_1_out2_valid;
	assign fork_1_out2_ready = sub_1_in2_ready;
	assign select_0_in2_data = fork_1_out3_data;
	assign select_0_in2_valid = fork_1_out3_valid;
	assign fork_1_out3_ready = select_0_in2_ready;

	assign end_0_clk = clk;
	assign end_0_rst = rst;
	assign end_0_dout = end_0_out1_data;
	assign end_0_out1_ready = end_0_pready;
	assign end_0_pvalid = end_0_out1_valid;

	assign start_0_clk = clk;
	assign start_0_rst = rst;
	assign start_0_in1_data = start_0_din;
	assign start_0_in1_valid = start_0_pvalid;
	assign start_0_pready = start_0_in1_ready;
	assign sink_0_in1_data = start_0_out1_data;
	assign sink_0_in1_valid = start_0_out1_valid;
	assign start_0_out1_ready = sink_0_in1_ready;

	assign sink_0_clk = clk;
	assign sink_0_rst = rst;

	assign source_0_clk = clk;
	assign source_0_rst = rst;
	assign cst_0_in1_data = source_0_out1_data;
	assign cst_0_in1_valid = source_0_out1_valid;
	assign source_0_out1_ready = cst_0_in1_ready;

endmodule
