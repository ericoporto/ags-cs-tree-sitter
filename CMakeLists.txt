cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

include(CMakePackageConfigHelpers)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

set(CMAKE_BUILD_TYPE_INIT "Release")

if(NOT DEFINED PROJECT_NAME)
  set(SUBPROJECT TRUE)
endif()

project(tree-sitter-cmake)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter")
  find_package(Git QUIET REQUIRED)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} submodule init
    COMMAND ${GIT_EXECUTABLE} submodule update
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RESULT_VARIABLE ret
    OUTPUT_QUIET
    ERROR_QUIET
  )
  if(NOT ${ret} MATCHES 0)
    message(FATAL_ERROR "Error checking out git submodules")
  endif()
endif()

add_library(Tree-Sitter
  tree-sitter/lib/src/alloc.h
  tree-sitter/lib/src/array.h
  tree-sitter/lib/src/atomic.h
  tree-sitter/lib/src/bits.h
  tree-sitter/lib/src/clock.h
  tree-sitter/lib/src/error_costs.h
  tree-sitter/lib/src/get_changed_ranges.c
  tree-sitter/lib/src/get_changed_ranges.h
  tree-sitter/lib/src/language.c
  tree-sitter/lib/src/language.h
  tree-sitter/lib/src/length.h
  tree-sitter/lib/src/lexer.c
  tree-sitter/lib/src/lexer.h
  tree-sitter/lib/src/lib.c
  tree-sitter/lib/src/node.c
  tree-sitter/lib/src/parser.c
  tree-sitter/lib/src/point.h
  tree-sitter/lib/src/query.c
  tree-sitter/lib/src/reduce_action.h
  tree-sitter/lib/src/reusable_node.h
  tree-sitter/lib/src/stack.c
  tree-sitter/lib/src/stack.h
  tree-sitter/lib/src/subtree.c
  tree-sitter/lib/src/subtree.h
  tree-sitter/lib/src/tree.c
  tree-sitter/lib/src/tree_cursor.c
  tree-sitter/lib/src/tree_cursor.h
  tree-sitter/lib/src/tree.h
  tree-sitter/lib/src/unicode.h
  tree-sitter/lib/src/unicode/ptypes.h
  tree-sitter/lib/src/unicode/umachine.h
  tree-sitter/lib/src/unicode/urename.h
  tree-sitter/lib/src/unicode/utf.h
  tree-sitter/lib/src/unicode/utf8.h
  tree-sitter/lib/src/unicode/utf16.h
  utf8proc/utf8proc.c
  api_wrap.c
)

target_include_directories(Tree-Sitter
  PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/lib/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/lib/src>
  PUBLIC
    $<INSTALL_INTERFACE:include>
)


add_library(Tree-Sitter-ags-script 
  tree-sitter-ags-script/src/parser.c
  tree-sitter-ags-script/src/parser_wrap.c)
target_link_libraries(Tree-Sitter-ags-script INTERFACE Tree-Sitter)
target_include_directories(Tree-Sitter-ags-script PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter-ags-script/src>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/lib/include>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)
add_dependencies(Tree-Sitter-ags-script Tree-Sitter)

# Make aliases the same as exported lib names. Useful when embedding.
add_library(Tree-Sitter::Tree-Sitter ALIAS Tree-Sitter)
add_library(Tree-Sitter::Tree-Sitter-ags-script ALIAS Tree-Sitter-ags-script)

if(NOT SUBPROJECT)
  # Only install when built as top-level project.
  if(WIN32)
    set(CMAKE_INSTALL_DIR "CMake")
  else()
    set(CMAKE_INSTALL_DIR "lib/cmake/Tree-Sitter")
  endif()

  install(FILES
    tree-sitter/lib/include/tree_sitter/compiler.h
    tree-sitter/lib/include/tree_sitter/parser.h
    tree-sitter/lib/include/tree_sitter/runtime.h
    include/tree_sitter/langs.h
    DESTINATION include/tree_sitter
  )
  
  install(TARGETS Tree-Sitter EXPORT Tree-Sitter DESTINATION lib)
  
  install(EXPORT Tree-Sitter
    DESTINATION ${CMAKE_INSTALL_DIR}
    NAMESPACE Tree-Sitter::
    FILE Tree-Sitter-targets.cmake
  )
  
  install(TARGETS Tree-Sitter-ags-script EXPORT ags-script DESTINATION lib)
  install(EXPORT ags-script
    DESTINATION ${CMAKE_INSTALL_DIR}
    NAMESPACE Tree-Sitter::
    FILE Tree-Sitter-ags-script-targets.cmake
  )
  
  install(FILES tree-sitter-config.cmake DESTINATION ${CMAKE_INSTALL_DIR})
endif()
