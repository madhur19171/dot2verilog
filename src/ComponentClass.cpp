/*
 * ComponentClass.cpp
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#include "ComponentClass.h"

//Default constructor to set every data item a default value
Component::Component(){
	name = DEFAULT_NAME;
	type = DEFAULT_TYPE;
	bbID = DEFAULT_BBID;
	in = DEFAULT_IN; out = DEFAULT_OUT;
	delay = DEFAULT_DELAY; latency = DEFAULT_LATENCY;
	II = DEFAULT_II;
	slots = DEFAULT_SLOTS;
	transparent = DEFAULT_TRANSPARENT;
	op = DEFAULT_OP;
	value = DEFAULT_VALUE;
}

//Prints data about a component
void Component::printComponent(){
	std::cout << "name: " << name << "\t"
			<< "type: " << type << "\t"
			<< "bbID: " << bbID << "\t"
			<< "op: " << op << "\t"
			<< "in: " << in << "\t"
			<< "out: " << out << "\t"
			<< "delay: " << delay << "\t"
			<< "latency" << latency << "\t"
			<< "II: " << II << "\t"
			<< "slots: " << slots << "\t"
			<< "transparent: " << transparent << "\t"
			<< "value: " << value << std::endl;
}

//Takes a string as input(string containing an input/output eg: in1:+32)
//then returns the length of the input/output port(in above example: 32)
int Component::getVectorLength(std::string str){
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

//Takes a string as input(string containing an input/output eg: in1:+32)
//then returns a string containing a verilog vector [<vectorLength - 1> : 0]
std::string Component::generateVector(std::string str){
	//Because indexing is done till 0 not 1
	int from = getVectorLength(str) - 1;
	//Incase the vector length is 0, we will receive from as 1 from the generateVector(str) method
	from = from < 0 ? 0 : from;
	return generateVector(from, 0);
}

//Returns a verilog vector: "[<from> : <to>]"
std::string Component::generateVector(int from, int to){
	from = from < 0 ? 0 : from;
	return ("[" + std::to_string(from) + " : " + std::to_string(to) + "]");
}

//This function is created just for easier understanding of code
//It generates an address port verilog vector for MC
std::string Component::getAddressPortVector(std::string _str){
	return (generateVector(_str));
}

//This function is created just for easier understanding of code
//It generates a data port verilog vector for MC
std::string Component::getDataPortVector(std::string _str){
	return (generateVector(_str));
}

//Returns the name of input/output port for that particular component.
//Eg: if str = "in2:+32" then it returns "in2"
//This function gets rid of :+32 and similar things
std::string Component::getIOName(std::string str){
	if(str.find("in") != std::string::npos){
		return ("in" + std::to_string(getIONumber(str)));
	} else if(str.find("out") != std::string::npos){
		return ("out" + std::to_string(getIONumber(str)));
	}

	return "";
}

//Takes an input/output port for a particular component then returns the port number
//Eg. if str = "in3:-16" then it returns 3 as 3 is  the input number
int Component::getIONumber(std::string str){
	std::string number;
	int num = 9;
	if(str.find("in") != std::string::npos){
		std::string::iterator it;
		str = substring(str, 2, str.size());
		for(it = str.begin(); it != str.end(); it++)
			if((*it) >= '0' && (*it) <= '9')
				number += *it;
			else
				break;
	} else if(str.find("out") != std::string::npos){
		std::string::iterator it;
		str = substring(str, 3, str.size());
		for(it = str.begin(); it != str.end(); it++)
			if((*it) >= '0' && (*it) <= '9')
				number += *it;
			else
				break;
	}
	//	std::cout << "|" << number << "|" << std::endl;
	num = stoi(number);
	return num;
}

//This function is supposed to cast the Component Class object to their corresponding
//Entity classes and return those casted objects.
Component Component::castToSubClass(){
	if(type == COMPONENT_START){
		StartComponent obj(*this);
		return obj;
	} else if(type == COMPONENT_END){
		EndComponent obj(*this);
		return obj;
	} else if(type == COMPONENT_MC){
		MemoryContentComponent obj(*this);
		return obj;
	}

	return *this;
}

//Populates the inputConnection map and sets the string(name) for each port of each input
//Eg. it gives unique names to data, ready and valid ports of a particular input
//The name will follow the convention:
//<Component name>_<input name>_data/ready/valid
void Component::setInputConnections(){
	std::string input;
	std::istringstream ss(in);

	while(ss >> input){
		std::string inputName = getIOName(input);
		InputConnection inConn;
		inConn.vectorLength = getVectorLength(input);
		inConn.data = name + "_" + inputName + "_" + "data";
		inConn.ready = name + "_" + inputName + "_" + "ready";
		inConn.valid = name + "_" + inputName + "_" + "valid";
		inputConnections[inputName] = inConn;
	}
}

//Same as setInputConnections(), but for outputs
void Component::setOutputConnections(){
	std::string output;
	std::istringstream ss(out);

	while(ss >> output){
		std::string outputName = getIOName(output);
		OutputConnection outConn;
		outConn.vectorLength = getVectorLength(output);
		outConn.data = name + "_" + outputName + "_" + "data";
		outConn.ready = name + "_" + outputName + "_" + "ready";
		outConn.valid = name + "_" + outputName + "_" + "valid";

		outputConnections[outputName] = outConn;
	}
}

//This returns the wires of an entity which connect it to other modules
//**This function also calls setInputConnections and setOutputConnections
//So, input Connections and outputConnections vectors of a component
//can be accessed only after this function has been called!
std::string Component::getModulePortDeclarations(std::string tabs){
	std::string ret = "";

	//**Clock and Reset signals are finally initialized here.
	//This should be moved to a function that is definitely called before this function.
	//Just in case this is required before this function.
	//A potential location for this snippet is the castToSubClass function as it is called as soon as
	//the component is created in dot_reader.
	//This could be moved to the respective entity subclass constructors
	//Just like port_din, port_valid and port_ready are moved in start, end and MC
	clk = name + "_" + "clk";
	rst = name + "_" + "rst";

	ret += tabs + "wire " + clk + ";\n";
	ret += tabs + "wire " + rst + ";\n";

	//If this Entity has any inputs:
	if(in != DEFAULT_IN){
		//set inputConnections and fill it with all the available inputs
		setInputConnections();
		std::map<std::string, InputConnection>::iterator it;
		//Iterate over the inputConnections and add a wire for each connection
		for(it = inputConnections.begin(); it != inputConnections.end(); it++){
			ret += tabs + "wire " + generateVector((*it).second.vectorLength - 1, 0) + (*it).second.data + ";\n";
			ret += tabs + "wire " + (*it).second.ready + ";\n";
			ret += tabs + "wire " + (*it).second.valid + ";\n";
		}
	}
	//If this entity has any outputs:
	if(out != DEFAULT_OUT){
		//set outputConnections and fill it with all the available outputs
		setOutputConnections();
		std::map<std::string, OutputConnection>::iterator it;
		//Iterate over the inputConnections and add a wire for each connection
		for(it = outputConnections.begin(); it != outputConnections.end(); it++){
			ret += tabs + "wire " + generateVector((*it).second.vectorLength - 1, 0) + (*it).second.data + ";\n";
			ret += tabs + "wire " + (*it).second.ready + ";\n";
			ret += tabs + "wire " + (*it).second.valid + ";\n";
		}
	}

	return ret;
}

//Subclass for Entry type component
StartComponent::StartComponent(Component& c){
	name = c.name;
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
	connections = c.connections;
	inputConnections = c.inputConnections;
	outputConnections = c.outputConnections;

	//here pvalid and pready are to distinguish these TopModule IO ports from(p stands for port)
	//local entity valid and ready signals
	//	port_din = substring(name, 0, name.find('_')) + "_" + "din";
	//	port_valid = substring(name, 0, name.find('_')) + "_" + "pvalid";
	//	port_ready = substring(name, 0, name.find('_')) + "_" + "pready";
	port_din = name + "_" + "din";
	port_valid = name + "_" + "pvalid";
	port_ready = name + "_" + "pready";
}

//Returns the input/output declarations for top-module
std::string StartComponent::getModuleIODeclaration(std::string tabs){
	std::string ret = "";
	ret += tabs + "input " + generateVector(in) + port_din + ",\n";
	ret += tabs + "input " + port_valid + ",\n";
	ret += tabs + "output " + port_ready + ",\n";
	ret += "\n";

	return ret;
}


EndComponent::EndComponent(Component& c){
	name = c.name;
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
	connections = c.connections;
	inputConnections = c.inputConnections;
	outputConnections = c.outputConnections;

	//here pvalid and pready are to distinguish these TopModule IO ports from(p stands for port)
	//local entity valid and ready signals
	//	port_dout = substring(name, 0, name.find('_')) + "_" + "dout";
	//	port_valid = substring(name, 0, name.find('_')) + "_" + "pvalid";
	//	port_ready = substring(name, 0, name.find('_')) + "_" + "pready";
	port_dout = name + "_" + "dout";
	port_valid = name + "_" + "pvalid";
	port_ready = name + "_" + "pready";
}

//Returns the input/output declarations for top-module
std::string EndComponent::getModuleIODeclaration(std::string tabs){
	std::string ret = "";
	ret += tabs + "output " + generateVector(out) + port_dout + ",\n";
	ret += tabs + "output " + port_valid + ",\n";
	ret += tabs + "input " + port_ready + ",\n";
	ret += "\n";

	return ret;
}


MemoryContentComponent::MemoryContentComponent(Component& c){
	name = c.name;
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
	connections = c.connections;
	inputConnections = c.inputConnections;
	outputConnections = c.outputConnections;

	//MC_ is removed from the name to specify that it is Top Module IO port connection
	port_address_0 = substring(name, name.find('_') + 1, name.size()) + "_" + "address_0";
	port_ce_0 = substring(name, name.find('_') + 1, name.size()) + "_" + "ce_0";
	port_we_0 = substring(name, name.find('_') + 1, name.size()) + "_" + "we_0";
	port_din_0 = substring(name, name.find('_') + 1, name.size()) + "_" + "din_0";
	port_dout_0 = substring(name, name.find('_') + 1, name.size()) + "_" + "dout_0";

	port_address_1 = substring(name, name.find('_') + 1, name.size()) + "_" + "address_1";
	port_ce_1 = substring(name, name.find('_') + 1, name.size()) + "_" + "ce_1";
	port_we_1 = substring(name, name.find('_') + 1, name.size()) + "_" + "we_1";
	port_din_1 = substring(name, name.find('_') + 1, name.size()) + "_" + "din_1";
	port_dout_1 = substring(name, name.find('_') + 1, name.size()) + "_" + "dout_1";

}

//Returns the input/output declarations for top-module
std::string MemoryContentComponent::getModuleIODeclaration(std::string tabs){
	std::string ret = "";
	//Since getVectorLength function only counts from : till it reads numbers,
	//In this case it works
	//**However finding this is weakly implemented as of now
	ret += tabs + "output " + getAddressPortVector(out) + port_address_0 + ",\n";
	ret += tabs + "output " + port_ce_0 + ",\n";
	ret += tabs + "output " + port_we_0 + ",\n";
	ret += tabs + "output " + getDataPortVector(out) + port_dout_0 + ",\n";
	ret += tabs + "input " + getDataPortVector(in) + port_din_0 + ",\n";

	//Since getVectorLength function only counts from : till it reads numbers,
	//In this case it will works as out2 will never be reached
	//**However finding this is weakly implemented as of now
	ret += tabs + "output " + getAddressPortVector(out) + port_address_1 + ",\n";
	ret += tabs + "output " + port_ce_1 + ",\n";
	ret += tabs + "output " + port_we_1 + ",\n";
	ret += tabs + "output " + getDataPortVector(out) + port_dout_1 + ",\n";
	ret += tabs + "input " + getDataPortVector(in) + port_din_1 + ",\n";
	ret += "\n";

	return ret;
}



