/*
 * This file is used to implement all the function
 * in the basic tree node class
 */
#include "tree.h"

using namespace std;

bool Node::insideFunction;
int Node::insideStmtBlocks;
int Node::insideLoop;
vector<string> Node::funcParas;
string Node::funcName;
string Node::callFunName;
string Node::structType;
bool Node::structDef;
vector<string> Node::structFields;
int Node::noNameStructCount;
std::pair<std::string, IdInfo> Node::curId;
int Node::argsCount;
int Node::totalArgs;
int Node::arrsCount;
std::map<std::string, std::vector<std::string>> Node::initBeforeRun;
std::vector<std::string> Node::curInit;
bool Node::initGen;
std::string Node::IR;
std::vector<std::string> Node::IRCode;
std::vector<std::vector<std::string>> Node::IRCodeRefine;
std::vector<std::string> Node::MipsCode;

int Node::forLoopNum;
std::string Node::forLoopNext;
std::string Node::forLoopEnd;
int Node::ifElseNum;

map<string, int> Node::funcTable;
map<string, int> Node::funcCall;
map<string, int> Node::funcVar;

std::map<int, set<int>> Node::affact;

Node* createNode(int line, const std::string& type, const std::string& content, int childrenSize, ...){
	Node* p = getNode(type);
	p->line = line;
	p->className = type;
	p->content = content;
	va_list childrenList;
    va_start(childrenList, childrenSize);
    for (int i = 0; i < childrenSize; ++i){
    	p->children.push_back(va_arg(childrenList, Node*));
    	p->children.back()->parent = p;
    }
    va_end(childrenList);
    return p;
}

void Node::init(){
	insideFunction = false;
	insideStmtBlocks = 0;
	insideLoop = 0;
	funcParas.clear();
	initGen = false;
	totalVar = 0;
	structDef = false;
	noNameStructCount = 0;
	forLoopNum = 0;
	ifElseNum = 0;
	structType.clear();
	IRCode.clear();
	curInit.clear();
	initBeforeRun.clear();
	funcTable.clear();
	funcCall.clear();
	funcVar.clear();
}

void Node::codePrint(const string& IRFile){
	if (IRFile != ""){
		ofstream IRout(IRFile);
		for (const auto& v : IRCodeRefine){
			for (const auto& s : v){
				IRout << s << "\t";
			}
			IRout << endl;
		}
		IRout.close();
	}
	for (const auto& s : MipsCode){
		cout << s << endl;
	}
}

void Node::codeGen(){
	for (auto c : children){
		c->codeGen();
	}
}

int Node::count(){
	err("can't not call count function with type " + className);
	exit(1);
	return 1;
}

void Node::dfs(int level, std::ostream& os) const {
	for (int i = 0; i < level; ++i)
		os << "\t";
	os << line << " " << content << "\n";
	for (auto& child : children)
		child->dfs(level + 1, os);
}

int Node::getTotalVar() const{
	const Node* p = getDefineClass(this->parent);
	return p->totalVar;
}

void Node::getTotalVarInFunc(int& total){
	total = max(total, totalVar);
	for (auto& c : children){
		c->getTotalVarInFunc(total);
	}
}

int Node::saveTypeToStructTable(const std::string& type, bool isDefined){
	Node* p = getDefineClass(this);
	auto& s = p->structTable;
	auto it = s.find(type);
	if (it != s.end() && isDefined && it->second.first){
		err("redefine struct type " + type);
		exit(1);
	}
	if (it == s.end() || isDefined){
		s[type] = {isDefined, structFields};
	}
	return 0;
}

pair<bool, vector<string>> Node::getStructTableWithType(const std::string& type){
	Node* p = getDefineClass(this);
	while (1){
		auto& s = p->structTable;
		auto it = s.find(type);
		if (it != s.end())
			return it->second;
		if (p->className == "PROGRAM")
			break;
		p = getDefineClass(p->parent);
	}
	err("can't get the struct type " + type);
	exit(1);
}

Node* Node::getDefineClass(Node* p){
	while (p->className != "PROGRAM" && p->className != "STMTBLOCK"){
		p = p->parent;
	}
	return p;
}

const Node* Node::getDefineClass(const Node* p) const{
	while (p->className != "PROGRAM" && p->className != "STMTBLOCK"){
		p = p->parent;
	}
	return p;
}

int Node::saveIdtoFuncTable(const std::string& id, const int paraNum){
	if (funcTable.count(id)){
		err("redefine function name " + id);
		exit(1);
	}
	funcTable[id] = paraNum;
	return 0;
}

