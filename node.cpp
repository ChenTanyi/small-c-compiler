/*
 * This file is used to implement all 
 * the codeGen function for all derived class 
 */
#include "node.h"
#include "tree.h"

using namespace std;

Node* getNode(const std::string& className){
	switch(PROGRAM);
	switch(EXTDEF);
	switch(SEXTVARS);
	switch(EXTVARS);
	switch(STSPEC);
	switch(FUNC);
	switch(PARAS);
	switch(STMTBLOCK);
	switch(STMT);
	switch(DEFS);
	switch(SDEFS);
	switch(SDECS);
	switch(DECS);
	switch(VAR);
	switch(EXPS);
	switch(ARRS);
	switch(ARGS);
	switch(INT);
	return new Node();
}

void PROGRAMNode::codeGen(){
	Node::codeGen();
	auto it = funcTable.find("main");
	if (it == funcTable.end() || it->second != 0){
		err("need to define the function 'int main()' as entrance");
		exit(1);
	}
	int i = 0;
	while (IRCode[i++] != "define main:");
	for (const auto& x : initBeforeRun){
		IRCode.insert(IRCode.begin() + i, x.second.begin(), x.second.end());
	}
	int globalDef = 0, curFuncVar = 0;
	for (int i = 0; i < static_cast<int>(IRCode.size()); ++i){
		stringstream sst(IRCode[i]);
		vector<string> v;
		string s;
		while (sst >> s){
			if (s[0] == '@'){
				int x = stoi(s.substr(1));
				if (IRCodeRefine[IRCodeRefine.size() + x].size() == 1){
					s = IRCodeRefine[IRCodeRefine.size() + x][0];
				} else {
					for (int j = x + 1; j < 0; ++j){
						if (IRCodeRefine[IRCodeRefine.size() + j].size() == 1)
							++x;
					}
					s = "@" + to_string(x);
				}
			}
			v.push_back(s);
		}
		if (v[0] == "define")
			curFuncVar = funcVar[v[1].substr(0, v[1].size() - 1)];
		else if (v[0] == "return")
			IRCodeRefine.back().back() = to_string(curFuncVar + 4);
		if (v[0] == "global")
			IRCodeRefine.insert(IRCodeRefine.begin() + (globalDef++), v);
		else
			IRCodeRefine.push_back(v);
	}
	for (auto it = IRCodeRefine.begin(); it != IRCodeRefine.end(); ){
		if (it->size() == 1)
			it = IRCodeRefine.erase(it);
		else 
			++it;
	}
	for (int i = 0; i < static_cast<int>(IRCodeRefine.size()); ++i){
		auto& v = IRCodeRefine[i];
		for (int j = 0; j < static_cast<int>(v.size()); ++j){
			auto& s = v[j];
			if (s[0] == '@'){
				int x = stoi(s.substr(1));
				affact[i + x].insert(i);
				if (j == 1 && v[0] == "=" && IRCodeRefine[i + x][0] == "[]"){
					IRCodeRefine[i + x][0] = "[]=";
				}
			}
		}
	}
	auto funcBegin = IRCodeRefine.end();
	for (auto it = IRCodeRefine.begin(); it != IRCodeRefine.end(); ++it){
		if ((*it)[0] == "define"){
			if (funcBegin != IRCodeRefine.end()){
				it = IRCodeRefine.erase(funcBegin, it);
				funcBegin = IRCodeRefine.end();
			}
			const string& call = (*it)[1];
			const string& funcName = call.substr(0, call.size() - 1);
			if (!funcCall[funcName]){
				funcBegin = it;
			}
		}
	}
}

void EXTDEFNode::codeGen(){
	if (content == "EXTDEF: TYPE FUNC STMTBLOCK"){
		insideFunction = true;
		children[1]->codeGen();
		int x = IRCode.size();
		totalVar = 0;
		children[2]->codeGen();
		getTotalVarInFunc(totalVar);
		vector<string> v;
		v.push_back("addi $sp $sp " + to_string(- (totalVar + 4)));
		funcName = children[1]->children[0]->content;
		int tot = funcTable[funcName] * 4;
		if (tot != totalVar)
			for (int i = funcTable[funcName]; i > 0; --i){
				v.push_back("= #" + to_string(tot - i * 4) + " #" + to_string(totalVar - i * 4));
			}
		IRCode.insert(IRCode.begin() + x, v.begin(), v.end());
		if (IRCode.back().find("return") == string::npos){
			IRCode.push_back("addi $sp $sp " + to_string(totalVar + 4));
			IRCode.push_back("return 0");
		}
		funcVar[funcName] = totalVar;
		insideFunction = false;
	}
	else if (content == "EXTDEF: STSPEC SEXTVAR ;"){
		Node::codeGen();
		structType.clear();
	}
	else 
		Node::codeGen();
}

