cmake_minimum_required(VERSION 3.16)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(KF5_MIN_VERSION "5.68.0")

project("WallpaperEngineKde")

set(CMAKE_SKIP_INSTALL_ALL_DEPENDENCY true)

option(USE_PLASMAPKG "Use plasmapkg2 to install plugin to user'home" ${USE_PLASMAPKG})
option(SKIP_SUBMODULE_UPDATE "Skipping git submodule update" ${SKIP_SUBMODULE_UPDATE})

set(DEFAULT_BUILD_TYPE "RelWithDebInfo")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
endif()

if(NOT SKIP_SUBMODULE_UPDATE)
    find_package(Git QUIET)
    if(GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
        option(GIT_SUBMODULE "Check submodules during build" ON)
        if(GIT_SUBMODULE)
            message(STATUS "Submodule update")
            execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init
                            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                            RESULT_VARIABLE GIT_SUBMOD_RESULT)
            if(NOT GIT_SUBMOD_RESULT EQUAL "0")
                message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMOD_RESULT}, please checkout submodules")
            endif()
        endif()
    endif()
endif()

IF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  SET(CMAKE_INSTALL_PREFIX /usr CACHE PATH "set prefix to /usr" FORCE)
ENDIF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

if(NOT OpenGL_GL_PREFERENCE) 
set(OpenGL_GL_PREFERENCE "GLVND")
endif()

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_MODULE_PATH})
include(KDEInstallDirs)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    Package
    Plasma
)

if(NOT USE_PLASMAPKG)
    plasma_install_package(plugin com.github.casout.wallpaperEngineKde wallpapers wallpaper)
else()
    find_program(KPACKAGETOOL5 NAMES kpackagetool5)
    if(${KPACKAGETOOL5} STREQUAL "KPACKAGETOOL5-NOTFOUND")
        message(FATAL_ERROR "kpackagetool5 not found")
    endif()

    add_custom_target(install_pkg
        COMMAND /bin/sh -c "${KPACKAGETOOL5} -i ./plugin 2>/dev/null || ${KPACKAGETOOL5} -u ./plugin"
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        VERBATIM
    )
endif()

set(QMLPLUGIN_URI "com.github.catsout.wallpaperEngineKde")
string(REPLACE "." "/" QMLPLUGIN_INSTALL_URI ${QMLPLUGIN_URI})

add_subdirectory(src)
