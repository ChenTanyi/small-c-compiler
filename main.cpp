/*
 * This file contains the main function
 * to do compiling
 */

#include "header.h"
#include "tree.h"
#include "y.tab.h"

using namespace std;

int yylex();
extern char* yytext;
extern int yylineno;
extern Node* root;

int main(int argc, char** argv){
	if (argc == 1){
		cerr << "Please write your code in the shell. Input <CTRL-D> to exit.\n";
		cerr << "Or you can specify the source code path. \nExample --> $./scc InputFile OutputFile\n";
	} 
	if (argc >= 2){
		auto fin = freopen(argv[1], "r", stdin);
		if (!fin){
			cerr << "Error: Input file " << argv[1] << " does not exist!\n";
			return 1;
		}
		cerr << "InputFile --> " << argv[1] << "\n";
		cerr << "--------------------------------------------------------------\n";
	} 
	if (argc > 2){
		freopen(argv[2], "w", stdout);
	}

	auto start = chrono::high_resolution_clock::now();

    if (!yyparse()){
    	cerr << "Parse Complete!\n";
    	root->init();
    	root->codeGen();
    	root->translate();
    	cerr << "Translation Complete!\n";
    	if (argc > 3)
    		root->codePrint(argv[3]);
    	else 
    		root->codePrint();
    	if (argc > 4){
    		ofstream fout(argv[4]);
    		root->dfs(0, fout);
    		fout.close();
    	}
    } else {
    	cerr << "Parsing Error!\n";
    	cout << "Error.\n";
    	exit(1);
    }

    auto end = chrono::high_resolution_clock::now();
    auto diff = end - start;
    cerr << "Compiling Time: " << chrono::duration_cast<chrono::microseconds>(diff).count() / 1000.0 << "ms!\n\n\n";


    return 0;
}