void SEXTVARSNode::codeGen(){
	int a = 0;
	if (content == "SEXTVARS: SEXTVARS , ID"){
		children[0]->codeGen();
		++a;
	}
	Node* t = children[a];
	int address;
	int rtn = saveIdtoTable(t->content, "struct_" + structType, address);
	CHECK_RTN("error in saving to table");
	const auto& fields = getStructTableWithType(structType);
	if (!fields.first){
		err("can't decalare a struct type " + structType + " without definition");
		exit(1);
	}
	for (const auto& s : fields.second){
		rtn = saveIdtoTable(t->content + "." + s, "int", address);
		IRCode.push_back("global int " + t->content + "." + s + " 0");
		CHECK_RTN("error in saving to table");
	}
}

void EXTVARSNode::codeGen(){
	Node* t = 0;
	if (content == "EXTVARS: VAR"){
		t = children[0];
	}
	if (content == "EXTVARS: EXTVARS , VAR"){
		children[0]->codeGen();
		t = children[1];
	}
	if (t){
		if (t->content == "VAR: ID"){
			IR = "global int " + t->children[0]->content + " 0";
			IRCode.push_back(IR);
			int address;
			int rtn = saveIdtoTable(t->children[0]->content, "int", address);
			CHECK_RTN("error in saving to table");
		} else { // "VAR: VAR [ INT ]"
			t->codeGen();
			stringstream sst(IR);
			string name;
			sst >> name;
			int address;
			int rtn = saveIdtoTable(name, "array", address, IR);
			CHECK_RTN("error in saving to table");
			int space = 1, x;
			while (sst >> x)
				space *= x;
			IR = "global array " + name + " " + to_string(space);
			IRCode.push_back(IR);
		}
		return;
	}
	int a = 0;
	if (content == "EXTVARS: EXTVARS , VAR = INIT"){
		children[0]->codeGen();
		++a;
	}
	t = children[a];
	Node* r = children[a + 1];
	initGen = true;
	if (t->content == "VAR: ID"){
		if (r->content == "INIT: { ARGS }"){
			err("integer can't be initialized by Initialize list");
			exit(1);
		} // EXPS
		int address;
		int rtn = saveIdtoTable(t->children[0]->content, "int", address);
		CHECK_RTN("error in saving to table");
		IR = "global int " + t->children[0]->content;
		if (r->children[0]->content == "EXPS: INT"){
			IR += " " + to_string(r->children[0]->children[0]->count());
		}
		else {
			r->codeGen();
			curInit.push_back("= #" + t->children[0]->content + " @-1");
			IR += " 0";
		}
		IRCode.push_back(IR);
		getCurId(t->children[0]->content);
	} else { // "VAR: VAR [ INT ]"
		if (r->content == "INIT: EXPS"){
			err("array can't be initialized by single expression");
			exit(1);
		}
		t->codeGen();
		stringstream sst(IR);
		string name;
		sst >> name;
		int address;
		int rtn = saveIdtoTable(name, "array", address, IR);
		CHECK_RTN("error in saving to table");
		int space = 1, x;
		while (sst >> x)
			space *= x;
		IR = "global array " + name + " " + to_string(space);
		IRCode.push_back(IR);
		r->codeGen();
		getCurId(name);
	}
	if (!curInit.empty())
		initBeforeRun[curId.first] = curInit;
	curInit.clear();
	initGen = false;
}

