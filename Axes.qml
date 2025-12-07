// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Axes
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief A complete graph with 4 axes in a 3x3 grid layout.
    
    Layout structure:
    [Empty]      [TopAxis]     [Empty]
    [LeftAxis]   [GraphArea]   [RightAxis]
    [Empty]      [BottomAxis]  [Empty]
*/

Item {
    id: root

    /*!
        The background rectangle.
    */
    property alias background: background

    /*!
        The central graph area.
    */
    property alias graphArea: graphArea

    /*!
        Default property - children will be added to graph area.
    */
    default property alias graphChildren: graphArea.data

    /*!
        The view rectangle for data coordinates.
    */
    property alias viewRect: graphArea.viewRect

    /*!
        The left axis.
    */
    property alias leftAxis: leftAxis

    /*!
        The right axis.
    */
    property alias rightAxis: rightAxis

    /*!
        The top axis.
    */
    property alias topAxis: topAxis

    /*!
        The bottom axis.
    */
    property alias bottomAxis: bottomAxis

    /*!
        Label for left axis.
    */
    property alias leftLabel: leftAxis.label

    /*!
        Label for right axis.
    */
    property alias rightLabel: rightAxis.label

    /*!
        Label for top axis.
    */
    property alias topLabel: topAxis.label

    /*!
        Label for bottom axis.
    */
    property alias bottomLabel: bottomAxis.label

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

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F5F5F5"
        border.width: 0
    }

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

        // Row 0: Empty - TopAxis - Empty
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            visible: root.showTopAxis
        }

        Axis {
            id: topAxis
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            direction: Axis.Direction.Top
            visible: root.showTopAxis
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showTopAxis ? 50 : 0
            visible: root.showTopAxis
        }

        // Row 1: LeftAxis - GraphArea - RightAxis
        Axis {
            id: leftAxis
            Layout.fillHeight: true
            Layout.preferredWidth: root.showLeftAxis ? 60 : 0
            direction: Axis.Direction.Left
            visible: root.showLeftAxis
        }

        GraphArea {
            id: graphArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 200
            Layout.minimumHeight: 200
        }

        Axis {
            id: rightAxis
            Layout.fillHeight: true
            Layout.preferredWidth: root.showRightAxis ? 60 : 0
            direction: Axis.Direction.Right
            visible: root.showRightAxis
        }

        // Row 2: Empty - BottomAxis - Empty
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            visible: root.showBottomAxis
        }

        Axis {
            id: bottomAxis
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            direction: Axis.Direction.Bottom
            visible: root.showBottomAxis
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.showBottomAxis ? 50 : 0
            visible: root.showBottomAxis
        }
    }
}

