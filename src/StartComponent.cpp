/*
 * StartComponent.cpp
 *
 *  Created on: 04-Jun-2021
 *      Author: madhur
 */

#include "ComponentClass.h"

//Subclass for Entry type component
StartComponent::StartComponent(Component& c){
	moduleName = "start_node";
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

	//here pvalid and pready are to distinguish these TopModule IO ports from(p stands for port)
	//local entity valid and ready signals
	//	port_din = substring(name, 0, name.find('_')) + "_" + "din";
	//	port_valid = substring(name, 0, name.find('_')) + "_" + "pvalid";
	//	port_ready = substring(name, 0, name.find('_')) + "_" + "pready";
	port_din = name + "_" + "din";
	port_valid = name + "_" + "pvalid";
	port_ready = name + "_" + "pready";
}

//Returns the input/output declarations for top-module
std::string StartComponent::getModuleIODeclaration(std::string tabs){
	std::string ret = "";
	ret += tabs + "input " + generateVector(in) + port_din + ",\n";
	ret += tabs + "input " + port_valid + ",\n";
	ret += tabs + "output " + port_ready + ",\n";
	ret += "\n";

	return ret;
}


std::string StartComponent::getModuleInstantiation(std::string tabs){
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

std::string StartComponent::getVerilogParameters(){
	std::string ret;
	//This method of generating module parameters will work because Start node has
	//only 1 input and 1 output
	ret += "#(.INPUTS(1), .OUTPUTS(1), ";
	ret += ".DATA_IN_SIZE(" + std::to_string(getVectorLength(in) == 0 ? 1 : getVectorLength(in)) + "), ";
	ret += ".DATA_OUT_SIZE(" + std::to_string(getVectorLength(out) == 0 ? 1 : getVectorLength(out)) + ")) ";
	//0 data size will lead to negative port length in verilog code. So 0 data size has to be made 1.
	return ret;
}


std::string StartComponent::getInputOutputConnections(){
	std::string ret;

	ret += "\tassign " + clk + " = clk;\n";
	ret += "\tassign " + rst + " = rst;\n";

	//First input of start component is connected to top module IO port
	ret += "\tassign " + inputConnections.at("in1").data + " = " + port_din + ";\n";
	ret += "\tassign " + inputConnections.at("in1").valid + " = " + port_valid + ";\n";
	ret += "\tassign " + port_ready + " = " + inputConnections.at("in1").ready + ";\n";


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


































