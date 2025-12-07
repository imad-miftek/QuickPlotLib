# SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
# SPDX-License-Identifier: MIT

"""Basic import tests for QuickPlotLib."""


def test_import_quickplotlib():
    """Test that QuickPlotLib can be imported."""
    import QuickPlotLib

    assert QuickPlotLib is not None


def test_version_exists():
    """Test that version information is available."""
    import QuickPlotLib

    assert hasattr(QuickPlotLib, "__version__")
    assert isinstance(QuickPlotLib.__version__, str)


def test_qml_import_path():
    """Test that QML_IMPORT_PATH is set correctly."""
    import QuickPlotLib

    assert hasattr(QuickPlotLib, "QML_IMPORT_PATH")
    assert isinstance(QuickPlotLib.QML_IMPORT_PATH, str)
    assert len(QuickPlotLib.QML_IMPORT_PATH) > 0

