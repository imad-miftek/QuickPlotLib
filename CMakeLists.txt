# SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.16)
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)

project(QuickPlotLib VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wextra -Wpedantic -fno-visibility-inlines-hidden)
endif()

option(ENABLE_STUB_GENERATION "Enable .pyi stub generation (defaults to on)" ON)

if(NOT INSTALL_SUBPATH)
    set(INSTALL_SUBPATH
        ${CMAKE_INSTALL_LIBDIR}/qml
        CACHE STRING
        "Install subpath (defaults to lib/qml)"
    )
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.10)

add_subdirectory(QuickPlotLib)
