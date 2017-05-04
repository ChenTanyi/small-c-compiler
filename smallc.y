%{
/*
 * This file is used to do syntax analysis using bison
 */
#include "header.h"
#include "tree.h"

using namespace std;

extern int yylineno;
extern char* yytext;

void yyerror(const char* msg);
int yylex();

Node* root;
%}

%union{
    char* str;
    Node* node;
}

%token <str> SEMI COMMA LP RP LB RB LC RC DOT ASSIGN
%token <str> BIT_AND BIT_OR BIT_NOT BIT_XOR
%token <str> PLUS MINUS PRODUCT DIV MOD LT GT
%token <str> LOG_NOT LOG_AND LOG_OR INC DEC 
%token <str> ADD_AS SUB_AS MUL_AS DIV_AS MOD_AS AND_AS OR_AS XOR_AS 
%token <str> LEFT_SHIFT RIGHT_SHIFT LE GE EQ NE LEFT_AS RIGHT_AS
%token <str> READ WRITE TYPE STRUCT RETURN IF ELSE BREAK CONT FOR INT ID

%type <node> PROGRAM EXTDEFS EXTDEF SEXTVAR SEXTVARS EXTVARS STSPEC FUNC PARA PARAS
%type <node> STMTBLOCK STMTS STMT DEFS SDEFS SDECS DECS VAR INIT EXP EXPS ARRS ARG ARGS
%type <node> UNARY_OP

%nonassoc IF_NO_ELSE
%nonassoc ELSE
%right ASSIGN ADD_AS SUB_AS MUL_AS DIV_AS MOD_AS AND_AS OR_AS XOR_AS LEFT_AS RIGHT_AS
%left LOG_OR
%left LOG_AND
%left BIT_OR
%left BIT_XOR
%left BIT_AND
%left EQ NE
%left GT GE LT LE
%left LEFT_SHIFT RIGHT_SHIFT
%left PLUS MINUS
%left PRODUCT DIV MOD
%right UNARY
%left DOT LP LB

%start PROGRAM

%%

PROGRAM: EXTDEFS
        {
            root = $$ = createNode(yylineno, "PROGRAM", "PROGRAM: EXTDEFS", 1, $1);
        }
    ;
EXTDEFS: EXTDEFS EXTDEF
        {
            $$ = createNode(yylineno, "EXTDEFS", "EXTDEFS: EXTDEFS EXTDEF", 2, $1, $2);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "EXTDEFS", "EXTDEFS: null", 0);
        }
    ;
EXTDEF: TYPE EXTVARS SEMI
        {
            $$ = createNode(yylineno, "EXTDEF", "EXTDEF: TYPE EXTVARS ;", 2, createNode(yylineno, "TYPE", $1, 0), $2);
        }
    | STSPEC SEXTVAR SEMI
        {
            $$ = createNode(yylineno, "EXTDEF", "EXTDEF: STSPEC SEXTVAR ;", 2, $1, $2); 
        }
    | TYPE FUNC STMTBLOCK
        {
            $$ = createNode(yylineno, "EXTDEF", "EXTDEF: TYPE FUNC STMTBLOCK", 3, createNode(yylineno, "TYPE", $1, 0), $2, $3);
        }
    ;
SEXTVAR: SEXTVARS
        {
            $$ = createNode(yylineno, "SEXTVAR", "SEXTVAR: SEXTVARS", 1, $1);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "SEXTVAR", "SEXTVAR: null", 0);
        }
    ;
SEXTVARS: ID
        {
            $$ = createNode(yylineno, "SEXTVARS", "SEXTVARS: ID", 1, createNode(yylineno, "ID", $1, 0));
        }
    | SEXTVARS COMMA ID
        {
            $$ = createNode(yylineno, "SEXTVARS", "SEXTVARS: SEXTVARS , ID", 2, $1, createNode(yylineno, "ID", $3, 0));
        }
    ;
EXTVARS: VAR
        {
            $$ = createNode(yylineno, "EXTVARS", "EXTVARS: VAR", 1, $1);
        }
    | VAR ASSIGN INIT
        {
            $$ = createNode(yylineno, "EXTVARS", "EXTVARS: VAR = INIT", 2, $1, $3);
        }
    | EXTVARS COMMA VAR
        {
            $$ = createNode(yylineno, "EXTVARS", "EXTVARS: EXTVARS , VAR", 2, $1, $3);
        }
    | EXTVARS COMMA VAR ASSIGN INIT
        {
            $$ = createNode(yylineno, "EXTVARS", "EXTVARS: EXTVARS , VAR = INIT", 3, $1, $3, $5);
        }
    ;
