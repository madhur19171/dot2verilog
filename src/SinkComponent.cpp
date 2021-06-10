/*
 * SinkComponent.cpp
 *
 *  Created on: 05-Jun-2021
 *      Author: madhur
 */


#include "ComponentClass.h"

SinkComponent::SinkComponent(Component& c){
	moduleName = "sink_node";
	name = c.name;
	instanceName = moduleName + "_" + name;
	type = c.type;
	bbID = c.bbID;
	op = c.op;
	in = c.in;
	out = c.out;
	delay = c.delay;
	latency = c.latency;
	II = c.II;
	slots = c.slots;
	transparent = c.transparent;
	value = c.value;
	io = c.io;
	inputConnections = c.inputConnections;
	outputConnections = c.outputConnections;

	clk = c.clk;
	rst = c.rst;

}

//Overriding InputPortBus and OutputPortBus functions as
//Sink only has input port and no output ports.
//So setOutputPortBus() function will set outputPortBus to an empty string
void SinkComponent::setOutputPortBus(){
	outputPortBus = "";
}

std::string SinkComponent::getModuleInstantiation(std::string tabs){
	setInputPortBus();
	setOutputPortBus();

	std::string ret;
	//Module name followed by verilog parameters followed by the Instance name
	ret += tabs;
	ret += moduleName + " " + getVerilogParameters() + instanceName + "\n";
	ret += tabs + "\t";
	ret += "(.clk(" + clk + "), .rst(" + rst + "),\n";
	ret += tabs + "\t";
	ret += inputPortBus + ");";
	//Sink does not have any output port bus

	return ret;
}

std::string SinkComponent::getVerilogParameters(){
	std::string ret;
	//This method of generating module parameters will work because Start node has
	//only 1 input and 1 output
	ret += "#(.INPUTS(1), .OUTPUTS(0), ";
	ret += ".DATA_IN_SIZE(" + std::to_string(getVectorLength(in) == 0 ? 1 : getVectorLength(in)) + "))";
	//Since there is no output, DATA_OUT_SIZE can be default
	return ret;
}




std::string SinkComponent::getInputOutputConnections(){
	std::string ret;

	ret += "\tassign " + clk + " = clk;\n";
	ret += "\tassign " + rst + " = rst;\n";

	return ret;
}

