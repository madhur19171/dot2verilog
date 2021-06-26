
/*
 *  C++ Implementation: dot2Vhdl
 *
 * Description:
 *
 *
 * Author: Andrea Guerrieri <andrea.guerrieri@epfl.ch (C) 2019
 *
 * Copyright: See COPYING file that comes with this distribution
 *
 */
#include "dot2hdl.h"

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "stdlib.h"
#include <string.h>
#include "dot_parser.h"
#include "GraphToVerilog.h"


using namespace std;


int debug_mode = FALSE;
int report_area_mode = FALSE;


string input_filename[MAX_INPUT_FILES];
string output_filename[MAX_INPUT_FILES];
string top_level_filename;
int dot_input_files = 0;

void arguments_parser ( int argc, char *argv[] )
{		
	switch ( argc )
	{
	case 3:
		if ( ! ( strcmp(argv[2] , "-debug") ) )
		{
			printf ( "Debug Mode Activated\n\r" );
			debug_mode = TRUE;
		}
		if ( ! ( strcmp(argv[2] , "-report_area") ) )
		{
			printf ( "Report Area Activated\n\r" );
			report_area_mode = TRUE;
		}
		break;
	case 2:
		if ( ! ( strcmp(argv[1] , "--version") ) )
		{
			printf ("Dot2Vhdl version %s \n\r", VERSION_STRING );\
			exit(1);

		}
		else
			if ( ! ( strcmp(argv[1] , "--help") ) )
			{
				printf ("Dot2Vhdl version %s \n\r", VERSION_STRING );
				printf ( "Usage: %s filename -debug [opt]\n\r\n\r\n\r", argv[0]);
				exit(1);

			}
			else
				if ( ! ( strcmp(argv[1] , "about") ) )
				{
					printf("***************************************************** \n\r");
					printf("Author: Andrea Guerrieri Email: andrea.guerrieri@epfl.ch\n\r");
					printf("***************************************************** \n\r");
					exit(1);

				}
		break;
	default:
		printf( "Invalid arguments \n\rTry %s --help for more informations\n\r\n\r\n\r", argv[0] );
		exit ( 0 );
		break;
	}

	return;
}




int main( int argc, char* argv[] )
{

	cout << INIT_STRING;

	arguments_parser ( argc, argv );

	dot_input_files = (argc-1);

	top_level_filename = argv[1];

	for ( int indx = 0; indx < dot_input_files; indx++ )
	{

		input_filename[indx] = argv[indx+1];
		output_filename[indx] = argv[indx+1];

		cout << "Parsing "<< input_filename[indx] << ".dot" << endl;

//		filename = string(input_filename[indx]);

		parse_dot ( input_filename[indx] );

		cout << "dot Parsed" << endl;

		string filen = string(input_filename[indx]);
		DotReader dotReader(filen);
		dotReader.lineReader();
		cout << "dot Read" << endl;


		GraphToVerilog g2v(dotReader);


		g2v.writeToFile();

		Graph graph(dotReader);
		graph.startDFS();

	}

//	for(int i = 0; i < components_in_netlist;i++){
//		cout << "Index Number: " << i << endl;
//		printNode(nodes[i]);
//		cout << "\n" << endl;
//	}


	cout << endl;
	cout << "Done" ;

	cout << endl<< endl<< endl;
	return 0;

} 