STSPEC: STRUCT ID LC SDEFS RC
        {
            $$ = createNode(yylineno, "STSPEC", "STSPEC: STRUCT ID { SDEFS }", 3, createNode(yylineno, "STRUCT", $1, 0), createNode(yylineno, "ID", $2, 0), $4);
        }
    | STRUCT LC SDEFS RC
        {
            $$ = createNode(yylineno, "STSPEC", "STSPEC: STRUCT { SDEFS }", 2, createNode(yylineno, "STRUCT", $1, 0), $3);
        }
    | STRUCT ID
        {
            $$ = createNode(yylineno, "STSPEC", "STSPEC: STRUCT ID", 2, createNode(yylineno, "STRUCT", $1, 0), createNode(yylineno, "ID", $2, 0));
        }
    ;
FUNC: ID LP PARA RP
        {
            $$ = createNode(yylineno, "FUNC", "FUNC: ID ( PARA )", 2, createNode(yylineno, "ID", $1, 0), $3);
        }
    ;
PARA: PARAS
        {
            $$ = createNode(yylineno, "PARA", "PARA: PARAS", 1, $1);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "PARA", "PARA: null", 0);
        }
    ;
PARAS: PARAS COMMA TYPE ID
        {
            $$ = createNode(yylineno, "PARAS", "PARAS: PARAS , TYPE ID", 3, $1, createNode(yylineno, "TYPE", $3, 0), createNode(yylineno, "ID", $4, 0));
        }
    | TYPE ID
        {
            $$ = createNode(yylineno, "PARAS", "PARAS: TYPE ID", 2, createNode(yylineno, "TYPE", $1, 0), createNode(yylineno, "ID", $2, 0));
        }
    ;
STMTBLOCK: LC DEFS STMTS RC
        {
            $$ = createNode(yylineno, "STMTBLOCK", "STMTBLOCK: { DEFS STMTS }", 2, $2, $3);
        }
    ;
STMTS: STMTS STMT
        {
            $$ = createNode(yylineno, "STMTS", "STMTS: STMTS STMT", 2, $1, $2);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "STMTS", "STMTS: null", 0);
        }
    ;
STMT: EXP SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: EXP ;", 1, $1);
        }
    | STMTBLOCK
        {
            $$ = createNode(yylineno, "STMT", "STMT: STMTBLOCK", 1, $1);
        }
    | RETURN EXP SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: RETURN EXP ;", 2, createNode(yylineno, "RETURN", $1, 0), $2);
        }
    | IF LP EXPS RP STMT %prec IF_NO_ELSE
        {
            $$ = createNode(yylineno, "STMT", "STMT: IF ( EXPS ) STMT", 3, createNode(yylineno, "IF", $1, 0), $3, $5);
        }
    | IF LP EXPS RP STMT ELSE STMT
        {
            $$ = createNode(yylineno, "STMT", "STMT: IF ( EXPS ) STMT ELSE STMT", 5, createNode(yylineno, "IF", $1, 0), $3, $5, createNode(yylineno, "ELSE", $6, 0), $7);
        }
    | FOR LP EXP SEMI EXP SEMI EXP RP STMT
        {
            $$ = createNode(yylineno, "STMT", "STMT: FOR ( EXP ; EXP ; EXP ) STMT", 5, createNode(yylineno, "FOR", $1, 0), $3, $5, $7, $9);
        }
    | CONT SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: CONT ;", 1, createNode(yylineno, "CONT", $1, 0));
        }
    | BREAK SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: BREAK ;", 1, createNode(yylineno, "BREAK", $1, 0));
        }
    | READ LP EXPS RP SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: READ ( EXPS );", 2, createNode(yylineno, "READ", $1, 0), $3);
        }
    | WRITE LP EXPS RP SEMI
        {
            $$ = createNode(yylineno, "STMT", "STMT: WRITE ( EXPS );", 2, createNode(yylineno, "WRITE", $1, 0), $3);
        }
    ;
DEFS: DEFS TYPE DECS SEMI
        {
            $$ = createNode(yylineno, "DEFS", "DEFS: DEFS TYPE DECS ;", 3, $1, createNode(yylineno, "TYPE", $2, 0), $3);
        }
    | DEFS STSPEC SDECS SEMI
        {
            $$ = createNode(yylineno, "DEFS", "DEFS: DEFS STSPEC SDECS ;", 3, $1, $2, $3);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "DEFS", "DEFS: null", 0);
        }
    ;
SDEFS: SDEFS TYPE SDECS SEMI
        {
            $$ = createNode(yylineno, "SDEFS", "SDEFS: SDEFS TYPE SDECS ;", 3, $1, createNode(yylineno, "TYPE", $2, 0), $3);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "SDEFS", "SDEFS: null", 0);
        }
    ;
