// CMSC 430 Compiler Theory and Design
// Project 3 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
	}
	return result;
}

double evaluateRelational(double left, Operators operator_, double right) {
	double result;
	switch (operator_) {
		case LESS:
			result = left < right;
			break;
	}
	return result;
}


int hexStringToInt(const std::string& hexString) {
    // Check for the "#" prefix and adjust the starting position accordingly
    int start = (hexString[0] == '#') ? 1 : 0; 
	int len = hexString.length();
    int result = 0;
	int base = 1; 
	for (int i = len - 1; i >= start; i--) {
		
			// if character lies in '0'-'9', converting it to integral 0-9 by subtracting 48 from ASCII value
			if (hexString[i] >= '0' && hexString[i] <= '9') {
				result += (int(hexString[i]) - 48) * base;
			}
	
			// if character lies in 'A'-'F' , converting it to integral 10 - 15 by subtracting 55 from ASCII value
			else if ((hexString[i] >= 'A' && hexString[i] <= 'F')) {
    			result += (int(hexString[i]) - 55) * base;
			}
			// if character lies in 'A'-'F' , converting it to integral 10 - 15 by subtracting 87 from ASCII value
			else if ((hexString[i] >= 'a' && hexString[i] <= 'f')) {
    			result += (int(hexString[i]) - 87) * base;
			}

			// incrementing base by power
			base = base * 16;		
	}
	return result;
}

