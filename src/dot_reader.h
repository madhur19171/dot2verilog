/*
 * dot_reader.h
 *
 *  Created on: 28-May-2021
 *      Author: madhur
 */
#ifndef DOT_READER_H_
#define DOT_READER_H_

#pragma once
#include <fstream>
#include <iostream>
#include <cstdint>
#include <string>
#include <vector>
#include <map>
#include <utility>
//#include <boost/algorithm/string/trim.hpp>
#include "entity_names.h"

class DotReader{
private:
	std::string fileName;
	int numberOfBlocks;
	std::vector<std::string> lines;//Stores the lines of dot file
	std::vector<std::string> componentDeclaration;//Global Declaration line of design components.
	std::vector<std::string> globalComponentConnection;//Connection line of global components
	std::vector<std::string> intraBlockConnection;//Connection line of components that are within some block
	std::vector<std::string> interBlockConnection;//Connection line of components that are in two different blocks
	std::vector<component> componentList;//List of all the components present in the design
	std::map<std::string, component> componentMap;//List of all the components indexed by their names(string)


public:
	DotReader();//Default Constructor
	DotReader(std::string file_name);//Parameterized constructor


	int lineReader();//Reads the Dot file line by line and stores each line in lines vector
	void printComponent(struct component s);//Prints all the information about a component

	//getters
	const std::vector<std::string>& getLines() const {
		return lines;
	}

	const std::vector<std::string>& getComponentDeclaration() const {
		return componentDeclaration;
	}

	const std::vector<std::string>& getGlobalComponentConnection() const {
		return globalComponentConnection;
	}

	int getNumberOfBlocks() const {
		return numberOfBlocks;
	}

	const std::vector<component>& getComponentList() const {
		return componentList;
	}

	const std::map<std::string, component>& getComponentMap() const {
		return componentMap;
	}

	const std::vector<std::string>& getInterBlockConnection() const {
		return interBlockConnection;
	}

	const std::vector<std::string>& getIntraBlockConnection() const {
		return intraBlockConnection;
	}


private:
	void removeTabs();//Removes tab from starting of a line
	void removeComments();//Removes comments
	void readComponentDeclarations();//Reads the component information lines(just following splines=spline line)
	void readGlobalComponentConnections();//Reads global component connection lines
	int readIntraBlockConnections();//Reads intra-block connection lines
	int readInterBlockConnections();//Reads inter-block connection lines
	void generateComponentList();//Populates componentList and componentMap vector and map respectively by reading componentDeclarations
	void generateConnectionMap();//Populates the connection element of component by reading BlockConnections
	std::string substring(std::string __str, int start, int stop);//Java like substring method
	std::string trim(std::string __str);//Trim the trailing spaces
};


#endif /* DOT_READER_H_ */
