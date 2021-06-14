/*
 * ControlMergeComponent.cpp
 *
 *  Created on: 14-Jun-2021
 *      Author: madhur
 */


#import "ComponentClass.h"

//Subclass for Entry type component
ControlMergeComponent::ControlMergeComponent(Component& c){
	index = c.index;
	moduleName = "cntrlMerge_node";
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


std::string ControlMergeComponent::getModuleInstantiation(std::string tabs){
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

std::string ControlMergeComponent::getVerilogParameters(){
	std::string ret;
	//This method of generating module parameters will work because Start node has
	//only 1 input and 1 output
	ret += "#(.INPUTS(" + std::to_string(in.size) + "), .OUTPUTS(2), ";
	ret += ".DATA_IN_SIZE(" + std::to_string(in.input[0].bit_size == 0 ? 1 : in.input[0].bit_size) + "), ";
	ret += ".DATA_OUT_SIZE(1)) ";
	//0 data size will lead to negative port length in verilog code. So 0 data size has to be made 1.
	return ret;
}


//void ControlMergeComponent::setOutputPortBus(){
//	OutputConnection outConn;
//
//	//First create data_in bus
//	outputPortBus = ".data_out_bus({";
//	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
//	for(int i = outputConnections.size() - 1; i >= 0; i--){
//		outConn = outputConnections[i];
//		outputPortBus += outConn.data + ", ";
//	}
//	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
//	outputPortBus += "}), ";
//
//	//Now create valid_in bus
//	outputPortBus += ".valid_out_bus({";
//	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
//	for(int i = outputConnections.size() - 1; i >= 0; i--){
//		outConn = outputConnections[i];
//		outputPortBus += outConn.valid + ", ";
//	}
//	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
//	outputPortBus += "}), ";
//
//	//Now create ready_in bus
//	outputPortBus += ".ready_out_bus({";
//	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
//	for(int i = outputConnections.size() - 1; i >= 0; i--){
//		outConn = outputConnections[i];
//		outputPortBus += outConn.ready + ", ";
//	}
//	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
//	outputPortBus += "})";
//}


std::string ControlMergeComponent::getInputOutputConnections(){
	std::string ret;

	ret += "\tassign " + clk + " = clk;\n";
	ret += "\tassign " + rst + " = rst;\n";


	InputConnection inConn;
	OutputConnection outConn;
	Component* connectedToComponent;
	int connectedFromPort, connectedToPort;
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

