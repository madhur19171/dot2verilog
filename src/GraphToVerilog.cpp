/*
 * GraphToVerilog.cpp
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#include "GraphToVerilog.h"

GraphToVerilog::GraphToVerilog(DotReader dotReader){
	this->dotReader = dotReader;
	verilogCode = "";
	tabs = "";
}

//IO Ports are declared for components which are directly interfacing
//with the outside world.
//The following component types are to be provided IO Ports:
//1. Entry
//2. Exit
//3. LSQ
//4. MC

void GraphToVerilog::declareModulePorts(){
	std::string modulePortList;
	generateModulePortComponents();

	//Clock and Reset signal are always present in the design ports
	modulePortList += "\tinput clk;\n\tinput rst;\n";
	//Start ports:
	modulePortList += "\tinput start_in;\n\tinput start_valid;\n\toutput start_ready;\n";
	//End Ports:
	modulePortList += "\toutput end_out;\n\toutput end_valid;\n\tinput end_ready;\n";

	//Remaining IO Ports:
	std::vector<component>::iterator it;

	for(it = modulePortComponents.begin(); it != modulePortComponents.end(); it++){
		if((*it).name.find("start_") == std::string::npos && (*it).name.find("end_") == std::string::npos){
			if((*it).type == COMPONENT_START){

			}
		}
	}

}

void GraphToVerilog::generateModulePortComponents(){
	std::vector<component>::const_iterator it;

	for(it = dotReader.getComponentList().begin(); it != dotReader.getComponentList().end(); it++){
		if((*it).type == COMPONENT_START ||
				(*it).type == COMPONENT_END ||
				(*it).type == COMPONENT_MC ||
				(*it).type == COMPONENT_LSQ){
			modulePortComponents.push_back((*it));
		}
	}
}

void GraphToVerilog::insertVerilogCode(std::string& str){
	str = tabs + str + '\n';
	verilogCode += str;
}

//std::string GraphToVerilog::generateVector(int from, int to){
//	return ("[" + from + " : " + to + "]");
//}

int GraphToVerilog::getVectorLength(std::string str){
	unsigned int colon_pos = str.find(':');
	std::string length = "";

	for(unsigned int i = colon_pos + 1; i < str.size(); i++){
		if(str[i] >= '0' && str[i] <= '9')
			length += str[i];
		else
			break;
	}

	return stoi(length);
}

void GraphToVerilog::insertTab(){
	tabs += "\t";
}

void GraphToVerilog::removeTab(){
	tabs += "\b";
}

