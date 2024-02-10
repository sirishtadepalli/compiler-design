/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL HEX_DEC_LITERAL REAL_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW OROP NOTOP REMOP EXPOP NEGOP

%token BEGIN_ CASE CHARACTER ELSE END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ELSIF ENDFOLD ENDIF FOLD IF LEFT REAL RIGHT THEN

%%

function:	
	function_header optional_variables body ;

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
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' ;

list:
	'(' expressions ')' ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	expression |
	WHEN or_choice ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH  |
	IF or_choice THEN statement ';' elsifs ELSE statement ';' ENDIF |
	FOLD direction operator list_choice ENDFOLD ;

elsifs:
	elsifs ELSIF or_choice THEN statement ';' |
	%empty ;

direction:
	LEFT | RIGHT ;

operator:
	ADDOP | MULOP ;

list_choice:
	list |
	IDENTIFIER ;


cases:
	cases case |
	%empty ;
	
case:
	CASE INT_LITERAL ARROW statement ';' ; 

or_choice:
	or_choice OROP and_condition |
	and_condition ;

and_condition:
	
	and_condition ANDOP relation |
	relation ;

relation:
	'(' or_choice ')' |
	expression RELOP expression |
	expression ;


expression:
	expression ADDOP term |

	term ;
      
term:
	term MULOP power |
	term REMOP power |
	power ;

power:
   	not_condition EXPOP power |
	not_condition ;

not_condition:
	NOTOP primary |
	primary ;

primary:
	'(' or_choice ')' |
	INT_LITERAL |
	CHAR_LITERAL |
	REAL_LITERAL |
	HEX_DEC_LITERAL |
	IDENTIFIER '(' expression ')' |	
	IDENTIFIER |
	NEGOP primary;



%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