int Node::saveIdtoTable(const std::string& id, const std::string& type, int& address, ...){
	Node* p = getDefineClass(this);
	auto& s = p->symbolTable;
	auto& tot = p->totalVar;
	auto it = s.find(id);
	if (it != s.end()){
		err("redeclare id " + id);
		exit(1);
	}
	IdInfo x;
	address = tot;
	if (type == "int"){
		tot += 4;
	} else if (type == "array"){
		va_list para;
		va_start(para, address);
		stringstream sst(va_arg(para, string));
		va_end(para);
		string ss;
		sst >> ss;
		int a;
		while (sst >> a)
			x.paras.push_back({a, 1});
		for (int i = 0; i < static_cast<int>(x.paras.size()); ++i){
			for (int j = i + 1; j < static_cast<int>(x.paras.size()); ++j){
				x.paras[i].second *= x.paras[j].first;
			}
		}
		tot += x.paras[0].first * x.paras[0].second * 4;
	}
	if (p->className == "PROGRAM"){
		address = -1;
		tot = 0;
	}
	x.type = type;
	x.address = address;
	s[id] = x;
	getCurId(id);
	argsCount = 0;
	return 0;
}

void Node::getCurId(const std::string& id){
	for (Node* p = getDefineClass(this); ; p = getDefineClass(p->parent)){
		auto& s = p->symbolTable;
		auto it = s.find(id);
		if (it != s.end()){
			curId = *it;
			if (curId.second.address >= 0)
				curId.first = to_string(curId.second.address);
			else 
				curId.first = "g_" + curId.first;
			return;
		}
		if (p->className == "PROGRAM")
			break;
	}
	err("id " + id + " can't be used before decalare");
	exit(1);
}

bool Node::leftValue(Node* t){
	return t->content == "EXPS: ID" || t->content == "EXPS: ID . ID" || t->content == "EXPS: ID ARRS";
}

