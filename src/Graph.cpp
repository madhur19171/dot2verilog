/*
 * Graph.cpp
 *
 *  Created on: 30-May-2021
 *      Author: madhur
 */

#include "Graph.h"

Graph::Graph(DotReader dotReader) {
	// TODO Auto-generated constructor stub
	this->dotReader = dotReader;
}


void Graph::startDFS(){

	initializeDFS();//populates the visited map, otherwise it throws error

	//Starts DFS from the "start_0" component
	Component root = findRoot();
	DFS(&root);

	std::map<std::string, bool>::iterator it;
	for(it = visited.begin(); it != visited.end(); it++){
		Component comp = dotReader.getComponentMap().at(it->first);
		if(comp.in == DEFAULT_IN && !visited[comp.name]){
			root = comp;
			DFS(&root);
		}
	}
}


void Graph::DFS(Component *v){
	//CurrentDFSDepth keeps track of current DFS Level. For debugging purposes only
	if(currentDFSDepth++ < maxDFSDepth){
		visited[v->name] = true;
		std::cout << v->name << " -> ";

		std::vector<std::pair<std::string, std::pair<std::string, std::string>>>::iterator it;

		Component nextComponent;
		if(v->connections.io.size() != 0){
			for(it = v->connections.io.begin(); it != v->connections.io.end(); it++){
				std::string name = (*it).first;
				nextComponent = (dotReader.getComponentMap().at(name));
				if(!visited[name]){
					DFS(&nextComponent);
					currentDFSDepth--;
				}else{
					std::cout << std::endl;
				}
			}
		}else{
			std::cout << std::endl;
		}
	} else
		return;
}

//The graph starts with the component named "start_0"
Component Graph::findRoot(){
	return dotReader.getComponentMap().at("start_0");
}

//Initialize visited map.
void Graph::initializeDFS(){
	std::vector<Component>::const_iterator it;
	for(it = dotReader.getComponentList().begin(); it != dotReader.getComponentList().end(); it++){
		visited.insert({(*it).name, false});
	}
	std::cout << "DFS Starts: " << std::endl;
}



























