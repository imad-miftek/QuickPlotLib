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
        title: "QuickPlotLib 3x3 GridLayout Structure"
        
        // Configure which axes to show
        showLeftAxis: true
        showRightAxis: true
        showTopAxis: true
        showBottomAxis: true
        
        // Padding around the layout
        padding: 15
    }
}