void STSPECNode::codeGen(){
	structDef = true;
	structFields.clear();
	if (content == "STSPEC: STRUCT ID"){
		structType = children[1]->content;
	} else if (content == "STSPEC: STRUCT ID { SDEFS }"){
		structType = children[1]->content;
		children[2]->codeGen();
		int rtn = saveTypeToStructTable(structType, 1);
		CHECK_RTN("error in saving struct type to table");
	} else { // STSPEC: STRUCT { SDEFS }
		if (parent->children[1] != this){
			if (parent->children[1]->children.size() == 0){ // global but no id
				structDef = false;
				return;
			}
		}
		structType = to_string(noNameStructCount++);  // no type name
		children[1]->codeGen();
		int rtn = saveTypeToStructTable(structType, 1);
		CHECK_RTN("error in saving struct type to table");
	}
	structDef = false;
}

void FUNCNode::codeGen(){
	funcParas.clear();
	children[1]->codeGen();
	funcName = children[0]->content;
	int rtn = saveIdtoFuncTable(funcName, funcParas.size());
	CHECK_RTN("error in saving to table");
	IRCode.push_back("define " + funcName + ":");
}

void PARASNode::codeGen(){
	Node* t = children[1];
	if (content == "PARAS: PARAS , TYPE ID"){
		children[0]->codeGen();
		t = children[2];
	}
	funcParas.push_back(t->content);
}

void STMTBLOCKNode::codeGen(){
	++insideStmtBlocks;
	totalVar = getTotalVar();
	if (funcParas.size()){
		for (const auto& para : funcParas){
			int address;
			int rtn = saveIdtoTable(para, "int", address);
			CHECK_RTN("error in saving para to table");
		}
		funcParas.clear();
	}
	Node::codeGen();
	--insideStmtBlocks;
}

void STMTNode::codeGen(){
	if (content == "STMT: RETURN EXP ;"){
		if (!insideFunction){
			err("can't use return outside the function");
			exit(1);
		}
		Node* p = this;
		while (p->className != "EXTDEF")
			p = p->parent;
		totalVar = p->totalVar;
		if (children[1]->content == "EXP: null"){
			IRCode.push_back("addi $sp $sp " + to_string(totalVar + 4));
			IRCode.push_back("return 0");
		}
		else {
			children[1]->codeGen();
			IRCode.push_back("addi $sp $sp " + to_string(totalVar + 4));
			IRCode.push_back("return @-2");
		}
	} else if (content == "STMT: CONT ;"){
		if (!insideLoop){
			err("can't use continue outside the loop");
			exit(1);
		}
		IRCode.push_back("j " + forLoopNext);
	} else if (content == "STMT: BREAK ;"){
		if (!insideLoop){
			err("can't use break outside the loop");
			exit(1);
		}
		IRCode.push_back("j " + forLoopEnd);
	} else if (content == "STMT: READ ( EXPS );"){
		if (!leftValue(children[1])){
			err("need left value to be parameter of read function");
			exit(1);
		}
		children[1]->codeGen();
		IRCode.push_back("read func");
		IRCode.push_back("= @-2 $v0");
	} else if (content == "STMT: WRITE ( EXPS );"){
		children[1]->codeGen();
		IRCode.push_back("write @-1");
	} else if (content == "STMT: FOR ( EXP ; EXP ; EXP ) STMT"){
		++insideLoop;
		string forStart = "for.loop." + to_string(++forLoopNum) + ".start";
		string forNext = "for.loop." + to_string(forLoopNum) + ".next";
		string forEnd = "for.loop." + to_string(forLoopNum) + ".end";
		string tmpForNext = forLoopNext, tmpForEnd = forLoopEnd;
		forLoopNext = forNext; forLoopEnd = forEnd;
		children[1]->codeGen(); //init
		IRCode.push_back("label " + forStart + ":");
		if (children[2]->content != "EXP: null"){
			children[2]->codeGen(); //check
			IRCode.push_back("beq @-1 $0 " + forEnd);
		}
		children[4]->codeGen(); //stmt
		IRCode.push_back("label " + forNext + ":");
		children[3]->codeGen();
		IRCode.push_back("j " + forStart);
		IRCode.push_back("label " + forEnd + ":");
		forLoopNext = tmpForNext, forLoopEnd = tmpForEnd;
		--insideLoop;
	} else if (content == "STMT: IF ( EXPS ) STMT" || content == "STMT: IF ( EXPS ) STMT ELSE STMT"){
		string ifThen = "if." + to_string(++ifElseNum) + ".then";
		string ifElse = "if." + to_string(ifElseNum) + ".else";
		string ifEnd = "if." + to_string(ifElseNum) + ".end";
		children[1]->codeGen(); //exps
		if (children.size() > 3)
			IRCode.push_back("beq @-1 $0 " + ifElse);
		else 
			IRCode.push_back("beq @-1 $0 " + ifEnd);
		children[2]->codeGen();
		if (children.size() > 3){
			IRCode.push_back("j " + ifEnd);
			IRCode.push_back("label " + ifElse + ":");
			children[4]->codeGen();
		}
		IRCode.push_back("label " + ifEnd + ":");
	} else 
		Node::codeGen();
}

