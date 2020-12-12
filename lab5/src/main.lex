%option noyywrap
%{
    #include"common.h"
    #include"main.tab.hh"
%}

INTEGER [0-9]+
ID [[:alpha:]_][[:alpha:][:digit:]_]*
STRING \".*\"
CHAR \'.?\'
EOL (\r\n|\n|\r)
WHITE [[:blank:]]
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
%%

"int" return T_INT;
"bool" return T_BOOL;
"string" return T_STRING;
"char" return T_CHAR;
"void" return VOID;
"printf" return PRINTF;
"scanf" return SCANF;
"main" return MAIN;

"==" return EQUAL;
"!=" return NEQ;
"<=" return LEQ;
">=" return GEQ;
"<" return LT;
">" return GT;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"!" return NOT;
"=" return LOP_ASSIGN;
"||" return OR;
"&&" return AND;
"&" return LAND;
"+=" return ADD_ASSIGN;
"-=" return SUB_ASSIGN;
"*=" return MUL_ASSIGN;
"/=" return DIV_ASSIGN;
"++" return MADD;
"--" return MSUB;

";" return  SEMICOLON;
"," return COMMA;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;

"if" return S_IF;
"while" return S_WHILE;
"return" {
    TreeNode *node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_RETURN;
    yylval = node;
    return S_RETURN;
    }
"for" return S_FOR;

"true" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = false;
    yylval = node;
    return FALSE;
}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}

{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = yytext;
    yylval = node;
    return STRING;
}

{ID} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}
{BLOCKCOMMENT}
{LINECOMMENT}
{WHITE} 
{EOL} lineno++;

