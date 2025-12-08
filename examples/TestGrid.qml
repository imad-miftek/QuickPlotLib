// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Window
import QuickPlotLib as QuickPlotLib

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: "QuickPlotLib - Dynamic Grid System Test"

    QuickPlotLib.Graph {
        id: graph
        anchors.fill: parent
        anchors.margins: 20

        // Configure the view rectangle (data coordinate bounds)
        viewRect: Qt.rect(0, 0, 100, 100)

        // Configure grid
        showGrid: true
        gridColor: "#E0E0E0"
        gridLinesX: 10
        gridLinesY: 10

        // Axis sizes (default axes are provided automatically)
        leftAxisSize: 80
        rightAxisSize: 80
        topAxisSize: 60
        bottomAxisSize: 80

        // Background styling
        background.color: "#F8F9FA"
        background.border.color: "#DEE2E6"
        background.border.width: 1

        // The Graph component provides default left and bottom axes
        // You can override them or add top/right axes as needed

        // Example: Uncomment to add all four axes
        // topAxis: Component { QuickPlotLib.Axis { direction: QuickPlotLib.Axis.Direction.Top } }
        // rightAxis: Component { QuickPlotLib.Axis { direction: QuickPlotLib.Axis.Direction.Right } }

        // Add some visual content to demonstrate the graph area
        Rectangle {
            width: 20
            height: 20
            radius: 10
            color: "#E74C3C"
            x: parent.width / 2 - 10
            y: parent.height / 2 - 10

            Text {
                anchors.centerIn: parent
                text: "•"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
        }

        Text {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 40
            text: "Graph Area Center (50, 50)"
            color: "#7F8C8D"
            font.pixelSize: 12
        }
    }
}
