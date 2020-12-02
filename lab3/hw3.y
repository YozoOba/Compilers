
%{
/**
hw3.y
**/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}


%token NUMBER
%token ADD SUB MUL DIV
%token LB RB
%left ADD SUB
%left MUL DIV RB
%right UMNUS LB

%%

lines : lines expr ';' { printf("%f\n",$2);}
      | lines ';'
      |
      ;

expr : expr ADD expr { $$ = $1 + $3; }
     | expr SUB expr { $$ = $1 - $3; }
     | expr MUL expr { $$ = $1 * $3; }
     | expr DIV expr { $$ = $1 / $3; }
     | LB expr RB  { $$ = $2; }
     | '-' expr %prec UMNUS { $$ = -$2; }
     | NUMBER { $$ = $1; }
     ; 



%%
 // programs section

int yylex()
{
// place your token retrieving code here
   int t;

   while(1){
    t=getchar();
    if (t ==' ' || t == '\t' || t == '\n') 
            {
             //do nothing
            }else if (isdigit(t))
              { yylval = 0;
                while (isdigit(t))
                 {     
             yylval = yylval * 10 + t - '0';
             t = getchar(); 
                  } 
         ungetc(t,stdin);
         return NUMBER;
               }
          else    
         {switch(t){
	case '+':
		return ADD;
	case '-' :
		return SUB;
	case '*':
		return MUL;
	case '/':
		return DIV;
	case '(':
		return LB;
	case ')':
		return RB;		
	default :
		return t;
	}

                  }
            }
}

int main(void)
{
     yyin = stdin;
     do {
              yyparse();
        }
     while(!feof(yyin));
    return 0;
}

void yyerror(const char* s)
{
          fprintf(stderr, "Parse error:%s\n",s);
          exit(1);
} 
