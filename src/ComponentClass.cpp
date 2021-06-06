/*
 * ComponentClass.cpp
 *
 *  Created on: 31-May-2021
 *      Author: madhur
 */

#include "ComponentClass.h"

//Default constructor to set every data item a default value
Component::Component(){
	moduleName = DEFAULT_MODULE_NAME;
	instanceName = DEFAULT_INSTANCE_NAME;
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
			<< "value: " << value << "\t"
			<< "IO Size: " << io.size() << std::endl;
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
Component* Component::castToSubClass(Component* component){
	if(type == COMPONENT_START){
		StartComponent* obj = new StartComponent(*this);
		component = (Component *)obj;
		return component;
	} else if(type == COMPONENT_END){
		EndComponent* obj = new EndComponent(*this);
		component = (Component *)obj;
		return component;
	} else if(type == COMPONENT_OPERATOR){
		if(op == OPERATOR_ADD){
			AddComponent* obj = new AddComponent(*this);
			component = (Component *)obj;
			return component;
		} else if(op == OPERATOR_RET){
			RetComponent* obj = new RetComponent(*this);
			component = (Component *)obj;
			return component;
		}
	}else if(type == COMPONENT_MC){
		MemoryContentComponent* obj = new MemoryContentComponent(*this);
		component = (Component *)obj;
		return component;
	} else if(type == COMPONENT_SINK){
		SinkComponent* obj = new SinkComponent(*this);
		component = (Component *)obj;
		return component;
	}

	return this;
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
		//Iterate over the inputConnections and add a wire for each connection
		for(auto it = inputConnections.begin(); it != inputConnections.end(); it++){
			ret += tabs + "wire " + generateVector((*it).second.vectorLength - 1, 0) + (*it).second.data + ";\n";
			ret += tabs + "wire " + (*it).second.ready + ";\n";
			ret += tabs + "wire " + (*it).second.valid + ";\n";
		}
	}
	//If this entity has any outputs:
	if(out != DEFAULT_OUT){
		//set outputConnections and fill it with all the available outputs
		setOutputConnections();
		//Iterate over the inputConnections and add a wire for each connection
		for(auto it = outputConnections.begin(); it != outputConnections.end(); it++){
			ret += tabs + "wire " + generateVector((*it).second.vectorLength - 1, 0) + (*it).second.data + ";\n";
			ret += tabs + "wire " + (*it).second.ready + ";\n";
			ret += tabs + "wire " + (*it).second.valid + ";\n";
		}
	}

	return ret;
}



void Component::setInputPortBus(){
	InputConnection inConn;

	//First create data_in bus
	inputPortBus = ".data_in_bus({";
	//The bus will be assigned from highest input to lowest input. eg {in3, in2, in1}
	for(int i = inputConnections.size(); i > 0; i--){
		inConn = inputConnections["in" + std::to_string(i)];
		inputPortBus += inConn.data + ", ";
	}
	inputPortBus = inputPortBus.erase(inputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	inputPortBus += "}), ";

	//Now create valid_in bus
	inputPortBus += ".valid_in_bus({";
	//The bus will be assigned from highest input to lowest input. eg {in3, in2, in1}
	for(int i = inputConnections.size(); i > 0; i--){
		inConn = inputConnections["in" + std::to_string(i)];
		inputPortBus += inConn.valid + ", ";
	}
	inputPortBus = inputPortBus.erase(inputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	inputPortBus += "}), ";

	//Now create ready_in bus
	inputPortBus += ".ready_in_bus({";
	//The bus will be assigned from highest input to lowest input. eg {in3, in2, in1}
	for(int i = inputConnections.size(); i > 0; i--){
		inConn = inputConnections["in" + std::to_string(i)];
		inputPortBus += inConn.ready + ", ";
	}
	inputPortBus = inputPortBus.erase(inputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	inputPortBus += "})";
}

void Component::setOutputPortBus(){
	OutputConnection outConn;

	//First create data_in bus
	outputPortBus = ".data_out_bus({";
	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
	for(int i = outputConnections.size(); i > 0; i--){
		outConn = outputConnections["out" + std::to_string(i)];
		outputPortBus += outConn.data + ", ";
	}
	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	outputPortBus += "}), ";

	//Now create valid_in bus
	outputPortBus += ".valid_out_bus({";
	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
	for(int i = outputConnections.size(); i > 0; i--){
		outConn = outputConnections["out" + std::to_string(i)];
		outputPortBus += outConn.valid + ", ";
	}
	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	outputPortBus += "}), ";

	//Now create ready_in bus
	outputPortBus += ".ready_out_bus({";
	//The bus will be assigned from highest output to lowest output. eg {out3, out2, out1}
	for(int i = outputConnections.size(); i > 0; i--){
		outConn = outputConnections["out" + std::to_string(i)];
		outputPortBus += outConn.ready + ", ";
	}
	outputPortBus = outputPortBus.erase(outputPortBus.size() - 2, 2);//This is needed to remove extra comma and space after bus is populated
	outputPortBus += "})";
}



//These two functions will be defined individually for each component subclass
std::string Component::getModuleInstantiation(std::string tabs){
	return "";
}

std::string Component::getVerilogParameters(){
	return "";
}


std::string Component::connectInputOutput(InputConnection inConn, OutputConnection outConn){
	std::string ret;

	ret += "\tassign " + inConn.data + " = " + outConn.data + ";\n";
	ret += "\tassign " + inConn.valid + " = " + outConn.valid + ";\n";
	ret += "\tassign " + outConn.ready + " = " + inConn.ready + ";\n";

	return ret;
}














