message(STATUS ">>> Processing ......... *** ${PROJECT_NAME} ***")

set(PDCURSES_SRCDIR ${CMAKE_SOURCE_DIR}/PDCursesMod)
# set(PDCURSES_DIST ${CMAKE_INSTALL_PREFIX})
set(PDCURSES_DIST ${CMAKE_CURRENT_BINARY_DIR}/PDCursesMod/${PROJECT_NAME}/${CMAKE_BUILD_TYPE})

set(osdir ${PDCURSES_SRCDIR}/${PROJECT_NAME})

set(pdc_src_files
    ${osdir}/pdcclip.c
    ${osdir}/pdcdisp.c
    ${osdir}/pdcgetsc.c
    ${osdir}/pdckbd.c
    ${osdir}/pdcscrn.c
    ${osdir}/pdcsetsc.c
    ${osdir}/pdcutil.c
)

include_directories (..)
include_directories (${osdir})


if(WIN32 AND NOT WATCOM)
    include(dll_version)
    list(APPEND pdc_src_files ${CMAKE_CURRENT_BINARY_DIR}/version.rc)
    # message(STATUS "CMAKE_CURRENT_BINARY_DIR............................................. ${CMAKE_CURRENT_BINARY_DIR}")

    add_definitions(-D_WIN32 -D_CRT_SECURE_NO_WARNINGS)

    if(${TARGET_ARCH} STREQUAL "ARM" OR ${TARGET_ARCH} STREQUAL "ARM64")
        add_definitions(-D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE=1)
    endif()

    set(EXTRA_LIBS gdi32.lib winspool.lib shell32.lib ole32.lib comdlg32.lib advapi32.lib)
    set(WINCON_WINGUI_DEP_LIBS winmm.lib)
    set(SDL2_DEP_LIBRARIES version.lib winmm.lib imm32.lib)
elseif(WATCOM_WIN32)
    set(EXTRA_LIBS "")
    set(WINCON_WINGUI_DEP_LIBS winmm.lib)
    set(SDL2_DEP_LIBRARIES "dl")
else()
    set(EXTRA_LIBS "")
    set(WINCON_WINGUI_DEP_LIBS "")
    set(SDL2_DEP_LIBRARIES "dl")
endif()

if(PDC_BUILD_SHARED)
    set(PDCURSE_PROJ ${PROJECT_NAME}_pdcurses)
    add_library(${PDCURSE_PROJ} SHARED ${pdc_src_files} ${pdcurses_src_files})

    if(${PROJECT_NAME} STREQUAL "sdl2")
        if(PDC_WIDE)
            target_link_libraries(${PDCURSE_PROJ} ${EXTRA_LIBS}
                ${SDL2_LIBRARIES} ${SDL2_TTF_LIBRARY} ${FT2_LIBRARY} ${ZLIB_LIBRARY} 
                ${SDL2_DEP_LIBRARIES})
        else()
            target_link_libraries(${PDCURSE_PROJ} ${EXTRA_LIBS}
                ${SDL2_LIBRARIES} ${SDL2_DEP_LIBRARIES})
        endif()
    elseif((${PROJECT_NAME} STREQUAL "wincon") OR (${PROJECT_NAME} STREQUAL "wingui"))
        target_link_libraries(${PDCURSE_PROJ} ${EXTRA_LIBS} ${WINCON_WINGUI_DEP_LIBS})
    else()
        target_link_libraries(${PDCURSE_PROJ} ${EXTRA_LIBS})
    endif()

    install(TARGETS ${PDCURSE_PROJ}
        ARCHIVE DESTINATION ${PDCURSES_DIST}
        LIBRARY DESTINATION ${PDCURSES_DIST}
        RUNTIME DESTINATION ${PDCURSES_DIST} COMPONENT applications)
    set_target_properties(${PDCURSE_PROJ} PROPERTIES OUTPUT_NAME "pdcurses")
else()
    set(PDCURSE_PROJ ${PROJECT_NAME}_pdcursesstatic)
    add_library (${PDCURSE_PROJ} STATIC ${pdc_src_files} ${pdcurses_src_files})
    install (TARGETS ${PDCURSE_PROJ} ARCHIVE DESTINATION ${PDCURSES_DIST} COMPONENT applications)
    set_target_properties(${PDCURSE_PROJ} PROPERTIES OUTPUT_NAME "pdcursesstatic")
endif()

macro (demo_app dir targ)
    set(bin_name "${PROJECT_NAME}_${targ}")
    if(${targ} STREQUAL "tuidemo")
        set(src_files ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/tuidemo.c ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/tui.c)
    else()
        set(src_files ${CMAKE_CURRENT_SOURCE_DIR}/${dir}/${targ}.c)
    endif()

    add_executable(${bin_name} ${ARGV2} ${src_files})

    if((${PROJECT_NAME} STREQUAL "wincon") OR (${PROJECT_NAME} STREQUAL "wingui"))
        target_link_libraries(${bin_name} ${PDCURSE_PROJ} ${EXTRA_LIBS} ${WINCON_WINGUI_DEP_LIBS})
    else()
        target_link_libraries(${bin_name} ${PDCURSE_PROJ} ${EXTRA_LIBS})
    endif()

    add_dependencies(${bin_name} ${PDCURSE_PROJ})
    set_target_properties(${bin_name} PROPERTIES OUTPUT_NAME ${targ})

    install(TARGETS ${bin_name} RUNTIME DESTINATION ${PDCURSES_DIST} COMPONENT applications)
endmacro ()
