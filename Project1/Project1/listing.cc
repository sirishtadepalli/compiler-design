// CMSC 430 Compiler Theory and Design
// Project 1 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the functions that produces the 
// compilation listing

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber; //this is initialized to 1 in the first line function
//static string error = ""; //the append error function will add to this initial empty string
static int totalErrors = 0;
static queue <string> errorQueue; //added this to store the error messages instead of the original static string variable

//added these three variables to keep count of the type of error in the modified appendError function.
static int lexicalErrors = 0; 
static int syntacticErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber); //prints newline and then formats the line number by having 4 digits
	//and if there isn't 4, it pads it from the left with spaces. Then it follows it with two spaces. 
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r"); //this returns the cursor to the beginning of the line
	displayErrors();
	
    //intended to print the number of the three types of errors, or confirm successful compilation
	if (totalErrors > 0) {
        printf("Lexical Errors: %d, Syntactic Errors: %d, Semantic Errors: %d\n",
               lexicalErrors, syntacticErrors, semanticErrors); 
    } else {
        printf("Compiled Successfully\n");
    }

	return totalErrors;
}

//the ErrorCategories in listing.h and a string message are passed to this function from somewhere  
void appendError(ErrorCategories errorCategory, string message) 
{
	string messages[] = { "Lexical Error, Invalid Character ", "Syntax Error",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };

    //this part is intended raise the count of that error category's variable
	switch (errorCategory) {
        case LEXICAL:
            lexicalErrors++;
            break;
        case SYNTAX:
            syntacticErrors++;
            break;
        case GENERAL_SEMANTIC:
            semanticErrors++;
            break; 
    }

    //The enum datatype also has a numerical value which is used to get the index for the messages array.
    string error = "Line " + to_string(lineNumber) + ": " + messages[errorCategory] + message;
    errorQueue.push(error);
	totalErrors++;
}


void displayErrors() {
    while(!errorQueue.empty()){
		printf("%s\n", errorQueue.front().c_str());//accesses front item and c_str turns string into what printf can understand
        errorQueue.pop(); //gets rid of that item
    }	
}
