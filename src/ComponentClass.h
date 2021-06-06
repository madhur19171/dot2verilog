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
	std::string moduleName;
	std::string instanceName;
	std::string name;
	std::string type;
	int bbID;
	std::string in;
	std::string out;//Becomes obsolete after inputConnections and outputConnection are initialized
	float delay, latency;
	int II;
	int slots;
	bool transparent;
	std::string op;
	uint64_t value;

	/**Confirm this assumption*/
	//Assuming that two different blocks have only one unique connection between them
	//Then connection is vector containing all the connections that component has with other components
	//The vector contains pairs. The first element of that pair is the name of the component that is connected to this component
	//The second element of the pair is the input-output mapping of this component and the connected component
	std::vector<std::pair<Component*, std::pair<std::string, std::string>>> io;

	//Every entity of top module has clk and rst signal for synchronization
	std::string clk, rst;
	//Stores the module port input and output connections, using which
	//modules are connected to outside world
	std::string inputPortBus;
	std::map<std::string, InputConnection> inputConnections;
	std::string outputPortBus;
	std::map<std::string, OutputConnection> outputConnections;



	Component();
	void printComponent();
	int getVectorLength(std::string str);
	std::string generateVector(std::string str);
	std::string generateVector(int from, int to);
	Component* castToSubClass(Component* component);
	//Creates the port connections for individual modules like fork, join, merge...
	std::string getModulePortDeclarations(std::string tabs);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);


protected:
	std::string getDataPortVector(std::string _str);
	std::string getAddressPortVector(std::string _str);


	//Fills the inputConnections and outputConnections vectors with input and output ports
	void setInputPortBus();//Connects Component Wires with component module inputs. This is called inside getModuleInstantiation
	void setInputConnections();
	void setOutputPortBus();//Connects Component Wires with component module outputs. This is called inside getModuleInstantiation
	void setOutputConnections();

	//This will create verilog code connecting outConn to inConn
	std::string connectInputOutput(InputConnection inConn, OutputConnection outConn);


	//Finds the name of io port based on input.
	//Eg. input->in2-:32; output->in2
	std::string getIOName(std::string _str);
	//Finds the number of io port based on input.
	//Eg. input->out3?:32; output->3
	int getIONumber(std::string _str);

	std::string getVerilogParameters();
private:
};

////Structure that will store the connection information of a component
////Right now it has only one element, but it may be extended as and when needed
//struct connection{
//
//};



//Type Component Classes (To be moved to their respective class files)
class StartComponent : public Component{
public:
	std::string port_din;
	std::string port_valid;
	std::string port_ready;

	StartComponent(Component& c);
	std::string getModuleIODeclaration(std::string tabs);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);

	//Returns a string containing verilog code for connecting all the outputs of this components to the inputs
	//Of the components it is connected to
	std::string getInputOutputConnections();

private:
	std::string getVerilogParameters();
};

class EndComponent : public Component{
public:
	std::string port_dout;
	std::string port_valid;
	std::string port_ready;

	EndComponent(Component& c);
	std::string getModuleIODeclaration(std::string tabs);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);

	//Returns a string containing verilog code for connecting all the outputs of this components to the inputs
	//Of the components it is connected to
	std::string getInputOutputConnections();

private:
	std::string getVerilogParameters();
};


//Type Component Classes (To be moved to their respective class files)
class SinkComponent : public Component{
public:
	SinkComponent(Component& c);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);

	//Since this has no outputs hence no getInputOutputConnections() function for this Class
	//However, to maintain uniformity of code, we will connect the clk and rst in this sink
	//,although they are of no use.
	std::string getInputOutputConnections();

private:
	//Overriding setOutputPortBus functions as
	//Sink only has input port and no output ports.
	void setOutputPortBus();
	std::string getVerilogParameters();
};


//Type Component Classes (To be moved to their respective class files)
class AddComponent : public Component{
public:
	AddComponent(Component& c);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);

	//Returns a string containing verilog code for connecting all the outputs of this components to the inputs
	//Of the components it is connected to
	std::string getInputOutputConnections();

private:
	std::string getVerilogParameters();
};


//Type Component Classes (To be moved to their respective class files)
class RetComponent : public Component{
public:
	RetComponent(Component& c);
	//Instantiates the Component and generates a verilog code to instantiate this component
	std::string getModuleInstantiation(std::string tabs);

	//Returns a string containing verilog code for connecting all the outputs of this components to the inputs
	//Of the components it is connected to
	std::string getInputOutputConnections();

private:
	std::string getVerilogParameters();
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
