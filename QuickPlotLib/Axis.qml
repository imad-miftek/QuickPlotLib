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

    readonly property bool isVertical: direction === Axis.Direction.Left || direction === Axis.Direction.Right
    readonly property bool isHorizontal: !isVertical

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
                    var numTicks = root.ticks.length;

                    for (var i = 0; i < numTicks; i++) {
                        var pos = (numTicks === 1) ? 0 : (i / (numTicks - 1));

                        if (root.isHorizontal) {
                            var x = Math.round(pos * (root.width - 1)) + 0.5;
                            var y1 = root.direction === Axis.Direction.Bottom ? 0 : root.height;
                            var y2 = root.direction === Axis.Direction.Bottom ? root.tickLength : root.height - root.tickLength;
                            lines.push([Qt.point(x, y1), Qt.point(x, y2)]);
                        } else {
                            var y = Math.round((1 - pos) * (root.height - 1)) + 0.5;
                            var x1 = root.direction === Axis.Direction.Right ? 0 : root.width;
                            var x2 = root.direction === Axis.Direction.Right ? root.tickLength : root.width - root.tickLength;
                            lines.push([Qt.point(x1, y), Qt.point(x2, y)]);
                        }
                    }
                    return lines;
                }
            }
        }
    }
}
