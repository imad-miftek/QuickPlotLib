# SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
# SPDX-License-Identifier: MIT

set(QPL_QML_FILES
    GraphArea.qml
    Axis.qml
    Graph.qml
)

add_library(QuickPlotLibPlugin SHARED Plugin.cpp)
target_link_libraries(QuickPlotLibPlugin PRIVATE Qt6::Gui)

qt_add_qml_module(QuickPlotLib
    URI QuickPlotLib
    SHARED
    VERSION 1.0
    QML_FILES ${QPL_QML_FILES}
    PLUGIN_TARGET QuickPlotLibPlugin
    NO_GENERATE_PLUGIN_SOURCE
    NO_PLUGIN_OPTIONAL
    DEPENDENCIES QtQuick
    SOURCES QuickPlotLib.hpp Global.hpp
)

set_property(
    TARGET QuickPlotLib
    PROPERTY LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)
set_property(
    TARGET QuickPlotLib
    PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_definitions(QuickPlotLib PRIVATE QPL_LIBRARY)
target_compile_definitions(
    QuickPlotLib
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
target_link_libraries(QuickPlotLib PRIVATE Qt6::Quick)

set(QPL_PYTHON_FILES
    __init__.py
    py.typed
    _version.py
)

foreach(PYTHON_FILE ${QPL_PYTHON_FILES})
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_FILE}
        COMMAND
            ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_FILE}
            ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_FILE}
        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${PYTHON_FILE}
    )
endforeach()

list(TRANSFORM QPL_PYTHON_FILES PREPEND "${CMAKE_CURRENT_BINARY_DIR}/")
add_custom_target(QuickPlotLibPythonFiles ALL DEPENDS ${QPL_PYTHON_FILES})

# Copy qmldir to source directory for editable installs
add_custom_command(
    TARGET QuickPlotLib POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_BINARY_DIR}/qmldir
        ${CMAKE_CURRENT_SOURCE_DIR}/qmldir
    COMMENT "Copying qmldir to source directory"
)

# Copy qmltypes to source directory for editable installs
add_custom_command(
    TARGET QuickPlotLib POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_BINARY_DIR}/QuickPlotLib.qmltypes
        ${CMAKE_CURRENT_SOURCE_DIR}/QuickPlotLib.qmltypes
    COMMENT "Copying qmltypes to source directory"
)

# Copy library DLLs to source directory for editable installs
add_custom_command(
    TARGET QuickPlotLib POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:QuickPlotLib>
        ${CMAKE_CURRENT_SOURCE_DIR}/$<TARGET_FILE_NAME:QuickPlotLib>
    COMMENT "Copying QuickPlotLib library to source directory"
)

add_custom_command(
    TARGET QuickPlotLibPlugin POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:QuickPlotLibPlugin>
        ${CMAKE_CURRENT_SOURCE_DIR}/$<TARGET_FILE_NAME:QuickPlotLibPlugin>
    COMMENT "Copying QuickPlotLibPlugin to source directory"
)

install(
    TARGETS QuickPlotLib
    RUNTIME DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib
    LIBRARY DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib
)
install(
    TARGETS QuickPlotLibPlugin
    RUNTIME DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib
    LIBRARY DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib
)
install(FILES ${QPL_QML_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib)
install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/qmldir
        ${CMAKE_CURRENT_BINARY_DIR}/QuickPlotLib.qmltypes
    DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib
)
install(FILES ${QPL_PYTHON_FILES} DESTINATION ${INSTALL_SUBPATH}/QuickPlotLib)
