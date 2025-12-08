// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
\qmltype Graph
\inqmlmodule QuickPlotLib
\inherits Item
\brief Core axis layout system for a single GraphArea with integrated axes.

Conceptual 3x3 grid (corners are "nothing" cells):

[ NC | TopAxis | NC ]
[ LeftAxis| GraphArea | RightAxis ]
[ NC | BottomAxis | NC ]
*/

Item {
    id: root

    // ---- Public API -------------------------------------------------------

    /*! Left axis component. */
    property Component leftAxis: Component {
        Axis {
            direction: Axis.Direction.Left
            dataTransform: graphArea.dataTransform
            viewRect: graphArea.viewRect
            strokeColor: "#333333"
            strokeWidth: 1
            labelColor: "#333333"
            tickLabelColor: "#333333"
        }
    }

    /*! Right axis component. Default is null (off). */
    property Component rightAxis: null

    /*! Top axis component. Default is null (off). */
    property Component topAxis: null

    /*! Bottom axis component. */
    property Component bottomAxis: Component {
        Axis {
            direction: Axis.Direction.Bottom
            dataTransform: graphArea.dataTransform
            viewRect: graphArea.viewRect
            strokeColor: "#333333"
            strokeWidth: 1
            labelColor: "#333333"
            tickLabelColor: "#333333"
        }
    }

    /*! Thickness of each axis band in pixels. */
    property int leftAxisSize: 60
    property int rightAxisSize: 60
    property int topAxisSize: 60
    property int bottomAxisSize: 60

    /*! The central graph area. */
    property alias graphArea: graphArea

    /*! Default property - children go into graphArea. */
    default property alias graphChildren: graphArea.data

    /*! View rectangle for data coordinates, delegated to GraphArea. */
    property alias viewRect: graphArea.viewRect

    /*! Background rectangle */
    property alias background: background

    /*! Grid properties */
    property alias gridColor: graphArea.gridColor
    property alias gridLinesX: graphArea.gridLinesX
    property alias gridLinesY: graphArea.gridLinesY
    property alias showGrid: graphArea.showGrid

    // ---- Derived layout margins (3x3 conceptual grid) ---------------------

    readonly property bool hasLeftAxis: leftAxis !== null
    readonly property bool hasRightAxis: rightAxis !== null
    readonly property bool hasTopAxis: topAxis !== null
    readonly property bool hasBottomAxis: bottomAxis !== null

    readonly property int leftMargin: hasLeftAxis ? leftAxisSize : 0
    readonly property int rightMargin: hasRightAxis ? rightAxisSize : 0
    readonly property int topMargin: hasTopAxis ? topAxisSize : 0
    readonly property int bottomMargin: hasBottomAxis ? bottomAxisSize : 0

    // Background
    Rectangle {
        id: background
        anchors.fill: parent
        color: "#FFFFFF"
        border.width: 0
    }

    // ---- Axis bands -------------------------------------------------------

    // Top band (TopAxis) – occupies the conceptual top-center cell
    Item {
        id: topBand
        x: leftMargin
        y: 0
        width: Math.max(0, root.width - leftMargin - rightMargin)
        height: topMargin
        visible: hasTopAxis && height > 0

        Loader {
            anchors.fill: parent
            active: hasTopAxis
            sourceComponent: topAxis
        }
    }

    // Bottom band (BottomAxis) – conceptual bottom-center cell
    Item {
        id: bottomBand
        x: leftMargin
        y: root.height - bottomMargin
        width: Math.max(0, root.width - leftMargin - rightMargin)
        height: bottomMargin
        visible: hasBottomAxis && height > 0

        Loader {
            anchors.fill: parent
            active: hasBottomAxis
            sourceComponent: bottomAxis
        }
    }

    // Left band (LeftAxis) – conceptual middle-left cell
    Item {
        id: leftBand
        x: 0
        y: topMargin
        width: leftMargin
        height: Math.max(0, root.height - topMargin - bottomMargin)
        visible: hasLeftAxis && width > 0

        Loader {
            anchors.fill: parent
            active: hasLeftAxis
            sourceComponent: leftAxis
        }
    }

    // Right band (RightAxis) – conceptual middle-right cell
    Item {
        id: rightBand
        x: root.width - rightMargin
        y: topMargin
        width: rightMargin
        height: Math.max(0, root.height - topMargin - bottomMargin)
        visible: hasRightAxis && width > 0

        Loader {
            anchors.fill: parent
            active: hasRightAxis
            sourceComponent: rightAxis
        }
    }

    // ---- Graph area (middle cell) ----------------------------------------

    GraphArea {
        id: graphArea

        x: leftMargin
        y: topMargin
        width: Math.max(0, root.width - leftMargin - rightMargin)
        height: Math.max(0, root.height - topMargin - bottomMargin)
    }
}
