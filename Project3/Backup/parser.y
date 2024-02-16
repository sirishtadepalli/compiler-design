/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   UMGC CITE
   Summer 2023
   
   Project 3 Parser with semantic actions for the interpreter */

%{

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;
}

%token IDENTIFIER INT_LITERAL CHAR_LITERAL HEX_DEC_LITERAL REAL_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW OROP NOTOP REMOP EXPOP NEGOP

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ELSIF ENDFOLD ENDIF FOLD IF LEFT REAL RIGHT THEN

%type <value> body statement_ statement cases case expression term power primary
	 and_condition or_choice not_condition relation

%type <list> list expressions

%%

function:	
	function_header optional_variable  body ';' {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';'  ;

optional_parameters:
	parameters |
	%empty ;

parameters:
	parameter following_parameters ;

following_parameters:
	following_parameters ',' parameter |
	%empty ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER |
	REAL |
	CHARACTER ;
	
optional_variables:
	optional_variables variable |
	%empty ;
	
variable:	
	IDENTIFIER ':' type IS statement ';' {scalars.insert($1, $5);}; |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $7);} ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} | 
	expression {$$ = new vector<double>(); $$->push_back($1);}

body:
	BEGIN_ statement_ END {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	expression |
	WHEN or_choice ',' expression ':' expression {$$ = $2 ? $4 : $6;} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH
		{$$ = !isnan($4) ? $4 : $7;} ; |
	IF or_choice THEN statement ';' elsifs ELSE statement ';' ENDIF |
	FOLD direction operator list_choice ENDFOLD ;

cases:
	cases case {$$ = !isnan($1) ? $1 : $2;} |
	%empty {$$ = NAN;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;} ; 

or_choice:
	or_choice OROP and_condition |
	and_condition ;

and_condition:
	and_condition ANDOP relation {$$ = $1 && $2;} |
	relation ;

relation:
	'(' and_condition ')' {$$ = $2;} |
	expression RELOP expression {$$ = evaluateRelational($1, $2, $3);} |
	expression ;

expression:
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;
      
term:
	term MULOP primary {$$ = evaluateArithmetic($1, $2, $3);}  |
	term REMOP power |
	power ; ;

power:
   	not_condition EXPOP power |
	not_condition ;

not_condition:
	NOTOP primary |
	primary ;

primary:
	'(' or_choice ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	HEX_DEC_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);} |
	NEGOP primary;;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
