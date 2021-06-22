/*
 * dot_reader1.cpp
 *
 *  Created on: 11-Jun-2021
 *      Author: madhur
 */

#include "dot_reader1.h"
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

	//Function calls to generate a Component Graph

	generateComponentList();
	generateConnectionMap();

	return 0;
}


//Puts the ComponentConnection data into the component connection io element in the structure
//The globalCompoentConnections, intraBlockConnection, interBlockConnection are read to get the
//component connection informations and using that info, it is determined which component is connected to which other component
void DotReader::generateConnectionMap(){
	for(auto it = componentList.begin(); it != componentList.end(); it++){
		//		std::vector<std::pair<Component*, std::pair<int, int>>> io;

		//out_index
		for(int i = 0; i < (*it)->out.size; i++){

			std::pair<int, int> pair;
			std::pair<Component*,  std::pair<int, int>> connection;

			int out_ind = i, in_ind;

			int next_node_id = (*it)->out.output[i].next_nodes_id;

			if(next_node_id != COMPONENT_NOT_FOUND){
				Component* nextComponent = componentMap[nodes[next_node_id].name];
				connection.first = nextComponent;

				//in_index
				for(int j = 0; j < nextComponent->in.size; j++){
					int prev_node_id = nextComponent->in.input[j].prev_nodes_id;
					if(prev_node_id == (*it)->index){
						in_ind = j;
						break;
					}
				}
				pair.first = out_ind;
				pair.second = in_ind;
				connection.second = pair;
				componentMap[(*it)->name]->io.push_back(connection);
			}
		}

		//Special Case for StoreComponent since it sends two outputs to same MC
		if((*it)->op == OPERATOR_WRITE_MEMORY){
			int sec_data = 0, sec_addr = 0;
			int next_node_id = (*it)->out.output[0].next_nodes_id;
			Component* nextComponent = componentMap[nodes[next_node_id].name];
			for(int j = 0; j < nextComponent->in.size; j++){
				int prev_node_id = nextComponent->in.input[j].prev_nodes_id;
				if(prev_node_id == (*it)->index && nextComponent->in.input[j].info_type == "d"){
					sec_data = j;
					break;
				}
			}
			(*it)->io[0].second.second = sec_data;

			for(int j = 0; j < nextComponent->in.size; j++){
				int prev_node_id = nextComponent->in.input[j].prev_nodes_id;
				if(prev_node_id == (*it)->index && nextComponent->in.input[j].info_type == "a"){
					sec_addr = j;
					break;
				}
			}
			(*it)->io[1].second.second = sec_addr;
		}
	}


}

//This function reads the conponentDeclaration list and initializes the various elements of component structure
//based on the information present in the componentDeclaration lines
//Then pushes the components into componentList and componentMap indexed by their names
void DotReader::generateComponentList(){
	for(int i = 0; i < components_in_netlist; i++){
		Component* comp = new Component();
		comp->index = i;
		comp->name = nodes[i].name;
		comp->type = nodes[i].type;
		comp->bbID = nodes[i].bbId;
		comp->in = nodes[i].inputs;
		comp->out = nodes[i].outputs;
		comp->slots = nodes[i].slots;
		comp->transparent = nodes[i].trasparent;
		comp->op = nodes[i].component_operator;
		comp->value = nodes[i].component_value;

		comp = comp->castToSubClass(comp);
		componentList.push_back(comp);
		componentMap[comp->name] = comp;
	}
}





































