# QuickPlotLib

A scientific plotting library for [QtQuick](https://doc.qt.io/qt-6/qtquick-index.html) using Qt6.

Key advantages:

 - Written in C++ and QML, so it can be used in both C++ and Python projects
 - QtQuick's hardware-based rendering makes this library render very fast
 - GPU-accelerated text rendering with precise font metrics
 - Flexible 3x3 GridLayout architecture supporting 4-sided axes

## Examples

The example gallery can be run using (provided the Python environment has [PySide6](https://pypi.org/project/PySide6/) installed):

```bash
python examples/gallery.py
```

## Qt version compatibility

This version of QuickPlotLib is compatible with Qt and PySide6 6.10.1. If you use this module from C++, then Qt's ABI stability guarantees means the compiled binaries will work for any Qt version >= 6.10 and < 7.0. If you use this module from Python, there are some additional features that rely on the PySide6 library version. Therefore the PySide6 version must be 6.10.1 exactly. Other 6.10 versions of PySide6 may work, but there are no guarantees.

## Python version compatibility

QuickPlotLib is compatible with the same Python versions and glibc versions that PySide6 is. For PySide6 6.10, the minimum Python version is 3.9.
