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
  tree-sitter/src/compiler/build_tables/lex_item.cc
  tree-sitter/src/compiler/build_tables/lex_item_transitions.cc
  tree-sitter/src/compiler/build_tables/lex_table_builder.cc
  tree-sitter/src/compiler/build_tables/lookahead_set.cc
  tree-sitter/src/compiler/build_tables/parse_item.cc
  tree-sitter/src/compiler/build_tables/parse_item_set_builder.cc
  tree-sitter/src/compiler/build_tables/parse_table_builder.cc
  tree-sitter/src/compiler/build_tables/property_table_builder.cc
  tree-sitter/src/compiler/build_tables/rule_can_be_blank.cc
  tree-sitter/src/compiler/compile.cc
  tree-sitter/src/compiler/generate_code/c_code.cc
  tree-sitter/src/compiler/generate_code/property_table_json.cc
  tree-sitter/src/compiler/lex_table.cc
  tree-sitter/src/compiler/log.cc
  tree-sitter/src/compiler/parse_json.cc
  tree-sitter/src/compiler/parse_table.cc
  tree-sitter/src/compiler/precedence_range.cc
  tree-sitter/src/compiler/prepare_grammar/expand_repeats.cc
  tree-sitter/src/compiler/prepare_grammar/expand_tokens.cc
  tree-sitter/src/compiler/prepare_grammar/extract_choices.cc
  tree-sitter/src/compiler/prepare_grammar/extract_simple_aliases.cc
  tree-sitter/src/compiler/prepare_grammar/extract_tokens.cc
  tree-sitter/src/compiler/prepare_grammar/flatten_grammar.cc
  tree-sitter/src/compiler/prepare_grammar/intern_symbols.cc
  tree-sitter/src/compiler/prepare_grammar/normalize_rules.cc
  tree-sitter/src/compiler/prepare_grammar/parse_regex.cc
  tree-sitter/src/compiler/prepare_grammar/prepare_grammar.cc
  tree-sitter/src/compiler/prepare_grammar/token_description.cc
  tree-sitter/src/compiler/rule.cc
  tree-sitter/src/compiler/syntax_grammar.cc
  tree-sitter/src/compiler/rules/character_set.cc
  tree-sitter/src/compiler/rules/choice.cc
  tree-sitter/src/compiler/rules/metadata.cc
  tree-sitter/src/compiler/rules/repeat.cc
  tree-sitter/src/compiler/rules/seq.cc
  tree-sitter/src/compiler/util/string_helpers.cc
  tree-sitter/src/runtime/get_changed_ranges.c
  tree-sitter/src/runtime/language.c
  tree-sitter/src/runtime/lexer.c
  tree-sitter/src/runtime/node.c
  tree-sitter/src/runtime/stack.c
  tree-sitter/src/runtime/parser.c
  tree-sitter/src/runtime/subtree.c
  tree-sitter/src/runtime/tree.c
  tree-sitter/src/runtime/tree_cursor.c
  tree-sitter/src/runtime/utf16.c
  utf8proc/utf8proc.c
  json-parser/json.c
)

target_include_directories(Tree-Sitter
  PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/src>
  PUBLIC
    $<INSTALL_INTERFACE:include>
)


add_library(Tree-Sitter-ags-script tree-sitter-ags-script/src/parser.c)
target_link_libraries(Tree-Sitter-ags-script INTERFACE Tree-Sitter)
target_include_directories(Tree-Sitter-ags-script PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/tree-sitter/include>
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
    tree-sitter/include/tree_sitter/compiler.h
    tree-sitter/include/tree_sitter/parser.h
    tree-sitter/include/tree_sitter/runtime.h
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
