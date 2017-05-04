/*
 * This file is used to declare all the 
 * derived class from basic node
 */
#ifndef node_H
#define node_H

#include "header.h"
#include "tree.h"

#define GenNode(x) \
class x##Node : public Node { \
public: \
	virtual void codeGen() override; \
};

#define switch(x) \
if (#x == className) return new x##Node();


GenNode(PROGRAM);
GenNode(EXTDEF);
GenNode(SEXTVARS);
GenNode(EXTVARS);
GenNode(STSPEC);
GenNode(FUNC);
GenNode(PARAS);
GenNode(STMTBLOCK);
GenNode(STMT);
GenNode(DEFS);
GenNode(SDEFS);
GenNode(SDECS);
GenNode(DECS);
GenNode(VAR);
GenNode(EXPS);
GenNode(ARRS);
GenNode(ARGS);

class INTNode : public Node{
	virtual void codeGen() override;
	virtual int count() override;
};

#endif