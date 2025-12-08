// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
\qmltype Axes
\inqmlmodule QuickPlotLib
\inherits Item
\brief Core axis layout system for a single GraphArea.

Conceptual 3x3 grid (corners are "nothing" cells):

[ NC | TopAxis | NC ]
[ LeftAxis| GraphArea | RightAxis ]
[ NC | BottomAxis | NC ]

Active structures:

- Default (left + bottom):
2x2 layout derived from middle + bottom rows, left + center cols:

[ LeftAxis | GraphArea ]
[ Nothing | BottomAxis ]

- Left + Bottom + Right:
2x3 layout (middle + bottom rows, all three cols):

[ LeftAxis | GraphArea | RightAxis ]
[ Nothing | BottomAxis | Nothing ]

- Top + Left + Bottom:
3x2 layout (all three rows, left + center cols):

[ Nothing | TopAxis ]
[ LeftAxis | GraphArea ]
[ Nothing | BottomAxis ]

- Top + Left + Bottom + Right:
Full 3x3 layout:

[ Nothing | TopAxis | Nothing ]
[ LeftAxis | GraphArea | RightAxis ]
[ Nothing | BottomAxis | Nothing ]

Corners (NC) are simply empty areas of the root item.
*/

Item {
    id: root

    // ---- Public API -------------------------------------------------------

    /*! Left axis component. Default placeholder is provided. */
    property Component leftAxis: Axis {
        direction: Axis.Direction.Left
        ticks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        backgroundColor: '#E74C3C'
        showSpine: false
    }

    /*! Right axis component. Default is null (off). */
    property Component rightAxis: null

    /*! Top axis component. Default is null (off). */
    property Component topAxis: null

    /*! Bottom axis component. Default placeholder is provided. */
    property Component bottomAxis: Component {
        Axis {
            direction: Axis.Direction.Bottom
            ticks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            backgroundColor: '#F39C12'
            showSpine: false
        }
    }

    /*! Thickness of each axis band in pixels. */
    property int leftAxisSize: 60
    property int rightAxisSize: 60
    property int topAxisSize: 60
    property int bottomAxisSize: 60

    /*! Color for the corner "nothing" cells. */
    property color cornerColor: '#b8b8f7'

    /*! The central graph area. */
    property alias graphArea: graphArea

    /*! Default property - children go into graphArea. */
    default property alias graphChildren: graphArea.data

    /*! View rectangle for data coordinates, delegated to GraphArea. */
    property alias viewRect: graphArea.viewRect

    // ---- Derived layout margins (3x3 conceptual grid) ---------------------

    readonly property bool hasLeftAxis: leftAxis !== null
    readonly property bool hasRightAxis: rightAxis !== null
    readonly property bool hasTopAxis: topAxis !== null
    readonly property bool hasBottomAxis: bottomAxis !== null

    readonly property int leftMargin: hasLeftAxis ? leftAxisSize : 0
    readonly property int rightMargin: hasRightAxis ? rightAxisSize : 0
    readonly property int topMargin: hasTopAxis ? topAxisSize : 0
    readonly property int bottomMargin: hasBottomAxis ? bottomAxisSize : 0

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

    // ---- Corner "nothing" cells -------------------------------------------

    // Top-left corner
    Rectangle {
        x: 0
        y: 0
        width: leftMargin
        height: topMargin
        color: root.cornerColor
        visible: width > 0 && height > 0
    }

    // Top-right corner
    Rectangle {
        x: root.width - rightMargin
        y: 0
        width: rightMargin
        height: topMargin
        color: root.cornerColor
        visible: width > 0 && height > 0
    }

    // Bottom-left corner
    Rectangle {
        x: 0
        y: root.height - bottomMargin
        width: leftMargin
        height: bottomMargin
        color: root.cornerColor
        visible: width > 0 && height > 0
    }

    // Bottom-right corner
    Rectangle {
        x: root.width - rightMargin
        y: root.height - bottomMargin
        width: rightMargin
        height: bottomMargin
        color: root.cornerColor
        visible: width > 0 && height > 0
    }
}
