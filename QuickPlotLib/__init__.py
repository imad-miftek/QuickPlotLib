# SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
# SPDX-License-Identifier: MIT

import contextlib
import os
import pathlib
from typing import ContextManager

from PySide6 import QtCore, QtGui, QtQml, QtQuick

try:
    from ._version import __version__, __version_tuple__
except ImportError:
    __version__ = "0.0.0+unknown"
    __version_tuple__ = (0, 0, 0, "unknown", 0)

QML_IMPORT_PATH = str(pathlib.Path(__file__).parent.parent)

_dll_path = pathlib.Path(__file__).parent
if hasattr(os, "add_dll_directory"):
    cm: ContextManager = os.add_dll_directory(os.fspath(_dll_path))
else:
    cm = contextlib.nullcontext()
if os.name == "nt":
    os.environ["PATH"] = os.fspath(_dll_path) + os.pathsep + os.environ["PATH"]
with cm:
    pass  # Load any native modules here if needed
