# QuickPlotLib

A scientific plotting library for [QtQuick](https://doc.qt.io/qt-6/qtquick-index.html) using Qt6 and PySide6 6.10.1.

## Features

- Written in C++ and QML, usable from both C++ and Python projects
- QtQuick's hardware-based rendering for fast performance
- Python importable and QML importable
- Built with CMake using scikit-build-core

## Requirements

- Python >= 3.9
- PySide6 6.10.1
- Qt 6.10.0 or later
- CMake >= 3.16
- C++17 compatible compiler
  - **Windows**: Visual Studio 2022 (MSVC) - Required for PySide6 compatibility
  - **macOS**: Clang
  - **Linux**: GCC or Clang

### Windows-Specific Requirements

On Windows, you must use the **MSVC (Visual Studio)** toolchain, not MinGW. PySide6 wheels are built with MSVC, and MinGW cannot link to MSVC .lib files. You need:

- Visual Studio 2022 (Community Edition is sufficient)
- Qt 6.10.0+ built with MSVC (e.g., `msvc2022_64`)

## Installation

### Quick Setup (Windows)

Run the setup script to create a virtual environment and install all dependencies:

```powershell
.\setup_venv.ps1
```

This will:
1. Create a Python virtual environment in `venv/`
2. Install all required packages from `requirements.txt`
3. Build and install QuickPlotLib in editable mode

### Manual Installation

1. Create and activate a virtual environment:

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

2. Install dependencies:

```powershell
pip install -r requirements.txt
```

3. Build and install the project:

```powershell
pip install --no-build-isolation --config-settings=editable.rebuild=true --config-settings=build-dir=build -v -e .
```

### Important Build Notes

- The `--no-build-isolation` flag is required to use the virtual environment's PySide6 and shiboken6_generator
- On Windows, CMake will automatically detect and use the Visual Studio generator
- The build artifacts will be placed in the `build/` directory
- The `-e` flag installs in editable mode, allowing you to modify source files without reinstalling

## Running Examples

After installation, you can run the test example:

```powershell
python examples/gallery.py
```

This will display a graph with a 3x3 GridLayout structure showing all four axes (top, bottom, left, right) around a central GraphArea to verify that the QML module is correctly built and importable.

## Usage

### From Python

```python
import sys
from PySide6 import QtGui, QtQml
import QuickPlotLib

app = QtGui.QGuiApplication(sys.argv)
engine = QtQml.QQmlApplicationEngine()
engine.addImportPath(QuickPlotLib.QML_IMPORT_PATH)
engine.load("your_qml_file.qml")
app.exec()
```

### From QML

```qml
import QtQuick
import QuickPlotLib

Axes {
    width: 800
    height: 600
    title: "My Graph"
    viewRect: Qt.rect(0, 0, 100, 100)
    
    leftLabel: "Y Axis"
    bottomLabel: "X Axis"
    
    showLeftAxis: true
    showBottomAxis: true
    showRightAxis: false
    showTopAxis: false
}
```

## Graph Architecture

QuickPlotLib uses a **3x3 GridLayout** structure for its graphs, providing more flexibility than traditional 2-column layouts:

```
[Empty]      [TopAxis]     [Empty]
[LeftAxis]   [GraphArea]   [RightAxis]  
[Empty]      [BottomAxis]  [Empty]
```

Benefits:
- Support for 4-sided axes (dual Y-axes, polar plots, etc.)
- Symmetrical and extensible layout
- Clean separation of concerns

## Project Structure

```
QuickPlotLib/
├── CMakeLists.txt           # Root CMake configuration
├── pyproject.toml           # Python project configuration
├── requirements.txt         # Python dependencies
├── setup_venv.ps1          # Virtual environment setup script
├── activate_venv.ps1       # Virtual environment activation
├── QuickPlotLib/           # Main library folder
│   ├── CMakeLists.txt      # Library CMake configuration
│   ├── Plugin.cpp          # QML plugin registration
│   ├── __init__.py         # Python module initialization
│   ├── GraphArea.qml       # Central plotting area component
│   ├── Axis.qml           # Axis component (supports all 4 sides)
│   ├── Axes.qml           # Main graph prefab with 3x3 layout
│   └── py.typed           # PEP 561 type marker
├── examples/              # Example applications
│   ├── gallery.py        # Test runner
│   └── TestGrid.qml      # Test QML window
└── tests/                # Test suite (placeholder)
```

## Building from Scratch

If you need to rebuild after making changes:

```powershell
# Clean the build directory
Remove-Item -Recurse -Force build

# Reinstall
pip install --no-build-isolation --config-settings=editable.rebuild=true --config-settings=build-dir=build -v -e .
```

## Development

### Testing

```powershell
pytest tests/
```

### Code Formatting

```powershell
ruff format .
```

### Type Checking

```powershell
mypy QuickPlotLib
```

## Troubleshooting

### "Cannot find -lQuickPlotLib" or similar linking errors on Windows

Make sure you're using MSVC, not MinGW. The CMake configuration should automatically use Visual Studio generator on Windows.

### QML module not found

Ensure you're adding the import path before loading QML:

```python
engine.addImportPath(QuickPlotLib.QML_IMPORT_PATH)
```

### Build fails with Qt not found

Make sure Qt 6.10.0+ is installed and either:
- Set `CMAKE_PREFIX_PATH` environment variable to your Qt installation
- Or let PySide6 provide Qt (automatic when using `--no-build-isolation`)

## License

MIT License - See [LICENCE](LICENCE) file for details.
