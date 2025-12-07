// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Axes
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief A complete graph with 4 axes in a 3x3 grid layout.

    3x3 Grid Layout Structure:
    [Empty]      [TopAxis]     [Empty]
    [LeftAxis]   [GraphArea]   [RightAxis]
    [Empty]      [BottomAxis]  [Empty]
*/

Item {
    id: root

    /*!
        Graph title.
    */
    property string title: ""

    /*!
        Padding around the graph.
    */
    property int padding: 15

    /*!
        Show/hide individual axes.
    */
    property bool showLeftAxis: true
    property bool showRightAxis: false
    property bool showTopAxis: false
    property bool showBottomAxis: true

    GridLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: root.padding
        rows: 4  // Title + 3 layout rows
        columns: 3
        rowSpacing: 0
        columnSpacing: 0

        // Title (spans all columns)
        Text {
            id: titleLabel
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.bottomMargin: root.title !== "" ? 10 : 0
            text: root.title
            font.pixelSize: 16
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            visible: root.title !== ""
        }

        // Row 0: Top-Left (Empty) - TopAxis - Top-Right (Empty)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            color: "#CCCCCC"
            visible: root.showTopAxis
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            color: "#3498DB"
            visible: root.showTopAxis
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            color: "#CCCCCC"
            visible: root.showTopAxis
        }

        // Row 1: LeftAxis - GraphArea - RightAxis
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: root.showLeftAxis ? 60 : 0
            color: "#E74C3C"
            visible: root.showLeftAxis
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 200
            Layout.minimumHeight: 200
            color: "#2ECC71"
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: root.showRightAxis ? 60 : 0
            color: "#9B59B6"
            visible: root.showRightAxis
        }

        // Row 2: Bottom-Left (Empty) - BottomAxis - Bottom-Right (Empty)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            color: "#CCCCCC"
            visible: root.showBottomAxis
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            color: "#F39C12"
            visible: root.showBottomAxis
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            color: "#CCCCCC"
            visible: root.showBottomAxis
        }
    }
}
