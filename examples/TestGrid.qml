// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Window
import QuickPlotLib

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: "QuickPlotLib - 3x3 Layout Test"

    Axes {
        anchors.fill: parent

        // Default: left and bottom axes are automatically provided (2x2 layout)

        // To add top axis, uncomment:
        // topAxis: Component {
        //     Rectangle { color: "#3498DB" }
        // }

        // To add right axis, uncomment:
        // rightAxis: Component {
        //     Rectangle { color: "#9B59B6" }
        // }

    }
}
