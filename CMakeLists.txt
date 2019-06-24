cmake_minimum_required(VERSION 3.12)
project(iplay VERSION 0.0.2 LANGUAGES NONE DESCRIPTION "Interactive player for terminal")

configure_file(src/iplay.in iplay @ONLY)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/iplay DESTINATION bin)
install(DIRECTORY src/ DESTINATION lib/)

list(APPEND CPACK_GENERATOR TGZ)
include(CPack)
