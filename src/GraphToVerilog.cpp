/*
 * GraphToVerilog.cpp
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#include "GraphToVerilog.h"

//Constructor
GraphToVerilog::GraphToVerilog(DotReader dotReader){
	this->dotReader = dotReader;
	verilogCode = "";
	tabs = "";
}

//Function that calls other functions to append their generated verilog code snippet
//The sequence in which the sub-functions are called determines in which sequence the snippet
//will appear in the final code.
//Eg. Module Name is the first thing of a verilog code
//Followed by Top Module Ports Input output declarations
//Followed by declaring wires that connect various sub components in the top module
void GraphToVerilog::writeVerilogCode(){
	verilogCode += writeTopModuleName();

	insertTab();
	verilogCode += writeTopModulePorts();
	removeTab();

	insertTab();
	verilogCode += writeModulePortWires();
	removeTab();

	verilogCode += writeEndModule();
}

//IO Ports are declared for components which are directly interfacing
//with the outside world.
//The following component types are to be provided IO Ports:
//1. Entry
//2. Exit
//3. LSQ
//4. MC

std::string GraphToVerilog::writeTopModulePorts(){
	std::string topModulePortList;
	generateTopModulePortComponents();

	//Clock and Reset signal are always present in the design ports
	topModulePortList += tabs + "input clk;\n" + tabs + "input rst;\n\n";

	//Writing IO Ports:
	std::vector<Component>::iterator it;

	for(it = topModulePortComponents.begin(); it != topModulePortComponents.end(); it++){
		if((*it).type == COMPONENT_START){
			StartComponent startComponent = (StartComponent)(*it);
			topModulePortList += startComponent.getModuleIODeclaration(tabs);
		} else if((*it).type == COMPONENT_END){
			EndComponent endComponent = (EndComponent)(*it);
			topModulePortList += endComponent.getModuleIODeclaration(tabs);
		} else if((*it).type == COMPONENT_MC){
			MemoryContentComponent memoryContentComponent = (MemoryContentComponent)(*it);
			topModulePortList += memoryContentComponent.getModuleIODeclaration(tabs);
		}
	}

	//Erasing this necessary to get rid of an extra "," just before closing top module port declarations
	topModulePortList = topModulePortList.erase(topModulePortList.size() - 3, 1);

	topModulePortList += ");\n\n";

	return topModulePortList;
}

//This function populates the topModulePortComponents which will contain
//All the components that need to have input output declarations in the top module
//port list
void GraphToVerilog::generateTopModulePortComponents(){
	std::vector<Component>::const_iterator it;

	for(it = dotReader.getComponentList().begin(); it != dotReader.getComponentList().end(); it++){
		if((*it).type == COMPONENT_START ||
				(*it).type == COMPONENT_END ||
				(*it).type == COMPONENT_MC ||
				(*it).type == COMPONENT_LSQ){
			topModulePortComponents.push_back((*it));
		}
	}
}

//This function accesses the getModulePortDeclarations function of each component to generate
//a declaration of all wires of input/output connections of the sub modules
//They include the data, valid and ready signal for all input and outputs of that component
//Additional ports can be added if needed for a particular component by overriding getModulePortDeclarations
//function in a sub class
std::string GraphToVerilog::writeModulePortWires(){
	std::string modulePortWires;
	std::vector<Component>::iterator it;

	for(it = dotReader.getComponentList().begin(); it != dotReader.getComponentList().end(); it++){
		modulePortWires += (*it).getModulePortDeclarations(tabs);
		modulePortWires += "\n";
	}

	return modulePortWires;
}

//Declares the top module.
std::string GraphToVerilog::writeTopModuleName(){
	std::string moduleName;

	std::string& file_n = dotReader.getFileName();
	file_n = substring(file_n, 0, file_n.find('.'));

	moduleName = "module " + file_n + "(\n";

	return moduleName;
}

std::string GraphToVerilog::writeEndModule(){
	return "endmodule";
}

//Till now, a useless function
void GraphToVerilog::insertVerilogCode(std::string& str){
	str = tabs + str + '\n';
	verilogCode += str;
}


void GraphToVerilog::insertTab(){
	tabs += "\t";
}

void GraphToVerilog::removeTab(){
	if(tabs.size() != 0)
		tabs = tabs.erase(0, 1);
}

