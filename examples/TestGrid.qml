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
        
        // View rectangle (data coordinates)
        viewRect: Qt.rect(0, 0, 100, 100)
        
        // Configure which axes to show
        showLeftAxis: true
        showRightAxis: true
        showTopAxis: true
        showBottomAxis: true
        
        // Axis labels
        leftLabel: "Left Axis"
        rightLabel: "Right Axis"
        topLabel: "Top Axis"
        bottomLabel: "Bottom Axis"
        
        // Configure axis ticks
        leftAxis.ticks: [0, 25, 50, 75, 100]
        rightAxis.ticks: [0, 25, 50, 75, 100]
        topAxis.ticks: [0, 25, 50, 75, 100]
        bottomAxis.ticks: [0, 25, 50, 75, 100]
    }
}

