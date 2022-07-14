%{
#include <stdio.h> 
#include <math.h> 
#include <stdlib.h>
#include <string.h>
#include <cstdio>
#include <iostream>
using namespace std;

extern int yylex();
extern int yyparse();
extern FILE *yyin;

int yyerror(const char* message);

%}

%union{
	int numVal;
	char* strVal;
	bool boolVal;
	char charVal;
	float fVal;
}


/*
%nterm <fval> statement;
%nterm <fval> expression;
*/

%token<strVal> TOKEN_STRINGCONST TOKEN_ID 
%token<numVal> TOKEN_DECIMALCONST TOKEN_HEXADECIMALCONST
%token<boolVal> TOKEN_BOOLEANCONST 
%token<charVal> TOKEN_CHARCONST 
%token<strVal>
	TOKEN_CLASS  TOKEN_PROGRAMCLASS TOKEN_VOIDTYPE
	TOKEN_INTTYPE TOKEN_BOOLEANTYPE TOKEN_ELSECONDITION
	TOKEN_IFCONDITION TOKEN_LOOP TOKEN_RETURN
	TOKEN_BREAKSTMT TOKEN_CONTINUESTMT
	TOKEN_CALLOUT TOKEN_MAINFUNC
%token<strVal> 
	TOKEN_ASSIGNOP_ASSIGN TOKEN_ASSIGNOP_ADDITIONASSIGN TOKEN_ASSIGNOP_SUBTRACTIONASSIGN 
	TOKEN_CONDITIONOP_OR TOKEN_CONDITIONOP_AND TOKEN_EQUALITYOP_EQ TOKEN_EQUALITYOP_NOTEQ
	TOKEN_RELATIONOP_L TOKEN_RELATIONOP_LEQ TOKEN_RELATIONOP_S TOKEN_RELATIONOP_SEQ
	TOKEN_ARITHMATICOP_PLUS TOKEN_ARITHMATICOP_MINUS
	TOKEN_ARITHMATICOP_MULT TOKEN_ARITHMATICOP_DIVISION TOKEN_ARITHMATICOP_REMAIN
	TOKEN_LOGICOP TOKEN_LB TOKEN_RB TOKEN_LP TOKEN_RP TOKEN_RCB TOKEN_LCB
	TOKEN_SEMICOLON TOKEN_COMMA
	
/*%token<strVal> TOKEN_STRINGCONST "string" TOKEN_ID "identifier"
%token<numVal> TOKEN_DECIMALCONST "DecNumber" TOKEN_HEXADECIMALCONST "hexNumber"
%token<boolVal> TOKEN_BOOLEANCONST "bool"
%token<charVal> TOKEN_CHARCONST "char"
%token
	TOKEN_CLASS "class"  TOKEN_PROGRAM "program" TOKEN_VOIDTYPE "void"
	TOKEN_INTTYPE "int" TOKEN_BOOLEANTYPE "boolean" TOKEN_ELSECONDITION "else"
	TOKEN_IFCONDITION "if" TOKEN_LOOP "for" TOKEN_RETURN "return"
	TOKEN_BREAKSTMT "break" TOKEN_CONTINUESTMT "continue"
	TOKEN_CALLOUT "callout" TOKEN_MAINFUNC "main"
*/
/*	
%left arith_op
%left cond_op
%left eq_op
%left rel_op
*/
		
%left TOKEN_ASSIGNOP_ASSIGN TOKEN_ASSIGNOP_ADDITIONASSIGN TOKEN_ASSIGNOP_SUBTRACTIONASSIGN
%left TOKEN_CONDITIONOP_OR
%left TOKEN_CONDITIONOP_AND
%nonassoc TOKEN_EQUALITYOP_EQ TOKEN_EQUALITYOP_NOTEQ
%nonassoc TOKEN_RELATIONOP_L TOKEN_RELATIONOP_LEQ TOKEN_RELATIONOP_S TOKEN_RELATIONOP_SEQ
%left TOKEN_ARITHMATICOP_PLUS TOKEN_ARITHMATICOP_MINUS
%left TOKEN_ARITHMATICOP_MULT TOKEN_ARITHMATICOP_DIVISION TOKEN_ARITHMATICOP_REMAIN
%right TOKEN_LOGICOP UMINUS
%left TOKEN_LB TOKEN_RB
%left TOKEN_LP TOKEN_RP

%start program

%%
program: 	TOKEN_CLASS TOKEN_PROGRAMCLASS TOKEN_LCB field main_method method TOKEN_RCB {cout << "parse" << endl; }
		;
		
arr_id:	TOKEN_LB int_literal TOKEN_RB
		| /**/		
		;
		
field_type: 	id arr_id
		;
			
field_name:	field_type
		| field_name TOKEN_COMMA field_type
		;		
				
field_decl:	type field_name TOKEN_SEMICOLON
		;
		
field:		field field_decl
		| /*empty*/		
		;
		
return_type:	type
		| TOKEN_VOIDTYPE
		;
		
funcname:	id
		;

funcargs6:	type id TOKEN_COMMA type id TOKEN_COMMA type id TOKEN_COMMA type id
		;

funcargs5:	funcargs6
		| type id TOKEN_COMMA type id TOKEN_COMMA type id
		;
		
funcargs4:	funcargs5
		| type id TOKEN_COMMA type id
		;		
		
funcargs3:	funcargs4
		| type id		
		;
	
funcargs2:	funcargs3
		| /**/
		;	

funcargs:	TOKEN_LP funcargs2 TOKEN_RP
		;
		
