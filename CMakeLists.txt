cmake_minimum_required(VERSION 3.13)

project(latino-curses)

if (WIN32)
    #
    # Arquitectura del build
    set(TARGET_ARCH_REGEX                               "^.*-march[= ]([^ ]+).*$")
    string(REGEX MATCH                                  "${TARGET_ARCH_REGEX}" TARGET_ARCH_MATCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})

    if(TARGET_ARCH_MATCH)
        string(REGEX REPLACE                            "${TARGET_ARCH_REGEX}" "\\1" TARGET_ARCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})
    else()
        set(TARGET_ARCH                                 ${CMAKE_HOST_SYSTEM_PROCESSOR})
    endif()
    message(STATUS "ARQUITECTURA .................. ${TARGET_ARCH}")


    set(CMAKE_INSTALL_PREFIX "C:/Program Files")
    message(STATUS "DIRECTORIO .................... ${CMAKE_INSTALL_PREFIX}")

    set(CURSES_PATH ${CMAKE_CURRENT_SOURCE_DIR}         CACHE FILEPATH "Ruta de librerias de Curses_WIN32" )
    set(LATINO_PATH "${CMAKE_INSTALL_PREFIX}/Latino"    CACHE FILEPATH "Ruta de instalacion de Latino INGLES")

    include_directories                                 (${CURSES_PATH}/includes)
    include_directories                                 (${LATINO_PATH}/include)

    link_directories                                    (${LATINO_PATH}/lib)
    add_library                                         (${PROJECT_NAME} SHARED src/latino-curses.c)
    target_link_libraries                               (${PROJECT_NAME} latino)
else ()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE -Wall -std=c11 -rdynamic -ldl -fPIC")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} -D_GNU_SOURCE -g -O0 -Wall -std=c11 -rdynamic-ldl -fPIC")

    if(APPLE)
        link_directories                                ("/usr/local/lib")
        include_directories                             ("/usr/local/include")
    else()
        # UNIX
        include_directories                             (include)
    endif()

    add_library                                         (${PROJECT_NAME} SHARED src/latino-curses.c)
    target_link_libraries                               (${PROJECT_NAME} liblatino_static libcurses readline)

    INSTALL(TARGETS latino-curses DESTINATION /usr/local/lib)
endif ()