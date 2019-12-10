%{
  open ExternalGrammar
%}

/* Tokens */
%token EOF
%token PLUS MINUS MULTIPLY DIVIDE MODULUS
%token LT LTE GT GTE EQUAL_TO NEQ EQUAL
%token AND OR NOT
%token LPAREN RPAREN
%token IF THEN ELSE TRUE FALSE IN
%token SEMICOLON COMMA
%token LET OBSERVE FLIP LBRACE RBRACE 

%token <float>  FLOAT_LIT
%token <string> MODULE_LIT
%token <string> ID
%token <string> GENERIC

/* associativity rules */
%left OR
%left AND
%left NOT
%left LTE GTE LT GT NEQ
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULUS
%left NEG
/* entry point */

%start program
%type <ExternalGrammar.eexpr> program

%%


expr:
    | LPAREN expr RPAREN { $2 }
    | TRUE { True }
    | FALSE { False }
    | expr AND expr { And($1, $3) }
    | expr OR expr { Or($1, $3) }
    | NOT expr { Not($2) }
    | FLIP FLOAT_LIT { Flip($2) }
    | OBSERVE expr { Observe($2) }
    | IF expr THEN expr ELSE expr { Ite($2, $4, $6) }
    | LET ID EQUAL expr IN expr { Let($2, $4, $6) }

program:
  expr EOF { $1 }

