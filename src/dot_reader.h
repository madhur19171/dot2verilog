/*
 * dot_reader.h
 *
 *  Created on: 28-May-2021
 *      Author: madhur
 */
#ifndef DOT_READER_H_
#define DOT_READER_H_

#pragma once
//#define _GLIBCXX_USE_CXX11_ABI 0
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
	std::vector<std::string> componentDeclaration;//Global Declaration of design components.
	std::vector<std::string> globalComponentConnection;
	std::vector<std::string> intraBlockConnection;
	std::vector<std::string> interBlockConnection;
	std::vector<component> componentList;
	std::map<std::string, component> componentMap;
//	//A map to index by <name> and access <vector of <pair of <input> and <output>>>
//	std::unordered_map<std::string, std::vector<std::pair<std::string, std::string>>> connectionMap;



public:
	DotReader();//Default Constructor
	DotReader(std::string file_name);//Parameterized constructor


	int lineReader();//Reads the Dot file line by line and stores each line in lines vector
	void printComponent(struct component s);

	//getter for lines
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

//	const std::unordered_map<std::string,
//			std::vector<std::pair<std::string, std::string> > >& getConnectionMap() const {
//		return connectionMap;
//	}

private:
	void removeTabs();//Removes tab from starting of a line
	void removeComments();//Removes comments
	void readComponentDeclarations();
	void readGlobalComponentConnections();
	int readIntraBlockConnections();
	int readInterBlockConnections();
	void generateComponentList();
	void generateConnectionMap();
	std::string substring(std::string __str, int start, int stop);
	std::string trim(std::string __str);
};


#endif /* DOT_READER_H_ */
