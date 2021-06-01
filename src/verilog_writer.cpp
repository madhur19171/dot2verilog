//============================================================================
// Name        : verilog_writer.cpp
// Author      : Madhur Kumar
// Version     :
// Copyright   : Your copyright notice
// Description : writes .v files in C++, Ansi-style
//============================================================================

#include <iostream>
#include "GraphToVerilog.h"

using namespace std;

int main() {
	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!


	std::string fileName = "/media/madhur/CommonSpace/Work/Dynamatic/Installation/etc/dynamatic/dot2verilog/dot2verilog/src/histogram.dot";

	DotReader dotReader = DotReader(fileName);


	if(!dotReader.lineReader())
		std::cout << "Success" << std::endl;
	else
		std::cout << "Failure" << std::endl;

	for(unsigned int i = 0; i < dotReader.getLines().size(); i++){
		std::cout << dotReader.getLines().at(i) << std::endl;
	}
	std::cout << std::endl << std::endl;

	std::cout << "Component Declarations:" << std::endl;
	for(unsigned int i = 0; i < dotReader.getComponentDeclaration().size(); i++){
		std::cout << dotReader.getComponentDeclaration().at(i) << std::endl;
	}
	std::cout << std::endl << std::endl;

	std::cout << "Global Component Connections:" << std::endl;
	for(unsigned int i = 0; i < dotReader.getGlobalComponentConnection().size(); i++){
		std::cout << dotReader.getGlobalComponentConnection().at(i) << std::endl;
	}
	std::cout << std::endl << std::endl;

	std::cout << dotReader.getNumberOfBlocks() << std::endl;
	std::cout << std::endl << std::endl;

	std::cout << "Component List:" << std::endl;
	for(unsigned int i = 0; i < dotReader.getComponentList().size(); i++){
		(dotReader.getComponentList().at(i)).printComponent();
	}
	std::cout << std::endl << std::endl;

	Graph graph(dotReader);

	graph.startDFS();
	std::cout << std::endl << std::endl;

	GraphToVerilog graphToVerilog(dotReader);
	graphToVerilog.writeVerilogCode();
	std::cout << graphToVerilog.getVerilogCode() << std::endl;

	return 0;
}










