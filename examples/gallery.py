# SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
# SPDX-License-Identifier: MIT

import pathlib
import sys

from PySide6 import QtCore, QtGui, QtQml, QtQuickControls2

EXAMPLES_DIR = pathlib.Path(__file__).parent

import QuickPlotLib

if __name__ == "__main__":
    QtQuickControls2.QQuickStyle.setStyle("Basic")
    QtQml.QQmlDebuggingEnabler.enableDebugging(True)
    app = QtGui.QGuiApplication(sys.argv)
    engine = QtQml.QQmlApplicationEngine()
    engine.addImportPath(QuickPlotLib.QML_IMPORT_PATH)

    engine.load(EXAMPLES_DIR / "TestGrid.qml")

    if engine.rootObjects():
        app.exec()

    del engine