void Node::translate(){
	availReg.clear();
	for (int i = 0; i < 10; ++i){
		availReg.insert("$t" + to_string(i));
	}
	resReg.clear();
	resReg.resize(IRCodeRefine.size());
	int globalDef = -1;
	MipsCode.push_back("\t.data");
	MipsCode.push_back("newline:\t.asciiz\t\"\\n\"");
	for (int i = 0; i < static_cast<int>(IRCodeRefine.size()); ++i){
		const auto& v = IRCodeRefine[i];
		if (v.size() < 1)
			continue;
		const auto& s = v[0];
		if (s != "global" && globalDef == -1){
			MipsCode.push_back("\t.text");
			globalDef = MipsCode.size();
		}
		if (s == "global"){
			string code = "g_" + v[2] + ":\t.word\t";
			if (v[1] == "int")
				code += v[3];
			else // array
				code += "0:" + v[3];
			MipsCode.push_back(code);
		} else if (s == "define"){
			MipsCode.push_back(v[1]);
			MipsCode.push_back("sw $ra -4($sp)");
		} else if (s == "label"){
			MipsCode.push_back(v[1]);
		} else if (s == "call"){
			MipsCode.push_back("jal " + v[1]);
			resReg[i] = "$v0";
		} else if (s == "read"){
			MipsCode.push_back("li $v0 5");
			MipsCode.push_back("syscall");
		} else if (s == "addi"){
			MipsCode.push_back(v[0] + " " + v[1] + " " + v[2] + " " + v[3]);
		} else if (s == "j"){
			MipsCode.push_back(v[0] + " " + v[1]);
		} else if (s == "paras" || s == "="){
			if (v[1] == v[2])
				continue;
			string r1 = getReg(i, v[1], "a"), r2 = getReg(i, v[2]);
			if (r2[0] != '$'){
				string tmp = *availReg.begin();
				availReg.erase(availReg.begin());
				MipsCode.push_back("li " + tmp + " " + r2);
				r2 = tmp;
			}
			MipsCode.push_back("sw " + r2 + " 0(" + r1 + ")");
			resReg[i] = r2;
			freeReg(i, v[1], r1);
			if (!affact.count(i)){
				freeReg(i, "", r2);
			}
		} else if (s == "return"){
			if (IRCodeRefine[i - 1][0] != "addi"){
				cerr << "there should be a addi instruction before return in line " << i << endl;
				cout << "Error.\n";
				exit(1);
			}
			string preInstruction = MipsCode.back();
			MipsCode.pop_back();
			string r1 = getReg(i, v[1]);
			if (r1[0] == '$'){
				if (r1 != "$v0"){
					MipsCode.push_back("move $v0 " + r1);
					availReg.insert(r1);
				}
			} else {
				MipsCode.push_back("li $v0 " + r1);
			}
			MipsCode.push_back(preInstruction);
			MipsCode.push_back("lw $ra -4($sp)");
			MipsCode.push_back("jr $ra");
		} else if (s == "[]="){
			string r1 = getReg(i, v[1], "a"), r2 = getReg(i, v[2]);
			if (r2[0] != '$')
				MipsCode.push_back("addi " + r1 + " " + r1 + " " + r2);
			else 
				MipsCode.push_back("add " + r1 + " " + r1 + " " + r2);
			freeReg(i, v[2], r2);
			resReg[i] = r1;
		} else if (s == "[]"){
			string r1 = getReg(i, v[1], "a"), r2 = getReg(i, v[2]);
			string res = *availReg.begin();
			availReg.erase(availReg.begin());
			if (r2[0] != '$')
				MipsCode.push_back("lw " + res + " " + r2 + "(" + r1 + ")");
			else {
				MipsCode.push_back("add " + r1 + " " + r1 + " " + r2);
				MipsCode.push_back("lw " + res + " 0(" + r1 + ")");
			}
			resReg[i] = res;
			freeReg(i, v[1], r1);
			freeReg(i, v[2], r2);
			if (!affact.count(i)){
				freeReg(i, "", res);
			}
		} else {
			string r1 = getReg(i, v[1]), r2, res;
			if (r1[0] != '$'){
				string tmp = *availReg.begin();
				availReg.erase(availReg.begin());
				MipsCode.push_back("li " + tmp + " " + r1);
				r1 = tmp;
			}
			if (v.size() > 2){
				r2 = getReg(i, v[2]);
				if (r2[0] != '$'){
					string tmp = *availReg.begin();
					availReg.erase(availReg.begin());
					MipsCode.push_back("li " + tmp + " " + r2);
					r2 = tmp;
				}
			} else if (s != "~" && s != "!" && s != "write"){
				cerr << "error in IR code line " << i + 1 << " two arg but not return\n";
				cout << "Error.\n";
				exit(1);
			}
			res = *availReg.begin();
			availReg.erase(availReg.begin());
			if (s == ">"){
				MipsCode.push_back("sgt " + res + " " + r1 + " " + r2);
			} else if (s == ">="){
				MipsCode.push_back("sge " + res + " " + r1 + " " + r2);
			} else if (s == "<"){
				MipsCode.push_back("slt " + res + " " + r1 + " " + r2);
			} else if (s == "<="){
				MipsCode.push_back("sle " + res + " " + r1 + " " + r2);
			} else if (s == "&"){
				MipsCode.push_back("and " + res + " " + r1 + " " + r2);
			} else if (s == "|"){
				MipsCode.push_back("or " + res + " " + r1 + " " + r2);
			} else if (s == "~"){
				MipsCode.push_back("not " + res + " " + r1);
			} else if (s == "!"){
				MipsCode.push_back("sleu " + res + " " + r1 + " $0");
			} else if (s == "^"){
				MipsCode.push_back("xor " + res + " " + r1 + " " + r2);
			} else if (s == "+"){
				MipsCode.push_back("add " + res + " " + r1 + " " + r2);
			} else if (s == "-"){
				MipsCode.push_back("sub " + res + " " + r1 + " " + r2);
			} else if (s == "<<"){
				MipsCode.push_back("sllv " + res + " " + r1 + " " + r2);
			} else if (s == ">>"){
				MipsCode.push_back("srav " + res + " " + r1 + " " + r2);
			} else if (s == "*"){
				MipsCode.push_back("mul " + res + " " + r1 + " " + r2);
			} else if (s == "/"){
				MipsCode.push_back("div " + res + " " + r1 + " " + r2);
			} else if (s == "%"){
				MipsCode.push_back("rem " + res + " " + r1 + " " + r2);
			} else if (s == "&&"){
				MipsCode.push_back("sgtu " + r1 + " " + r1 + " $0");
				MipsCode.push_back("sgtu " + r2 + " " + r2 + " $0");
				MipsCode.push_back("and " + res + " " + r1 + " " + r2);
			} else if (s == "||"){
				MipsCode.push_back("sgtu " + r1 + " " + r1 + " $0");
				MipsCode.push_back("sgtu " + r2 + " " + r2 + " $0");
				MipsCode.push_back("or " + res + " " + r1 + " " + r2);
			} else if (s == "=="){
				MipsCode.push_back("seq " + res + " " + r1 + " " + r2);
			} else if (s == "!="){
				MipsCode.push_back("sne " + res + " " + r1 + " " + r2);
			} else if (s == "write"){
				MipsCode.push_back("move $a0 " + r1);
				MipsCode.push_back("li $v0 1");
				MipsCode.push_back("syscall");
				MipsCode.push_back("li $v0 4");
				MipsCode.push_back("la $a0 newline");
				MipsCode.push_back("syscall");
			} else if (s.back() == '=') {// paras = += -= *= /= %= &= |= ^= <<= >>=
				const string& c = s.substr(0, s.size() - 1);
				if (c == "+")
					MipsCode.push_back("add " + res + " " + r1 + " " + r2);
				else if (c == "-")
					MipsCode.push_back("sub " + res + " " + r1 + " " + r2);
				else if (c == "*")
					MipsCode.push_back("mul " + res + " " + r1 + " " + r2);
				else if (c == "/")
					MipsCode.push_back("div " + res + " " + r1 + " " + r2);
				else if (c == "%")
					MipsCode.push_back("rem " + res + " " + r1 + " " + r2);
				else if (c == "&")
					MipsCode.push_back("and " + res + " " + r1 + " " + r2);
				else if (c == "|")
					MipsCode.push_back("or " + res + " " + r1 + " " + r2);
				else if (c == "^")
					MipsCode.push_back("xor " + res + " " + r1 + " " + r2);
				else if (c == "<<")
					MipsCode.push_back("sllv " + res + " " + r1 + " " + r2);
				else if (c == ">>")
					MipsCode.push_back("srav " + res + " " + r1 + " " + r2);
				if (v[1][0] == '@'){
					int x = stoi(v[1].substr(1));
					auto it = affact.find(i - x);
					if (it == affact.end() || it->second.size() <= 1){
						availReg.insert(r1);
					}
				} else {
					availReg.insert(r1);
				}
				r1 = getReg(i, v[1], "a");
				MipsCode.push_back("sw " + res + " 0(" + r1 + ")");
			} else if (s == "beq" || s == "bne") { // beq bne
				MipsCode.push_back(v[0] + " " + r1 + " " + r2 + " " + v[3]);
			} else {
				cerr << "error with instruction " << s << " in line " << i + 1 << endl;
				cout << "Error.\n";
				exit(1);
			}
			freeReg(i, v[1], r1);
			if (v.size() > 2)
				freeReg(i, v[2], r2);
			if (!affact.count(i))
				availReg.insert(res);
			resReg[i] = res;
		}
	}
	for (int i = globalDef; i < static_cast<int>(MipsCode.size()); ++i){
		if (MipsCode[i].back() != ':'){
			MipsCode[i] = "\t" + MipsCode[i];
		}
	}
}

