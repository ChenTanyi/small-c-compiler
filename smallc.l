%{
/*
 * This file is used to do lexical analysis using flex
 */
#include "header.h"
#include "tree.h"
#include "y.tab.h"

using namespace std;
%}

digit       [0-9]
letter      [a-zA-Z_]
id          {letter}({digit}|{letter})*

dec         0|[1-9][0-9]*(u?[lL]?|[lL]?u?)
oct         0[0-7]+
hex         0[xX][0-9a-fA-F]+
int         {dec}|{oct}|{hex}

%%
[ \t\v\f]+
"\n"                ++yylineno;
";"                 { yylval.str = strdup(yytext); return SEMI; }
","                 { yylval.str = strdup(yytext); return COMMA; }
"("                 { yylval.str = strdup(yytext); return LP; }
")"                 { yylval.str = strdup(yytext); return RP; }
"["                 { yylval.str = strdup(yytext); return LB; }
"]"                 { yylval.str = strdup(yytext); return RB; }
"{"                 { yylval.str = strdup(yytext); return LC; }
"}"                 { yylval.str = strdup(yytext); return RC; }
"."                 { yylval.str = strdup(yytext); return DOT; }
"="                 { yylval.str = strdup(yytext); return ASSIGN; }
"&"                 { yylval.str = strdup(yytext); return BIT_AND; }
"|"                 { yylval.str = strdup(yytext); return BIT_OR; }
"~"                 { yylval.str = strdup(yytext); return BIT_NOT; }
"^"                 { yylval.str = strdup(yytext); return BIT_XOR; }
"+"                 { yylval.str = strdup(yytext); return PLUS; }
"-"                 { yylval.str = strdup(yytext); return MINUS; }
"*"                 { yylval.str = strdup(yytext); return PRODUCT; }
"/"                 { yylval.str = strdup(yytext); return DIV; }
"%"                 { yylval.str = strdup(yytext); return MOD; }
"<"                 { yylval.str = strdup(yytext); return LT; }
">"                 { yylval.str = strdup(yytext); return GT; }
"!"                 { yylval.str = strdup(yytext); return LOG_NOT; }
"&&"                { yylval.str = strdup(yytext); return LOG_AND; }
"||"                { yylval.str = strdup(yytext); return LOG_OR; }
"++"                { yylval.str = strdup(yytext); return INC; }
"--"                { yylval.str = strdup(yytext); return DEC; }
"+="                { yylval.str = strdup(yytext); return ADD_AS; }
"-="                { yylval.str = strdup(yytext); return SUB_AS; }
"*="                { yylval.str = strdup(yytext); return MUL_AS; }
"/="                { yylval.str = strdup(yytext); return DIV_AS; }
"%="				{ yylval.str = strdup(yytext); return MOD_AS; }
"&="                { yylval.str = strdup(yytext); return AND_AS; }
"|="                { yylval.str = strdup(yytext); return OR_AS; }
"^="                { yylval.str = strdup(yytext); return XOR_AS; }
"<<"                { yylval.str = strdup(yytext); return LEFT_SHIFT; }
">>"                { yylval.str = strdup(yytext); return RIGHT_SHIFT; }
"<="                { yylval.str = strdup(yytext); return LE; }
">="                { yylval.str = strdup(yytext); return GE; }
"=="                { yylval.str = strdup(yytext); return EQ; }
"!="                { yylval.str = strdup(yytext); return NE; }
"<<="               { yylval.str = strdup(yytext); return LEFT_AS; }
">>="               { yylval.str = strdup(yytext); return RIGHT_AS; }
"read"              { yylval.str = strdup(yytext); return READ; }
"write"             { yylval.str = strdup(yytext); return WRITE; }
"int"               { yylval.str = strdup(yytext); return TYPE; }
"struct"            { yylval.str = strdup(yytext); return STRUCT; }
"return"            { yylval.str = strdup(yytext); return RETURN; }
"if"                { yylval.str = strdup(yytext); return IF; }
"else"              { yylval.str = strdup(yytext); return ELSE; }
"break"             { yylval.str = strdup(yytext); return BREAK; }
"continue"          { yylval.str = strdup(yytext); return CONT; }
"for"               { yylval.str = strdup(yytext); return FOR; }
{int}               { yylval.str = strdup(yytext); return INT; }
{id}                { yylval.str = strdup(yytext); return ID; }

%%

int yywrap(void){
    return 1;
}