cmake_minimum_required(VERSION 3.4.3)

project(latino-curses)

if (WIN32)
    set(CURSES_PATH ${CMAKE_CURRENT_SOURCE_DIR}         CACHE FILEPATH "Ruta de librerias de NCurses_WIN32")
    set(LATINO_PATH "C:/Program Files/Latino"           CACHE FILEPATH "Ruta de instalacion de Latino INGLES")
#   set(LATINO_PATH "C:/Archivos de programa/Latino"    CACHE FILEPATH "Ruta de instalacion de Latino ESPAÑOL")

    include_directories(${CURSES_PATH}/includes)
    include_directories(${LATINO_PATH}/include)

    link_directories(${LATINO_PATH}/msvc/x64/include)
    add_library(${PROJECT_NAME} SHARED src/latino-curses.c)
else ()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE -Wall -std=c11 -rdynamic -ldl -fPIC")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} -D_GNU_SOURCE -g -O0 -Wall -std=c11 -rdynamic-ldl -fPIC")

    link_directories("/usr/lib")
    link_directories("/usr/local/lib")

    include_directories("/usr/local/include")
    add_library(latino-curses SHARED src/latino-curses.c)
    target_link_libraries(latino-curses liblatino_static libncurses readline)

    INSTALL(TARGETS latino-curses DESTINATION /usr/local/lib)
endif ()

# if (APPLE)
#     link_directories("/usr/local/lib")
#     link_directories("/usr/local/Cellar/readline/8.0.0/lib")
#
#     include_directories("/usr/local/include")
#     include_directories("/usr/local/Cellar/readline/8.0.0/include")
#
#     INSTALL(TARGETS latino-curses DESTINATION /usr/local/lib)
# endif ()