string Node::getReg(int i, const string& s, const string& a){
	if (s[0] == '@'){
		int x = i + stoi(s.substr(1));
		return resReg[x];
	} else if (s[0] == '#'){
		string res = *availReg.begin();
		availReg.erase(availReg.begin());
		if (a != ""){
			if (s[1] == '-' || ('0' <= s[1] && s[1] <= '9')){
				MipsCode.push_back("addi " + res + " $sp " + s.substr(1));
			} else {
				MipsCode.push_back("la " + res + " " + s.substr(1));
			}
		}
		else {
			if (s[1] == '-' || ('0' <= s[1] && s[1] <= '9')){
				MipsCode.push_back("lw " + res + " " + s.substr(1) + "($sp)");
			} else {
				MipsCode.push_back("lw " + res + " " + s.substr(1));
			}
		}
		return res;
	}
	return s;
}

void Node::freeReg(int i, const std::string& s, const std::string& reg){
	int freeFlag = 0;
	if (!s.empty() && s[0] == '@'){
		int x = stoi(s.substr(1));
		auto it = affact.find(i + x);
		if (it == affact.end()){
			freeFlag = 1;
		} else {
			if (!it->second.count(i)){
				cerr << "dependency error in translating from line " << i + x << " to line " << i << endl;
				cout << "Error.\n";
				exit(1);
			}
			it->second.erase(i);
			if (it->second.empty())
				freeFlag = 1;
		}
	} else 
		freeFlag = 1;
	if (freeFlag && reg.size() > 1 && reg.substr(0, 2) == "$t"){
		availReg.insert(reg);
	}
}