/*
 * entity_names.h
 *
 *  Created on: 28-May-2021
 *      Author: madhur
 */
#pragma once

//#define _GLIBCXX_USE_CXX11_ABI 0
#include <string>
#include "string_utility.h"
#include <cstdint>
#include <iostream>
#include <vector>
#include <utility>
#include <map>
#include <sstream>

#ifndef ENTITY_NAMES_H_
#define ENTITY_NAMES_H_

#define COMPONENT_GENERIC   0
#define COMPONENT_CONSTANT  1

#define CLK "clk"
#define RST "rst"
#define DATAIN_ARRAY "dataInArray"
#define DATAOUT_ARRAY "dataOutArray"
#define PVALID_ARRAY "pValidArray"
#define NREADY_ARRAY "nReadyArray"
#define READY_ARRAY "readyArray"
#define VALID_ARRAY "validArray"


#define ENTITY_MERGE            "merge"
#define ENTITY_READ_MEMORY      "read_memory_single"
#define ENTITY_WRITE_MEMORY     "write_memory_single"
#define ENTITY_SINGLE_OP        "SingleOp"
#define ENTITY_GET_PTR          "getptr"
#define ENTITY_INT_MUL          "intMul"
#define ENTITY_INT_ADD          "intAdd"
#define ENTITY_INT_SUB          "intSub"
#define ENTITY_BUF              "elasticBuffer"
#define ENTITY_TEHB             "TEHB"
#define ENTITY_OEHB             "OEHB"
#define ENTITY_FIFO             "elasticFifo"
#define ENTITY_NFIFO            "nontranspFifo"
#define ENTITY_TFIFO            "transpFifo"
#define ENTITY_FORK             "fork"
#define ENTITY_ICMP             "intCmp"
#define ENTITY_CONSTANT         "Const"
#define ENTITY_BRANCH           "Branch"
#define ENTITY_END              "end_node"
#define ENTITY_START            "start_node"
#define ENTITY_SOURCE           "source"
#define ENTITY_SINK             "sink"
#define ENTITY_MUX              "Mux"
#define ENTITY_CTRLMERGE        "CntrlMerge"
#define ENTITY_LSQ              "LSQ"
#define ENTITY_MC               "MemCont"
#define ENTITY_SEL				"SEL"
#define ENTITY_DISTRIBUTOR      "Distributor"
#define ENTITY_SELECTOR			"Selector"

#define COMPONENT_MERGE         "Merge"
#define COMPONENT_READ_MEMORY   "load"
#define COMPONENT_WRITE_MEMORY  "store"
#define COMPONENT_SINGLE_OP     "Merge"
#define COMPONENT_GET_PTR       "Merge"
#define COMPONENT_INT_MUL       "mul"
#define COMPONENT_INT_ADD       "add"
#define COMPONENT_INT_SUB       "sub"
#define COMPONENT_BUF           "Buffer"
#define COMPONENT_TEHB          "TEHB"
#define COMPONENT_OEHB          "OEHB"
#define COMPONENT_FIFO          "Fifo"
#define COMPONENT_NFIFO         "nFifo"
#define COMPONENT_TFIFO         "tFifo"
#define COMPONENT_FORK          "Fork"
#define COMPONENT_ICMP          "icmp"
#define COMPONENT_CONSTANT_     "Constant"
#define COMPONENT_BRANCH        "Branch"
#define COMPONENT_END           "Exit"
#define COMPONENT_START         "Entry"
#define COMPONENT_SOURCE        "Source"
#define COMPONENT_SINK          "Sink"
#define COMPONENT_MUX           "Mux"
#define COMPONENT_CTRLMERGE     "CntrlMerge"
#define COMPONENT_LSQ           "LSQ"
#define COMPONENT_MC            "MC"
#define COMPONENT_SEL			"SEL"
#define COMPONENT_DISTRIBUTOR   "Distributor"
#define COMPONENT_SELECTOR		"Selector"
#define COMPONENT_OPERATOR		"Operator"

#define OPERATOR_ADD			"add_op"
#define OPERATOR_RET			"ret_op"

#define UNDERSCORE  "_"
#define COLON ":"
#define SEMICOLON ";"
#define COMMA   ","
#define TAB "\t"
#define BACK "\b"

#define DEFAULT_MODULE_NAME "nomodulename"
#define DEFAULT_INSTANCE_NAME "noinstancename"
#define DEFAULT_NAME "noname"
#define DEFAULT_TYPE "notype"
#define DEFAULT_BBID -1
#define DEFAULT_IN "noin"
#define DEFAULT_OUT "noout"
#define DEFAULT_DELAY 0.0f
#define DEFAULT_LATENCY 0.0f
#define DEFAULT_II 1
#define DEFAULT_SLOTS -1
#define DEFAULT_TRANSPARENT false
#define DEFAULT_OP "nop"
#define DEFAULT_VALUE 0



#define SIGNAL_STRING  "signal "
#define STD_LOGIC      "std_logic;"





#endif
