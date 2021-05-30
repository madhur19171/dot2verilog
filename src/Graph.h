/*
 * Graph.h
 *
 *  Created on: 30-May-2021
 *      Author: madhur
 */

#ifndef GRAPH_H_
#define GRAPH_H_

#pragma once

#include "dot_reader.h"

class Graph {
public:
//	Graph();
	Graph(DotReader dotReader);
	void startDFS();
	component findRoot();
	void initializeDFS();

private:
	DotReader dotReader;
	int maxDFSDepth = 500, currentDFSDepth = 0;
	std::map<std::string, bool> visited;

	void DFS(struct component *v);
};

#endif /* GRAPH_H_ */