void DEFSNode::codeGen(){
	Node::codeGen();
}

void SDEFSNode::codeGen(){
	Node::codeGen();
}

void SDECSNode::codeGen(){
	int a = 0;
	if (content == "SDECS: SDECS , ID"){
		children[0]->codeGen();
		++a;
	}
	Node* t = children[a];
	if (structDef){
		structFields.push_back(t->content);
	} else {
		int address;
		int rtn = saveIdtoTable(t->content, "struct_" + structType, address);
		CHECK_RTN("error in saving to table");
		const auto& fields = getStructTableWithType(structType);
		if (!fields.first){
			err("can't decalare a struct type " + structType + " without definition");
			exit(1);
		}
		for (const auto& s : fields.second){
			int rtn = saveIdtoTable(t->content + "." + s, "int", address);
			CHECK_RTN("error in saving to table");
		}
	}
}

void DECSNode::codeGen(){
	Node* t = 0;
	if (content == "DECS: VAR"){
		t = children[0];
	}
	if (content == "DECS: DECS , VAR"){
		children[0]->codeGen();
		t = children[1];
	}
	if (t){
		if (t->content == "VAR: ID"){
			int address;
			int rtn = saveIdtoTable(t->children[0]->content, "int", address);
			CHECK_RTN("error in saving to table");
		} else { // VAR: VAR [ INT ]
			t->codeGen();
			stringstream sst(IR);
			string name;
			sst >> name;
			int address;
			int rtn = saveIdtoTable(name, "array", address, IR);
			CHECK_RTN("error in saving to table");
		}
		return;
	}
	int a = 0;
	if (content == "DECS: DECS , VAR = INIT"){
		children[0]->codeGen();
		++a;
	}
	t = children[a];
	Node* r = children[a + 1];
	initGen = true;
	if (t->content == "VAR: ID"){
		if (r->content == "INIT: { ARGS }"){
			err("integer can't be initialized by Initialize list");
			exit(1);
		} // EXPS
		int address;
		int rtn = saveIdtoTable(t->children[0]->content, "int", address);
		CHECK_RTN("error in saving to table");
		if (r->children[0]->content == "EXPS: INT"){
			IRCode.push_back("= #" + curId.first + " " + to_string(r->children[0]->children[0]->count()));
		}
		else {
			r->codeGen();
			IRCode.push_back("= #" + curId.first + " @-1");
		}
	} else { // "VAR: VAR [ INT ]"
		if (r->content == "INIT: EXPS"){
			err("array can't be initialized by single expression");
			exit(1);
		}
		t->codeGen();
		stringstream sst(IR);
		string name;
		sst >> name;
		int address;
		int rtn = saveIdtoTable(name, "array", address, IR);
		CHECK_RTN("error in saving to table");
		int space = 1, x;
		while (sst >> x)
			space *= x;
		if (!insideFunction){
			err("should inside a function");
			exit(1);
		}
		IRCode.push_back("init_" + funcName + to_string(insideStmtBlocks) + "_array_" + name + ":");
		r->codeGen();
	}
	initGen = false;
}

void VARNode::codeGen(){
	if (content == "VAR: ID"){
		IR = children[0]->content;
	} else { // "VAR: VAR [ INT ]"
		children[0]->codeGen();
		IR += " " + children[1]->content;
	}
}

