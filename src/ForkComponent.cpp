/*
 * ForkComponent.cpp
 *
 *  Created on: 09-Jun-2021
 *      Author: madhur
 */

#include "ComponentClass.h"

//Subclass for Entry type component
ForkComponent::ForkComponent(Component& c){
	moduleName = "fork_node";
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


std::string ForkComponent::getModuleInstantiation(std::string tabs){
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

std::string ForkComponent::getVerilogParameters(){
	std::string ret;
	int numOutputs = 0;
	std::string tempStr;
	std::istringstream ss(out);
	while(ss >> tempStr)
		numOutputs++;
	//This method of generating module parameters will work because Start node has
	//only 1 input and 1 output
	ret += "#(.INPUTS(1), .OUTPUTS(" + std::to_string(numOutputs) + "), ";
	ret += ".DATA_IN_SIZE(" + std::to_string(getVectorLength(in) == 0 ? 1 : getVectorLength(in)) + "), ";
	ret += ".DATA_OUT_SIZE(" + std::to_string(getVectorLength(out) == 0 ? 1 : getVectorLength(out)) + ")) ";
	//0 data size will lead to negative port length in verilog code. So 0 data size has to be made 1.
	return ret;
}


std::string ForkComponent::getInputOutputConnections(){
	std::string ret;

	ret += "\tassign " + clk + " = clk;\n";
	ret += "\tassign " + rst + " = rst;\n";


	InputConnection inConn;
	OutputConnection outConn;
	Component* connectedToComponent;
	std::string connectedFromPort, connectedToPort;
	for(auto it = io.begin(); it != io.end(); it++){
		connectedToComponent = (*it).first;
		connectedFromPort = (*it).second.first;
		connectedToPort = (*it).second.second;
		inConn = connectedToComponent->inputConnections[connectedToPort];
		outConn = outputConnections[connectedFromPort];
		ret += connectInputOutput(inConn, outConn);
	}

	return ret;
}
