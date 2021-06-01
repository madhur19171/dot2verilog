/*
 * GraphToVerilog.h
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#ifndef GRAPHTOVERILOG_H_
#define GRAPHTOVERILOG_H_

#pragma once

#include "dot_reader.h"
#include "Graph.h"

class GraphToVerilog{
public:
	GraphToVerilog(DotReader dotReader);

	const std::string& getVerilogCode() const {
		return verilogCode;
	}

private:
	DotReader dotReader;
	std::string tabs;
	std::string verilogCode;
	std::vector<component> modulePortComponents;

	void insertTab();
	void removeTab();
	void insertVerilogCode(std::string& str);
	void declareModulePorts();
	void generateModulePortComponents();
	std::string generateVector(int from, int to);
	int getVectorLength(std::string str);
};

#endif /* GRAPHTOVERILOG_H_ */
