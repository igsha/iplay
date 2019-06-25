cmake_minimum_required(VERSION 3.12)
project(iplay
    VERSION 0.0.3
    LANGUAGES NONE
    DESCRIPTION "Interactive player for terminal"
    HOMEPAGE_URL "https://github.com/igsha/iplay"
)

configure_file(src/iplay.in iplay @ONLY)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/iplay DESTINATION bin)
install(DIRECTORY lib/ DESTINATION lib/)

list(APPEND CPACK_GENERATOR TGZ)
set(CPACK_SYSTEM_NAME "all")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "all")
set(CPACK_PACKAGE_CONTACT "igsha")
set(CPACK_DEBIAN_PACKAGE_DEPENDS
    "fzy (>= 0.9),
    httpie (>= 0.9.8),
    bash (>= 4.4),
    openssl (>= 1.0.2s),
    libxml2-utils (>= 2.9.4),
    silversearcher-ag (>= 2.1.0),
    mpv (>= 0.27.2),
    youtube-dl (>= 2018.03.14),
    jq (>= 1.5)"
)
include(CPack)
