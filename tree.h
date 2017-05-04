/*
 * This file is used to declare the 
 * basic syntax tree node class
 */

#ifndef tree_H
#define tree_H

#include "header.h"

#define err(x) \
std::cerr << "Error: Semantic error at line " << line \
	<< "\nExpected rules: " << content << "\n" << (x) \
	<< "\nExit\n"; \
std::cout << "Error.\n"

#define CHECK_RTN(y) \
if (rtn != 0) { err(y); exit(1);}


struct IdInfo{
	std::string type;
	int address;
	std::vector<std::pair<int, int>> paras;
};

class Node{
protected:
	static bool insideFunction;
	static int insideStmtBlocks;
	static int insideLoop;
	static std::vector<std::string> funcParas;
	static std::string funcName;
	static std::string callFunName;

	static std::string structType;
	static bool structDef;
	static std::vector<std::string> structFields;
	static int noNameStructCount;

	static std::map<std::string, std::vector<std::string>> initBeforeRun;
	static std::vector<std::string> curInit;
	static bool initGen;

	static std::string IR;
	static std::vector<std::string> IRCode;
	static std::vector<std::vector<std::string>> IRCodeRefine;
	static std::vector<std::string> MipsCode;

	static int forLoopNum;
	static std::string forLoopNext;
	static std::string forLoopEnd;
	static int ifElseNum;
public:

public:
    void dfs(int level, std::ostream& os) const;
    void codePrint(const std::string& IRFile = "");
    void init();
    virtual void codeGen();
    virtual int count();
    bool leftValue(Node* t);
    void translate();

    std::set<std::string> availReg;
    std::vector<std::string> resReg;
    static std::map<int, std::set<int>> affact;
    std::string getReg(int i, const std::string& s, const std::string& a = "");
    void freeReg(int i, const std::string& s, const std::string& reg);

public:
	int totalVar;
	int getTotalVar() const;
	void getTotalVarInFunc(int& total);

public:
	std::map<std::string, IdInfo> symbolTable;
	int saveIdtoTable(const std::string& id, const std::string& type, int& address, ...);
	void getCurId(const std::string& id);

	static std::pair<std::string, IdInfo> curId;
	static int argsCount;
	static int totalArgs;
	static int arrsCount;

	static std::map<std::string, int> funcTable;
	static std::map<std::string, int> funcCall;
	static std::map<std::string, int> funcVar;
	int saveIdtoFuncTable(const std::string& id, const int paraNum);

	Node* getDefineClass(Node* p);
	const Node* getDefineClass(const Node* p) const;

public:
	std::map<std::string, std::pair<bool, std::vector<std::string>>> structTable;
	int saveTypeToStructTable(const std::string& type, bool isDefined);
	std::pair<bool, std::vector<std::string>> getStructTableWithType(const std::string& type);

public:
    int line;
    std::string className;
    std::string content;
    Node* parent;
    std::vector<Node*> children;
    friend Node* createNode(int line, const std::string& type, const std::string& content, int childrenSize, ...);
};

Node* createNode(int line, const std::string& type, const std::string& content, int childrenSize, ...);

Node* getNode(const std::string& className);

#endif