/*
 * dot_reader.cpp
 *
 *  Created on: 28-May-2021
 *      Author: madhur
 */

#include "dot_reader.h"
#include "typeinfo"

//Constructor
DotReader::DotReader(){
	DotReader::fileName = "";
	numberOfBlocks = 0;
}
DotReader::DotReader(std::string file_name){
	DotReader::fileName = file_name;
	numberOfBlocks = 0;
}

//Reads every line of dot file and removes comments.
int DotReader::lineReader(){
	std::ifstream inputFile;
	std::string line;//Single line to be read in a loop

	inputFile.open(fileName);

	if(inputFile.is_open()){
		std::cout << "File opened for reading" << std::endl;
	}else{
		std::cout << "Error opening the File for reading" << std::endl;
		return 1;
	}

	while(!inputFile.eof()){
		std::getline(inputFile, line);
		lines.push_back(line);
	}

	inputFile.close();

	//Function calls to generate a Component Graph
	removeTabs();
	removeComments();
	readComponentDeclarations();
	readGlobalComponentConnections();
	//readIntraBlockConnections has to be called before readInterBlockConnections
	//Because the first InterBlockConnection follows the first intraBlockConnection block
	while(readIntraBlockConnections() || readInterBlockConnections());
	generateComponentList();
	generateConnectionMap();


	return 0;
}


//Puts the ComponentConnection data into the component connection io element in the structure
//The globalCompoentConnections, intraBlockConnection, interBlockConnection are read to get the
//component connection informations and using that info, it is determined which component is connected to which other component
void DotReader::generateConnectionMap(){
	std::vector<std::string>::iterator it;
	std::string line;

	for(it = globalComponentConnection.begin(); it != globalComponentConnection.end(); it++){
		line = *it;
		std::pair<std::string, std::string> pair;
		std::pair<std::string, std::pair<std::string, std::string>> connection;
		std::string name = substring(line, 1, line.find('"', 1));
		connection.first = substring(line, line.find('>') + 3, line.find('"', line.find('>') + 3));
		pair.first = substring(line, line.find("from = ") + 8, line.find('"', line.find("from = ") + 8));
		pair.second = substring(line, line.find("to = ") + 6, line.find('"', line.find("to = ") + 6));
		connection.second = pair;
		componentMap[name].connections.io.push_back(connection);
	}

	for(it = intraBlockConnection.begin(); it != intraBlockConnection.end(); it++){
		line = *it;
		std::pair<std::string, std::string> pair;
		std::pair<std::string, std::pair<std::string, std::string>> connection;
		std::string name = substring(line, 1, line.find('"', 1));
//		std::cout << name << " ----> ";
		connection.first = substring(line, line.find('>') + 3, line.find('"', line.find('>') + 3));
		pair.first = substring(line, line.find("from = ") + 8, line.find('"', line.find("from = ") + 8));
		pair.second = substring(line, line.find("to = ") + 6, line.find('"', line.find("to = ") + 6));
		connection.second = pair;
		componentMap[name].connections.io.push_back(connection);
		//		std::cout << componentMap[name].connections.io[0].first << std::endl;
	}

	for(it = interBlockConnection.begin(); it != interBlockConnection.end(); it++){
		line = *it;
		std::pair<std::string, std::string> pair;
		std::pair<std::string, std::pair<std::string, std::string>> connection;
		std::string name = substring(line, 1, line.find('"', 1));
		connection.first = substring(line, line.find('>') + 3, line.find('"', line.find('>') + 3));
		pair.first = substring(line, line.find("from = ") + 8, line.find('"', line.find("from = ") + 8));
		pair.second = substring(line, line.find("to = ") + 6, line.find('"', line.find("to = ") + 6));
		connection.second = pair;
		componentMap[name].connections.io.push_back(connection);
	}
}

