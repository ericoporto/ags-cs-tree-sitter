 %module example
 %{
 /* Includes the header in the wrapper code */
 #include "parser.h"
 %}
 
 /* Parse the header file to generate wrappers */
 %include "parser.h"
