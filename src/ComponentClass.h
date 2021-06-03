/*
 * ComponentClass.h
 *
 *  Created on: 01-Jun-2021
 *      Author: madhur
 */

#ifndef COMPONENTCLASS_H_
#define COMPONENTCLASS_H_

#pragma once

#include "entity_names.h"

//Structure that will store the connection information of a component
//Right now it has only one element, but it may be extended as and when needed
struct connection{
	//Assuming that two different blocks have only one unique connection between them
	//Then connection is vector containing all the connections that component has with other components
	//The vector contains pairs. The first element of that pair is the name of the component that is connected to this component
	//The second element of the pair is the input-output mapping of this component and the connected component
	std::vector<std::pair<std::string, std::pair<std::string, std::string>>> io;
};

//Input/Output Connections have the name as follows:
//<name>_data
//<name>_valid
//<name>_ready
struct InputConnection{
	int vectorLength;
	std::string data;
	std::string valid;
	std::string ready;
};

struct OutputConnection{
	int vectorLength;
	std::string data;
	std::string valid;
	std::string ready;
};


//Stores all the information about a component
//If the component does not support any parameter,
//it is assigned the default value
class Component{
public:
	std::string name;
	std::string type;
	int bbID;
	std::string in, out;//Becomes obsolete after inputConnections and outputConnection are initialized
	float delay, latency;
	int II;
	int slots;
	bool transparent;
	std::string op;
	uint64_t value;
	connection connections;

	//Every entity of top module has clk and rst signal for synchronization
	std::string clk, rst;
	//Stores the module port input and output connections, using which
	//modules are connected to outside world
	std::string inputPortBus;
	std::map<std::string, InputConnection> inputConnections;
	std::string outputPortBus;
	std::map<std:: string, OutputConnection> outputConnections;



	Component();
	void printComponent();
	int getVectorLength(std::string str);
	std::string generateVector(std::string str);
	std::string generateVector(int from, int to);
	Component castToSubClass();
	//Creates the port connections for individual modules like fork, join, merge...
	std::string getModulePortDeclarations(std::string tabs);

protected:
	std::string getDataPortVector(std::string _str);
	std::string getAddressPortVector(std::string _str);
	//Fills the inputConnections and outputConnections vectors with input and output ports
	void setInputPortBus();
	void setInputConnections();
	void setOutputPortBus();
	void setOutputConnections();
	//Finds the name of io port based on input.
	//Eg. input->in2-:32; output->in2
	std::string getIOName(std::string _str);
	//Finds the number of io port based on input.
	//Eg. input->out3?:32; output->3
	int getIONumber(std::string _str);
private:
};


//Type Component Classes (To be moved to their respective class files)
class StartComponent : public Component{
public:
	std::string port_din;
	std::string port_valid;
	std::string port_ready;

	StartComponent(Component& c);
	std::string getModuleIODeclaration(std::string tabs);

private:
};

class EndComponent : public Component{
public:
	std::string port_dout;
	std::string port_valid;
	std::string port_ready;

	EndComponent(Component& c);
	std::string getModuleIODeclaration(std::string tabs);

private:
};

//This interfaces with a BRAM
//The Configuration is supposedly Dual Port BRAM.
//One port is used for Loading the data(Read):->Port 1
//Other port is used for solely storing the data(Write):->Port 0
//Every Port has: address, ce, we, dout, din
//in1 gives the address port length
//out1 gives the data port length
//out2 is connected to end
class MemoryContentComponent : public Component{
public:
	std::string port_address_0;
	std::string port_ce_0;
	std::string port_we_0;
	std::string port_dout_0;
	std::string port_din_0;

	std::string port_address_1;
	std::string port_ce_1;
	std::string port_we_1;
	std::string port_dout_1;
	std::string port_din_1;

	MemoryContentComponent(Component& c);
	std::string getModuleIODeclaration(std::string tabs);

private:
	//	std::string getAddressPortVector();
	//	std::string getDataPortVector();
};



#endif /* COMPONENTCLASS_H_ */
