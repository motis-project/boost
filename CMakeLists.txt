project(boost)
cmake_minimum_required(VERSION 3.17)

include(cmake/pkg.cmake)

add_library(boost INTERFACE)
target_include_directories(boost SYSTEM INTERFACE .)
target_compile_definitions(boost INTERFACE
    BOOST_BIND_GLOBAL_PLACEHOLDERS=1
    BOOST_ALL_NO_LIB=1
)
if (WIN32)
    target_compile_definitions(boost INTERFACE
        BOOST_THREAD_BUILD_LIB=1
        BOOST_THREAD_WIN32=1
    )
endif()

file(GLOB libs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/libs ${CMAKE_CURRENT_SOURCE_DIR}/libs/*)
list(REMOVE_ITEM libs ".DS_Store")
foreach(lib ${libs})
    file(GLOB_RECURSE boost-${lib}-files ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/**.cpp)

    if (WIN32)
        file(GLOB unwanted-system-specific ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/src/pthread/*.cpp)
    else()
        file(GLOB unwanted-system-specific ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/src/win32/*.cpp)
    endif()

    file(GLOB unwanted
        ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/*/bzip2.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/*/lzma.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/*/zstd.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/src/gregorian/greg_weekday.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/libs/${lib}/src/gregorian/date_generators.cpp
    )
    list(LENGTH unwanted unwanted-length)
    if (unwanted-length)
        list(REMOVE_ITEM boost-${lib}-files ${unwanted})
    endif()
    if (unwanted-system-specific)
        list(REMOVE_ITEM boost-${lib}-files ${unwanted-system-specific})
    endif()
    add_library(boost-${lib} ${boost-${lib}-files})
    target_link_libraries(boost-${lib} boost)
    if (MSVC)
        target_compile_options(boost-${lib} PRIVATE /w)
    else()
        target_compile_options(boost-${lib} PRIVATE -w)
    endif()
endforeach()

target_link_libraries(boost-iostreams zlibstatic)