funcbody:	block
		;
				
method_decl:	return_type funcname funcargs funcbody
		;		
		
main_method:	return_type TOKEN_MAINFUNC TOKEN_LP TOKEN_RP funcbody		
		;
		
method:	method method_decl
		| /**/
		;
		
varlist:	id
		| varlist TOKEN_COMMA id
		;

type:		TOKEN_INTTYPE
		| TOKEN_BOOLEANTYPE		
		;
		
var_decl:	type varlist
		;	
		
varDec:	varDec var_decl
		| /**/
		;
		
else_block:	TOKEN_ELSECONDITION block
		| /**/
		;		
		
ifstmt:	TOKEN_IFCONDITION TOKEN_LP expr TOKEN_RP block else_block
		;
		
forstmt:	TOKEN_LOOP id TOKEN_ASSIGNOP_ASSIGN expr TOKEN_COMMA expr block
		;		
/*		
return_val:	expr
		| 
		;		
*/

returnstmt:	TOKEN_RETURN TOKEN_SEMICOLON
		| TOKEN_RETURN expr TOKEN_SEMICOLON
		;
/*				
returnstmt:	TOKEN_RETURN return_val
		;*/
		
statment:	location assign_op expr TOKEN_SEMICOLON
		| method_call TOKEN_SEMICOLON
		| ifstmt
		| forstmt 
		| returnstmt 
		| TOKEN_BREAKSTMT TOKEN_SEMICOLON
		| TOKEN_CONTINUESTMT TOKEN_SEMICOLON
		| block
		;		
	
stmt:		stmt statment
		| /**/
		;		
		
block:		TOKEN_LCB varDec stmt TOKEN_RCB		
		;
		
assign_op:	TOKEN_ASSIGNOP_ASSIGN  
		| TOKEN_ASSIGNOP_ADDITIONASSIGN
		| TOKEN_ASSIGNOP_SUBTRACTIONASSIGN
		;
		
method_name:	id
		;		
		
callout_arg:	expr
		| string_literal
		;		
		
callout_list:	callout_arg
		| callout_list TOKEN_COMMA callout_arg
		;		
		
call_argu: 	TOKEN_COMMA callout_list
		| /**/	
		;
		
arg_list4:	expr TOKEN_COMMA expr TOKEN_COMMA expr TOKEN_COMMA expr
		;		
		
arg_list3:	arg_list4
		| expr TOKEN_COMMA expr TOKEN_COMMA expr		
		;
		
arg_list2:	arg_list3
		| expr TOKEN_COMMA expr		
		;
		
arg_list1:	arg_list2
		| expr
		;

arg_list:	arg_list1
		| /**/
		;		
		
method_call:	method_name TOKEN_LP arg_list TOKEN_RP
		| TOKEN_CALLOUT TOKEN_LP string_literal call_argu TOKEN_RP
		;
		
array_id:	TOKEN_LB expr TOKEN_RB
		| /**/
		;		
		
location:	id array_id
		;
/*
expr:		location
		| method_call
		| literal
		| expr bin_op expr
		| term
		;*/
		
expr:		location
		| method_call
		| literal
		| term
		| expr TOKEN_ARITHMATICOP_PLUS expr
		| expr TOKEN_ARITHMATICOP_MINUS expr  	
		| expr TOKEN_ARITHMATICOP_MULT expr 	
		| expr TOKEN_ARITHMATICOP_DIVISION expr 	
		| expr TOKEN_ARITHMATICOP_REMAIN expr 	
		| expr TOKEN_RELATIONOP_SEQ expr 	
		| expr TOKEN_RELATIONOP_LEQ expr 	
		| expr TOKEN_RELATIONOP_S expr 	
		| expr TOKEN_RELATIONOP_L expr 	
		| expr TOKEN_EQUALITYOP_EQ expr  
		| expr TOKEN_EQUALITYOP_NOTEQ expr 
		| expr TOKEN_CONDITIONOP_AND expr
		| expr TOKEN_CONDITIONOP_OR expr
		;

term:		TOKEN_LP expr TOKEN_RP
		| TOKEN_LOGICOP expr
		| '-' expr %prec UMINUS
		;
/*		
expr:		location
		| method_call
		| literal
		| expr bin_op expr
		| '-' expr
		| '!' expr
		| '(' expr ')'
		;
		
bin_op:	arith_op
		| rel_op
		| eq_op
		| cond_op
		;
		
arith_op:	'+'
		| '-'
		| '*'
		| '/'
		| '%'
		;
		
rel_op:	'<'
		| '>'
		| "<="
		| ">="
		;
		
eq_op:		"=="
		| "!="
		;
		
cond_op: 	"&&"
		| "||"
		;
		*/
literal:	int_literal
		| char_literal
		| bool_literal
		;
		
id:		TOKEN_ID
		;
		
int_literal:	decimal_literal
		| hex_literal
		;
		
decimal_literal: TOKEN_DECIMALCONST																
		;
		
hex_literal:	TOKEN_HEXADECIMALCONST																
		;		
		
bool_literal:	TOKEN_BOOLEANCONST
		;
		
char_literal:	TOKEN_CHARCONST
		;
		
string_literal: TOKEN_STRINGCONST
		;
								
%%

int main(){
  FILE *myfile = fopen("sample.file", "r");
  // Make sure it is valid:
  if (!myfile) {
    cout << "I can't open a.snazzle.file!" << endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  
  yyparse();
  return 0;
}

int yyerror(const char* message){
	printf("%s\n", message);
	return 0;
}