SDECS: SDECS COMMA ID
        {
            $$ = createNode(yylineno, "SDECS", "SDECS: SDECS , ID", 2, $1, createNode(yylineno, "ID", $3, 0));
        }
    | ID
        {
            $$ = createNode(yylineno, "SDECS", "SDECS: ID", 1, createNode(yylineno, "ID", $1, 0));
        }
    ;
DECS: VAR
        {
            $$ = createNode(yylineno, "DECS", "DECS: VAR", 1, $1);
        }
    | DECS COMMA VAR
        {
            $$ = createNode(yylineno, "DECS", "DECS: DECS , VAR", 2, $1, $3);
        }
    | DECS COMMA VAR ASSIGN INIT
        {
            $$ = createNode(yylineno, "DECS", "DECS: DECS , VAR = INIT", 3, $1, $3, $5);
        }
    | VAR ASSIGN INIT
        {
            $$ = createNode(yylineno, "DECS", "DECS: VAR = INIT", 2, $1, $3);
        }
    ;
VAR: ID
        {
            $$ = createNode(yylineno, "VAR", "VAR: ID", 1, createNode(yylineno, "ID", $1, 0));
        }
    | VAR LB INT RB
        {
            $$ = createNode(yylineno, "VAR", "VAR: VAR [ INT ]", 2, $1, createNode(yylineno, "INT", $3, 0));
        }
    ;
INIT: EXPS
        {
            $$ = createNode(yylineno, "INIT", "INIT: EXPS", 1, $1);
        }
    | LC ARGS RC
        {
            $$ = createNode(yylineno, "INIT", "INIT: { ARGS }", 1, $2);
        }
    ;
EXP: EXPS
        {
            $$ = createNode(yylineno, "EXP", "EXP: EXPS", 1, $1);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "EXP", "EXP: null", 0);
        }
    ;
EXPS: EXPS ASSIGN EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS BIT_AND EXPS     { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS BIT_XOR EXPS     { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS BIT_OR EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS PLUS EXPS        { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS MINUS EXPS       { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS PRODUCT EXPS     { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS DIV EXPS         { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS MOD EXPS         { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LT EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS GT EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LOG_AND EXPS     { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LOG_OR EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS ADD_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS SUB_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS MUL_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS DIV_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS MOD_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS AND_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS OR_AS EXPS       { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS XOR_AS EXPS      { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LEFT_SHIFT EXPS  { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS RIGHT_SHIFT EXPS { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LE EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS GE EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS EQ EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS NE EXPS          { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS LEFT_AS EXPS     { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | EXPS RIGHT_AS EXPS    { $$ = createNode(yylineno, "EXPS", $2, 2, $1, $3); }
    | UNARY_OP EXPS %prec UNARY
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: UNARY_OP EXPS", 2, $1, $2);
        }
    | LP EXPS RP
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: ( EXPS )", 1, $2);
        }
    | ID LP ARG RP
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: ID ( ARG )", 2, createNode(yylineno, "ID", $1, 0), $3);
        }
    | ID
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: ID", 1, createNode(yylineno, "ID", $1, 0));
        }
    | ID ARRS
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: ID ARRS", 2, createNode(yylineno, "ID", $1, 0), $2);
        }
    | ID DOT ID
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: ID . ID", 2, createNode(yylineno, "ID", $1, 0), createNode(yylineno, "ID", $3, 0));
        }
    | INT
        {
            $$ = createNode(yylineno, "EXPS", "EXPS: INT", 1, createNode(yylineno, "INT", $1, 0));
        }
    ;
ARRS: ARRS LB EXPS RB
        {
            $$ = createNode(yylineno, "ARRS", "ARRS: ARRS [ EXPS ]", 2, $1, $3);
        }
    | LB EXPS RB
        {
            $$ =  createNode(yylineno, "ARRS", "ARRS: [ EXPS ]", 1, $2);
        }
    ;
ARG: ARGS
        {
            $$ = createNode(yylineno, "ARG", "ARG: ARGS", 1, $1);
        }
    | /* empty */
        {
            $$ = createNode(yylineno, "ARG", "ARG: null", 0);
        }
    ;
ARGS: ARGS COMMA EXPS
        {
            $$ = createNode(yylineno, "ARGS", "ARGS: ARGS , EXPS", 2, $1, $3);
        }
    | EXPS
        {
            $$ = createNode(yylineno, "ARGS", "ARGS: EXPS", 1, $1);
        }
    ;
UNARY_OP: PLUS  { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    | MINUS     { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    | BIT_NOT   { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    | LOG_NOT   { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    | INC       { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    | DEC       { $$ = createNode(yylineno, "UNARY_OP", $1, 0); }
    ;

%%

void yyerror(const char *msg)
{
    fflush(stdout);
    fprintf(stderr, "Error: %s at line %d\n", msg, yylineno);
    fprintf(stderr, "Parser does not expect '%s'\n",yytext);
}