cmake_minimum_required(VERSION 3.13)

project(latino-curses)

if (WIN32)
    #
    # Grupo de variables/comandos
    # set(PDC_DLL_BUILD                                   ON)
    # set(PDC_NCMOUSE                                     ON)
    # set(CMAKE_MODULE_PATH                               "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/PDCursesMod/cmake")
    # set(CURSES_LIBRARY                                  "${CMAKE_SOURCE_DIR}/build/PDCursesMod/wincon/${CMAKE_BUILD_TYPE}")
    # set(CURSES_INCLUDE_PATH                             "${CMAKE_SOURCE_DIR}/PDCursesMod")
    # set(CURSES_PATH                                     ${CMAKE_CURRENT_SOURCE_DIR}         CACHE FILEPATH "Ruta de librerias de Curses_WIN32" )
    set(CMAKE_INSTALL_PREFIX "C:/Program Files")
    set(LATINO_PATH                                     "${CMAKE_INSTALL_PREFIX}/Latino"    CACHE FILEPATH "Ruta de instalacion de Latino INGLES")


    #
    # Arquitectura del build
    set(TARGET_ARCH_REGEX                               "^.*-march[= ]([^ ]+).*$")
    string(REGEX MATCH                                  "${TARGET_ARCH_REGEX}" TARGET_ARCH_MATCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})

    if(TARGET_ARCH_MATCH)
        string(REGEX REPLACE                            "${TARGET_ARCH_REGEX}" "\\1" TARGET_ARCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})
    else()
        set(TARGET_ARCH                                 ${CMAKE_HOST_SYSTEM_PROCESSOR})
    endif()
    message(STATUS "TARGET_ARCH .................. ${TARGET_ARCH}")


    #
    # Define el nombre de la libreria de PDCursesMod
    # if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    #     set(LIB_PDCursesMod                     "pdcursesd")
    # else()
    #     set(LIB_PDCursesMod                     "pdcurses")
    # endif()


    #
    # Directorios
    # add_subdirectory                                    (PDCursesMod)

    # include_directories                                 (PDCursesMod)
    # include_directories                                 (PDCursesMod/sdl2)
    # include_directories                                 (PDCursesMod/common)
    # include_directories                                 (PDCursesMod/wincon)
    include_directories                                 (${CMAKE_SOURCE_DIR}/PDCursesMod)
    include_directories                                 (${LATINO_PATH}/include)


    link_directories                                    (${LATINO_PATH}/lib ${CMAKE_SOURCE_DIR}/PDCursesMod/compiled)
    add_library                                         (${PROJECT_NAME} SHARED src/latino-curses.c)
    target_link_libraries                               (${PROJECT_NAME} latino pdcurses)

    configure_file(${CMAKE_SOURCE_DIR}/PDCursesMod/compiled/pdcurses.dll ${CMAKE_CURRENT_BINARY_DIR}/pdcurses.dll COPYONLY)
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