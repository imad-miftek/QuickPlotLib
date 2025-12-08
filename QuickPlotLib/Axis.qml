// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes

/*!
    \qmltype Axis
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief An axis component supporting all four orientations.
*/

Item {
    id: root

    /*!
        \qmlproperty enumeration Axis::direction
        The direction/position of the axis.
        \value Axis.Direction.Left Left side (vertical)
        \value Axis.Direction.Right Right side (vertical)
        \value Axis.Direction.Top Top side (horizontal)
        \value Axis.Direction.Bottom Bottom side (horizontal)
    */
    enum Direction {
        Left,
        Right,
        Top,
        Bottom
    }

    /*!
        The direction of the axis.
    */
    property int direction: Axis.Direction.Bottom

    /*!
        The axis label text.
    */
    property string label: ""

    /*!
        Tick values to display.
    */
    property var ticks: [0, 25, 50, 75, 100]

    /*!
        Tick length in pixels.
    */
    property int tickLength: 8

    /*!
        Label font size.
    */
    property int fontSize: 12

    /*!
        Axis color.
    */
    property color color: "#333333"

    /*!
        Axis background color.
    */
    property color backgroundColor: "transparent"

    /*!
        Whether to show the spine.
    */
    property bool showSpine: true

    /*!
        Whether to show tick labels.
    */
    property bool showTickLabels: true

    /*!
        Number of decimal points for tick labels.
    */
    property int decimalPoints: 2

    /*!
        Gap in pixels between tick marks and labels.
        This gap is consistent across all axis orientations.
    */
    property int labelGap: 4

    /*!
        Color of the tick labels.
    */
    property color labelColor: color

    readonly property bool isVertical: direction === Axis.Direction.Left || direction === Axis.Direction.Right
    readonly property bool isHorizontal: !isVertical

    /*!
        Computed tick positions with spine and end points for each tick.
        Used internally for rendering tick marks and labels.
    */
    readonly property var tickPositions: {
        var positions = [];
        var numTicks = ticks.length;

        for (var i = 0; i < numTicks; i++) {
            var pos = (numTicks === 1) ? 0.5 : (i / (numTicks - 1));

            if (isHorizontal) {
                var x = Math.round(pos * (width - 1)) + 0.5;
                var spineY = direction === Axis.Direction.Bottom ? 0.5 : height - 0.5;
                var endY = direction === Axis.Direction.Bottom ? tickLength - 0.5 : height - tickLength + 0.5;
                positions.push({
                    spinePoint: Qt.point(x, spineY),
                    endPoint: Qt.point(x, endY),
                    value: ticks[i]
                });
            } else {
                var y = Math.round((1 - pos) * (height - 1)) + 0.5;
                var spineX = direction === Axis.Direction.Right ? 0.5 : width - 0.5;
                var endX = direction === Axis.Direction.Right ? tickLength - 0.5 : width - tickLength + 0.5;
                positions.push({
                    spinePoint: Qt.point(spineX, y),
                    endPoint: Qt.point(endX, y),
                    value: ticks[i]
                });
            }
        }
        return positions;
    }

    implicitWidth: isVertical ? 60 : 200
    implicitHeight: isHorizontal ? 50 : 200

    // Axis line
    Shape {
        visible: root.showSpine
        anchors.fill: parent

        ShapePath {
            strokeColor: root.color
            strokeWidth: 2
            fillColor: "transparent"

            startX: {
                if (root.direction === Axis.Direction.Right)
                    return 0;
                if (root.direction === Axis.Direction.Left)
                    return root.width;
                return 0;
            }
            startY: {
                if (root.direction === Axis.Direction.Bottom)
                    return 0;
                if (root.direction === Axis.Direction.Top)
                    return root.height;
                return 0;
            }

            PathLine {
                x: {
                    if (root.direction === Axis.Direction.Right)
                        return 0;
                    if (root.direction === Axis.Direction.Left)
                        return root.width;
                    return root.width;
                }
                y: {
                    if (root.direction === Axis.Direction.Bottom)
                        return 0;
                    if (root.direction === Axis.Direction.Top)
                        return root.height;
                    return root.height;
                }
            }
        }
    }

    // Tick marks
    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: root.color
            strokeWidth: 1
            fillColor: "transparent"

            PathMultiline {
                paths: {
                    var lines = [];
                    for (var i = 0; i < root.tickPositions.length; i++) {
                        var tick = root.tickPositions[i];
                        lines.push([tick.spinePoint, tick.endPoint]);
                    }
                    return lines;
                }
            }
        }
    }

    // Tick labels
    Repeater {
        model: root.showTickLabels ? root.tickPositions.length : 0

        TickLabel {
            required property int index

            direction: root.direction
            tickEnd: root.tickPositions[index].endPoint
            value: root.tickPositions[index].value
            decimalPoints: root.decimalPoints
            gap: root.labelGap
            textColor: root.labelColor
            fontSize: root.fontSize
        }
    }
}
