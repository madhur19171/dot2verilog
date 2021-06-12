///*
// * dot_reader.h
// *
// *  Created on: 28-May-2021
// *      Author: madhur
// */
//#ifndef DOT_READER_H_
//#define DOT_READER_H_
//
//#pragma once
//#include <fstream>
//#include <iostream>
//#include <cstdint>
//#include <string>
//#include <vector>
//#include <map>
//#include <utility>
////#include <boost/algorithm/string/trim.hpp>
//#include "ComponentClass.h"
//
//class DotReader{
//private:
//	std::string fileName;
//	int numberOfBlocks;
//	std::vector<std::string> lines;//Stores the lines of dot file
//	std::vector<std::string> componentDeclaration;//Global Declaration line of design Components.
//	std::vector<std::string> globalComponentConnection;//Connection line of global Components
//	std::vector<std::string> intraBlockConnection;//Connection line of Components that are within some block
//	std::vector<std::string> interBlockConnection;//Connection line of Components that are in two different blocks
//	std::vector<Component*> componentList;//List of all the Components present in the design
//	std::map<std::string, Component*> componentMap;//List of all the Components indexed by their names(string)
//
//
//public:
//	DotReader();//Default Constructor
//	DotReader(std::string file_name);//Parameterized constructor
//
//	void destroyObjects();
//
//
//	int lineReader();//Reads the Dot file line by line and stores each line in lines vector
//
//	//getters
//	std::vector<std::string>& getLines()  {
//		return lines;
//	}
//
//	std::vector<std::string>& getComponentDeclaration()  {
//		return componentDeclaration;
//	}
//
//	//Returns lines with info about global component connections
//	std::vector<std::string>& getGlobalComponentConnection()  {
//		return globalComponentConnection;
//	}
//	//Returns lines with info about component connections between two blocks
//	std::vector<std::string>& getInterBlockConnection() {
//		return interBlockConnection;
//	}
//	//Returns lines with info about component connections inside respective blocks
//	std::vector<std::string>& getIntraBlockConnection() {
//		return intraBlockConnection;
//	}
//
//	int getNumberOfBlocks() {
//		return numberOfBlocks;
//	}
//
//	std::vector<Component*>& getComponentList() {
//		return componentList;
//	}
//
//	std::map<std::string, Component*>& getComponentMap(){
//		return componentMap;
//	}
//
//	std::string& getFileName() {
//		return fileName;
//	}
//
//private:
//	void removeTabs();//Removes tab from starting of a line
//	void removeComments();//Removes comments
//	void readComponentDeclarations();//Reads the Component information lines(just following splines=spline line)
//	void readGlobalComponentConnections();//Reads global Component connection lines
//	int readIntraBlockConnections();//Reads intra-block connection lines
//	int readInterBlockConnections();//Reads inter-block connection lines
//	void generateComponentList();//Populates ComponentList and ComponentMap vector and map respectively by reading ComponentDeclarations
//	void generateConnectionMap();//Populates the connection element of Component by reading BlockConnections
//};
//
//
//#endif /* DOT_READER_H_ */
