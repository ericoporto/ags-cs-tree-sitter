# AGS Script Tree Sitter Parser

This is an experimental project. The general idea is to reuse the AGS Script Tree
Sitter parser generated by Edmundito, add C# bindings using SWIG and build it
for multiplatform (Windows/MacOS/Linux) using CMake.

This project is largely inspired by the [python java tree sitter parser here](https://github.com/ericoporto/python-tree-sitter). The cmake parts are made with code from the [tree-sitter-cmake project here](https://github.com/Symbitic/tree-sitter-cmake), but code has been heavily updated to work with latest tree-sitter.

## Useful references

The readings below provide useful information.

- https://log.paulbetts.org/the-bait-and-switch-pcl-trick/
- https://github.com/xamcat/mobcat-samples/tree/master/cpp_with_xamarin
- https://github.blog/2016-02-01-working-with-submodules/
- http://www.swig.org/Doc3.0/SWIG.html#output
- http://www.swig.org/Doc3.0/CSharp.html
- https://tree-sitter.github.io/tree-sitter/using-parsers
