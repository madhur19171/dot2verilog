/*
 * MemoryComponent.cpp
 *
 *  Created on: 04-Jun-2021
 *      Author: madhur
 */

#include "ComponentClass.h"

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


