 %module example
 %{
 /* Includes the header in the wrapper code */
 #include "tree-sitter/parser.h"
 %}
 
 /* Parse the header file to generate wrappers */
 %include "tree-sitter/parser.h"