//This function reads the conponentDeclaration list and initializes the various elements of component structure
//based on the information present in the componentDeclaration lines
//Then pushes the components into componentList and componentMap indexed by their names
void DotReader::generateComponentList(){
	std::vector<std::string>::iterator it;
	struct component component;
	std::string line;

	for(it = componentDeclaration.begin(); it != componentDeclaration.end(); it++){
		line = *it;
		component.name = substring(line, line.find('"') + 1, line.find('"', line.find('"') + 1));
		component.type = line.find("type = ") == std::string::npos ? DEFAULT_TYPE : substring(line, line.find("type = ") + 8, line.find('"', line.find("type = ") + 8));
		component.bbID = line.find("bbID= ") == std::string::npos ? DEFAULT_BBID : std::stoi(substring(line, line.find("bbID= ") + 6, line.find(',', line.find("bbID= ") + 6)));
		component.in = line.find("in = ") == std::string::npos ? DEFAULT_IN : trim(substring(line, line.find("in = ") + 6, line.find('"', line.find("in = ") + 6)));
		component.out = line.find("out = ") == std::string::npos ? DEFAULT_OUT : trim(substring(line, line.find("out = ") + 7, line.find('"', line.find("out = ") + 7)));
		component.delay = line.find("delay=") == std::string::npos ? DEFAULT_DELAY : std::stof(substring(line, line.find("delay=") + 6, std::min(line.find(',', line.find("delay=") + 6), line.find(']', line.find("delay=") + 6))));
		component.latency = line.find("latency=") == std::string::npos ? DEFAULT_LATENCY : std::stof(substring(line, line.find("latency=") + 8, std::min(line.find(',', line.find("latency=") + 8), line.find(']', line.find("latency=") + 8))));
		component.II = line.find("II=") == std::string::npos ? DEFAULT_II : std::stoi(substring(line, line.find("II=") + 3, std::min(line.find(',', line.find("II=") + 3), line.find(']', line.find("II=") + 3))));
		component.slots = line.find("slots=") == std::string::npos ? DEFAULT_SLOTS : std::stoi(substring(line, line.find("slots=") + 6, std::min(line.find(',', line.find("slots=") + 6), line.find(']', line.find("slots=") + 6))));
		component.op = line.find("op = ") == std::string::npos ? DEFAULT_OP : substring(line, line.find("op = ") + 6, line.find('"', line.find("op = ") + 6));
		component.value = line.find("value = ") == std::string::npos ? DEFAULT_VALUE : (unsigned long) std::stol(substring(line, line.find("value = ") + 9, line.find('"', line.find("value = ") + 9)), NULL, 16);
		componentList.push_back(component);
		componentMap[component.name] = component;
		//		std::cout << "done" << std::endl;
	}
}


//Reads inter-block connections
//This portion just follows the inter-block connection
int DotReader::readInterBlockConnections(){
	std::vector<std::string>::iterator it;
	int retVal = 0;//If 0, this means that no more inter-block connections, if 1 then more inter-block connection

	it = lines.begin();

	//Following the }, if there is "->" in the following line, this means that line has
	//Inter-Block connection information
	if((*it).find('>') != std::string::npos
			&& it != lines.end()){
		retVal = 1;
		//When we encounter our first { or EOF, this means that we have encountered a new subgraph
		//and the inter-block connections data is over
		//Or reached EOF
		while(!((*it).find('{') != std::string::npos
				|| it == lines.end())){
			interBlockConnection.push_back(*it);
			it = lines.erase(it);
		}
	}

	return retVal;
}

//Reads intra-block Connections
//This section is encountered when we enter a subgraph block
int DotReader::readIntraBlockConnections(){
	std::vector<std::string>::iterator it;
	int retVal = 0;//If 0, this means that no more subgraphs, if 1 then more subgraphs

	it = lines.begin();

	//If we find a {, this means we have encountered a subgraph
	//So we go further to read the component connections in that subgraph
	if((*it).find('{') != std::string::npos
			&& it != lines.end()){
		numberOfBlocks++;//increment the number of blocks by 1
		retVal = 1;
		it = lines.erase(it);//Delete the line with {
		it = lines.erase(it);//Delete the line with color info;
		it = lines.erase(it);//Delete the line with label info;

		//The first } encounter means that we encounter the end of intra-block connections
		//Otherwise just push the line containing block connection data into intraBlockConnection
		while(!((*it).find('}') != std::string::npos
				|| it == lines.end())){
			intraBlockConnection.push_back(*it);
			std::cout << *it << std::endl;
			it = lines.erase(it);
		}
		it = lines.erase(it);
	}

	return retVal;
}

