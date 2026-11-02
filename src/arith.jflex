// A JFlex spec has three sections split by %% lines, we skip section 1 because that's the where we import something, but in our project, we dont.

%%  // SECTION 2: OPTIONS AND MACROS
// OPTIONS
%public                                        // Makes the generated class public, so Main can use it
%class ArithScanner                            // Names the generated class "ArithScanner.java"
%unicode                                       // Lets the scanner read Unicode text (the input is UTF-8)
%line                                          // tells JFlex to count which line the scanner is on. JFlex creates a variable yyline and updates it every time it passes a newline. It starts at 0, but we print yyline + 1.
%column                                        // tells JFlex to count where on the line the scanner is. JFlex creates a variable yycolumn that holds the column where the current token starts. yycolumn starts at 0, but we print yycolumn + 1.
%type String                                   // Makes yylex() return a String instead of the default int. At end of input it returns null

// MACROS (Regular Expression): NAME = RE
DIGIT   = [0-9]                                // one character from 0 to 9. e.g. 1, 2, 3, 4, 5
INTEGER = {DIGIT}+                             // one or more digits. e.g. 1, 2, 11, 10, 18, 168
DECIMAL = {DIGIT}+ "." {DIGIT}+
LETTER  = [a-zA-Z_]
IDENTIFIER = {LETTER} ({LETTER} | {DIGIT})*    // first char must be LETTER, then the rest can be either NOTHING, LETTER or DIGIT. e.g. a, qty_2, _x 

ASSIGN  = "="
PLUS    = "+"
MINUS   = "-"
STAR    = "*"
SLASH = "/"
GT      = ">"
GE      = ">="
LPAREN  = "("
RPAREN  = ")"
SEMICOLON = ";" 

WS      = [ \t\r\n]+                           // one or more of: space, tab, carriage return, newline.

// %{ ... %}: Everything inside is copied unchanged into the generated class.
%{
  private static final String FMT = "%-12s %-12s %-6s %s";

  public static String header() {
    return String.format(FMT, "TOKEN TYPE", "LEXEME", "LINE", "COLUMN");
  }

  private String tok(String type) {
    return String.format(FMT, type, yytext(), yyline + 1, yycolumn + 1);
  }
%}

%%  // SECTION 3: RULES (earlier, wins ties)
{INTEGER}     { return tok("INTEGER"); }
{DECIMAL}     { return tok("DECIMAL"); }
{IDENTIFIER}  { return tok("IDENTIFIER"); }

{ASSIGN}      { return tok("ASSIGN"); }
{PLUS}        { return tok("PLUS"); }
{MINUS}       { return tok("MINUS"); }
{STAR}        { return tok("STAR"); }
{SLASH}       { return tok("SLASH"); }
{GT}          { return tok("GT"); }
{GE}          { return tok("GE"); }
{LPAREN}      { return tok("LPAREN"); }
{RPAREN}      { return tok("RPAREN"); }
{SEMICOLON}   { return tok("SEMICOLON"); }

{WS}          { /* skip whitespace */ }            // no return, so scanner discards the match and moves on, and no row is printed
[^]           { return tok("ERROR"); }             // any single character at all