/*
 * GraphToVerilog.h
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#ifndef GRAPHTOVERILOG_H_
#define GRAPHTOVERILOG_H_

#pragma once

#include "Graph.h"

class GraphToVerilog{
public:
	GraphToVerilog(DotReader dotReader);

	void writeVerilogCode();

	std::string& getVerilogCode() {
		return verilogCode;
	}

private:
	DotReader dotReader;
	std::string tabs = "";
	std::string verilogCode = "";
	std::vector<Component> topModulePortComponents;

	void insertTab();
	void removeTab();
	void insertVerilogCode(std::string& str);
	//writes wires that interconnects various modules inside top module
	std::string writeModulePortWires();
	//Writes port list for top module
	std::string writeTopModulePorts();
	//Generates a list of components which interface with top module port list
	void generateTopModulePortComponents();
	//Writes "module <name>("
	std::string writeTopModuleName();
	//Writes "endmodule;"
	std::string writeEndModule();
};

#endif /* GRAPHTOVERILOG_H_ */