//Reads component Connections Blocks
//This portion just follows the Component declarations
void DotReader::readGlobalComponentConnections(){
	std::vector<std::string>::iterator it;
	it = lines.begin();

	//When we encounter our first { or EOF, this means that we have encountered a subgraph
	//Or reached EOF
	while(!((*it).find('{') != std::string::npos
			|| it == lines.end())){
		globalComponentConnection.push_back(*it);
		it = lines.erase(it);
	}
}


//Reads component Declaration Blocks
void DotReader::readComponentDeclarations(){
	std::vector<std::string>::iterator it;
	it = lines.begin();
	it = lines.erase(it);//Delete the line Digraph G{
	it = lines.erase(it);//Delete the line splines=spline;

	//While we do not encounter any >, or { or EOF this means that we are still in global component
	//Declaration section. The first > will be encountered when there are *global component connections*
	//First { will be encountered when there are *subgraphs(blocks)*
	while(!((*it).find('>') != std::string::npos
			|| (*it).find('{') != std::string::npos
			|| it == lines.end())){
		componentDeclaration.push_back(*it);
		it = lines.erase(it);
	}
}

//Removes tabs from file
void DotReader::removeTabs(){
	std::string::iterator it;
	std::string newLine;
	std::string oldLine;

	for(unsigned int i = 0; i < lines.size(); i++){
		oldLine = lines[i];
		newLine = "";
		for(it = oldLine.begin(); it != oldLine.end(); it++){
			if(!(*it == '\t'))
				newLine += *it;
		}
		lines[i] = newLine;
	}
	std::cout << "Tabs Removed" << std::endl;
}

//Removes comments in dot file
void DotReader::removeComments(){
	std::vector<std::string>::iterator it;
	for(it = lines.begin(); it != lines.end();){
		if((*it)[0] == '/' && (*it)[1] == '/'){
			it = lines.erase(it);
		}
		else
			it++;
	}
	std::cout << "Comments Removed" << std::endl;
}

//void DotReader::printComponent(struct component s){
//	std::cout << "name: " << s.name << ", "
//			<< "type: " << s.type << ", "
//			<< "bbID: " << s.bbID << ", "
//			<< "op: " << s.op << ", "
//			<< "in: " << s.in << ", "
//			<< "out: " << s.out << ", "
//			<< "delay: " << s.delay << ", "
//			<< "latency" << s.latency << ", "
//			<< "II: " << s.II << ", "
//			<< "slots: " << s.slots << ", "
//			<< "transparent: " << s.transparent << ", "
//			<< "value: " << s.value << std::endl;
//}

void DotReader::printComponent(struct component s){
	std::cout << "name: " << s.name << "\t"
			<< "type: " << s.type << "\t"
			<< "bbID: " << s.bbID << "\t"
			<< "op: " << s.op << "\t"
			<< "in: " << s.in << "\t"
			<< "out: " << s.out << "\t"
			<< "delay: " << s.delay << "\t"
			<< "latency" << s.latency << "\t"
			<< "II: " << s.II << "\t"
			<< "slots: " << s.slots << "\t"
			<< "transparent: " << s.transparent << "\t"
			<< "value: " << s.value << std::endl;
}


std::string DotReader::trim(std::string __str){
	if(*__str.end() == ' '){
		return substring(__str, 0, __str.size() - 1);
	}
	else
		return __str;
}



std::string DotReader::substring(std::string __str, int start, int stop){
	const std::string& ret = __str.substr(start, stop - start);
	return ret;
}


















