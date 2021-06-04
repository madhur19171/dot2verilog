/*
 * EndComponent.cpp
 *
 *  Created on: 04-Jun-2021
 *      Author: madhur
 */


#include "ComponentClass.h"

EndComponent::EndComponent(Component& c){
	moduleName = "end_node";
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
	connections = c.connections;
	inputConnections = c.inputConnections;
	outputConnections = c.outputConnections;

	clk = c.clk;
	rst = c.rst;

	//here pvalid and pready are to distinguish these TopModule IO ports from(p stands for port)
	//local entity valid and ready signals
	//	port_dout = substring(name, 0, name.find('_')) + "_" + "dout";
	//	port_valid = substring(name, 0, name.find('_')) + "_" + "pvalid";
	//	port_ready = substring(name, 0, name.find('_')) + "_" + "pready";
	port_dout = name + "_" + "dout";
	port_valid = name + "_" + "pvalid";
	port_ready = name + "_" + "pready";
}


//Returns the input/output declarations for top-module
std::string EndComponent::getModuleIODeclaration(std::string tabs){
	std::string ret = "";
	ret += tabs + "output " + generateVector(out) + port_dout + ",\n";
	ret += tabs + "output " + port_valid + ",\n";
	ret += tabs + "input " + port_ready + ",\n";
	ret += "\n";

	return ret;
}


std::string EndComponent::getModuleInstantiation(std::string tabs){
	setInputPortBus();
	setOutputPortBus();

	std::string ret;
	//Module name followed by verilog parameters followed by the Instance name
	ret += tabs;
	ret += moduleName + " " + getVerilogParameters() + instanceName + "\n";
	ret += tabs + "\t";
	ret += "(.clk(" + clk + "), .rst(" + rst + "),\n";
	ret += tabs + "\t";
	ret += inputPortBus + ", \n";
	ret += tabs + "\t";
	ret += outputPortBus + ");";

	return ret;
}

std::string EndComponent::getVerilogParameters(){
	std::string ret;
	//This method of generating module parameters will work because Start node has
	//only 1 input and 1 output
	ret += "#(.INPUTS(1), .OUTPUTS(1), .MEMORY_INPUTS(0), ";
	ret += ".DATA_IN_SIZE(" + std::to_string(getVectorLength(in) == 0 ? 1 : getVectorLength(in)) + "), ";
	ret += ".DATA_OUT_SIZE(" + std::to_string(getVectorLength(out) == 0 ? 1 : getVectorLength(out)) + ")) ";
	//0 data size will lead to negative port length in verilog code. So 0 data size has to be made 1.
	return ret;
}