void EXPSNode::codeGen(){
	auto* x = &IRCode;
	if (initGen && !insideFunction)
		x = &curInit;
	auto& code = *x;
	if (content == "EXPS: INT"){
		code.push_back(to_string(children[0]->count()));
	} else if (content == "EXPS: ID"){
		auto tmpId = curId;
		getCurId(children[0]->content);
		if (curId.second.type != "int"){
			err("can just use integer for calculate");
			exit(1);
		}
		code.push_back("#" + curId.first);
		curId = tmpId;
	} else if (content == "EXPS: ID . ID"){
		auto tmpId = curId;
		string name = children[0]->content + "." + children[1]->content;
		getCurId(name);
		code.push_back("#" + curId.first);
		curId = tmpId;
	} else if (content == "EXPS: ID ARRS"){
		auto tmpId = curId;
		getCurId(children[0]->content);
		arrsCount = 0;
		children[1]->codeGen();
		if (arrsCount != static_cast<int>(curId.second.paras.size())){
			err("error in get value of array");
			exit(1);
		}
		code.push_back("[] #" + curId.first + " @-1");
		curId = tmpId;
	} else if (content == "EXPS: ID ( ARG )"){
		auto it = funcTable.find(children[0]->content);
		funcCall[children[0]->content] = 1;
		if (it != funcTable.end())
			totalArgs = it->second * 4;
		argsCount = 0;
		auto tmpInit = initGen;
		initGen = false;
		children[1]->codeGen();
		initGen = tmpInit;
		if (it == funcTable.end() || it->second * 4 != argsCount){
			err("call function " + children[0]->content + " with " 
				+ to_string(argsCount / 4) + " paras error");
			exit(1);
		}
		code.push_back("call " + it->first);
	} else if (content == "EXPS: ( EXPS )"){
		Node::codeGen();
	} else if (content == "EXPS: UNARY_OP EXPS"){
		children[1]->codeGen();
		Node* t = children[0];
		if (t->content == "++")
			code.push_back("+= @-1 1");
		else if (t->content == "--")
			code.push_back("-= @-1 1");
		else if (t->content == "-")
			code.push_back("- $0 @-1");
		else if (t->content != "+")
			code.push_back(t->content + " @-1");
	} else {
		if (content == "=" || content == "+=" || content == "-=" || content == "*=" || 
			content == "/=" || content == "%=" || content == "&=" || content == "|=" ||
			content == "^=" || content == "<<=" || content == ">>=")
			if (!leftValue(children[0])){
				err("should assign to left value");
				exit(1);
			}
		children[0]->codeGen();
		int w = code.size();
		children[1]->codeGen();
		int e = code.size();
		code.push_back(content + " @" + to_string(w - e - 1) + " @-1");
	}
}

void ARRSNode::codeGen(){
	auto* x = &IRCode;
	if (initGen && !insideFunction)
		x = &curInit;
	auto& code = *x;
	if (content == "ARRS: ARRS [ EXPS ]"){
		children[0]->codeGen();
		int w = code.size();
		children[1]->codeGen();
		int x = curId.second.paras[arrsCount].second;
		IRCode.push_back("* @-1 " + to_string(x * 4));
		int e = code.size();
		IRCode.push_back("+ @-1 @" + to_string(w - e - 1));
		++arrsCount;
	} else {
		children[0]->codeGen();
		int x = curId.second.paras[arrsCount].second;
		code.push_back("* @-1 " + to_string(x * 4));
		++arrsCount;
	}
}

void ARGSNode::codeGen(){
	int a = 0;
	if (content == "ARGS: ARGS , EXPS"){
		children[0]->codeGen();
		++a;
	}
	Node* t = children[a];
	if (initGen){
		t->codeGen();
		if (insideFunction){
			IRCode.push_back("[] #" + curId.first + " " + to_string(argsCount));
			IRCode.push_back("= @-1 @-2");
		}
		else{
			curInit.push_back("[] #" + curId.first + " " + to_string(argsCount));
			curInit.push_back("= @-1 @-2");
		}
		argsCount += 4;
	} else {
		t->codeGen();
		IRCode.push_back("paras #" + to_string(argsCount - totalArgs - 4) + " @-1");
		argsCount += 4;
	}
}

void INTNode::codeGen(){
	
}

int INTNode::count(){
	return stoi(content, nullptr, 0);
}