// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes

/*!
    \qmltype Axis
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief An axis component with sophisticated styling and transforms.
*/

Item {
    id: root

    enum Direction {
        Left,
        Right,
        Top,
        Bottom
    }

    /*!
        The direction/position of the axis.
    */
    property int direction: Axis.Direction.Bottom

    /*!
        Data transform from the graph area.
    */
    property matrix4x4 dataTransform

    /*!
        View rectangle from the graph area.
    */
    property rect viewRect: Qt.rect(0, 0, 100, 100)

    /*!
        The axis label text.
    */
    property string label: ""

    /*!
        Label color.
    */
    property color labelColor: "#333333"

    /*!
        Label font.
    */
    property font labelFont

    /*!
        Tick label color.
    */
    property color tickLabelColor: labelColor

    /*!
        Tick label font.
    */
    property font tickLabelFont: labelFont

    /*!
        Number of decimal points for tick labels.
    */
    property int decimalPoints: 2

    /*!
        Tick values to display (auto-generated from viewRect if not set).
    */
    property var ticks: {
        var result = [];
        var start, end, count = 11;

        if (isHorizontal) {
            start = viewRect.x;
            end = viewRect.x + viewRect.width;
        } else {
            start = viewRect.y;
            end = viewRect.y + viewRect.height;
        }

        for (var i = 0; i < count; i++) {
            result.push(start + (end - start) * i / (count - 1));
        }
        return result;
    }

    /*!
        Tick length in pixels.
    */
    property int tickLength: 10

    /*!
        Axis stroke color.
    */
    property color strokeColor: "#333333"

    /*!
        Axis stroke width.
    */
    property int strokeWidth: 1

    /*!
        Whether to show tick labels.
    */
    property bool showTickLabels: true

    /*!
        Spacing between axis label and tick labels.
    */
    property double spacing: 4

    readonly property bool isVertical: direction === Axis.Direction.Left || direction === Axis.Direction.Right
    readonly property bool isHorizontal: !isVertical

    implicitWidth: isVertical ? 60 : 200
    implicitHeight: isHorizontal ? 50 : 200

    // Axis spine and ticks
    Shape {
        id: shape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: myPath
            strokeColor: root.strokeColor
            strokeWidth: root.strokeWidth
            fillColor: "transparent"
            pathHints: ShapePath.PathLinear

            PathPolyline {
                path: {
                    var points = [];

                    // Main spine
                    if (root.direction === Axis.Direction.Left) {
                        points.push(Qt.point(root.width, 0));
                        points.push(Qt.point(root.width, root.height));
                    } else if (root.direction === Axis.Direction.Right) {
                        points.push(Qt.point(0, 0));
                        points.push(Qt.point(0, root.height));
                    } else if (root.direction === Axis.Direction.Top) {
                        points.push(Qt.point(0, root.height));
                        points.push(Qt.point(root.width, root.height));
                    } else {
                        // Bottom
                        points.push(Qt.point(0, 0));
                        points.push(Qt.point(root.width, 0));
                    }

                    // Add tick marks
                    for (var i = 0; i < root.ticks.length; i++) {
                        var tickValue = root.ticks[i];
                        var tickPos = getTickPosition(tickValue);

                        if (root.isHorizontal) {
                            var x = tickPos;
                            if (root.direction === Axis.Direction.Bottom) {
                                points.push(Qt.point(x, 0));
                                points.push(Qt.point(x, root.tickLength));
                                points.push(Qt.point(x, 0));
                            } else {
                                points.push(Qt.point(x, root.height));
                                points.push(Qt.point(x, root.height - root.tickLength));
                                points.push(Qt.point(x, root.height));
                            }
                        } else {
                            var y = tickPos;
                            if (root.direction === Axis.Direction.Left) {
                                points.push(Qt.point(root.width, y));
                                points.push(Qt.point(root.width - root.tickLength, y));
                                points.push(Qt.point(root.width, y));
                            } else {
                                points.push(Qt.point(0, y));
                                points.push(Qt.point(root.tickLength, y));
                                points.push(Qt.point(0, y));
                            }
                        }
                    }

                    return points;
                }
            }
        }
    }

    // Tick labels
    Item {
        id: tickLabelsContainer

        Repeater {
            model: root.showTickLabels ? root.ticks : []
            delegate: Text {
                required property var modelData
                required property int index

                text: Number(modelData).toFixed(root.decimalPoints)
                font: root.tickLabelFont
                color: root.tickLabelColor

                property real tickPos: getTickPosition(modelData)

                x: {
                    if (root.isHorizontal) {
                        return tickPos - width / 2;
                    } else if (root.direction === Axis.Direction.Left) {
                        return root.width - root.tickLength - width - 2;
                    } else {
                        return root.tickLength + 2;
                    }
                }

                y: {
                    if (root.isVertical) {
                        return tickPos - height / 2;
                    } else if (root.direction === Axis.Direction.Bottom) {
                        return root.tickLength + 2;
                    } else {
                        return root.height - root.tickLength - height - 2;
                    }
                }
            }
        }
    }

    // Axis label
    Text {
        id: labelText
        text: root.label
        font: root.labelFont
        color: root.labelColor
        visible: root.label !== ""

        x: {
            switch (root.direction) {
            case Axis.Direction.Left:
                return height / 2;
            case Axis.Direction.Right:
                return root.width - height / 2;
            case Axis.Direction.Top:
            case Axis.Direction.Bottom:
                return root.width / 2;
            }
        }

        y: {
            switch (root.direction) {
            case Axis.Direction.Left:
            case Axis.Direction.Right:
                return root.height / 2;
            case Axis.Direction.Top:
                return height / 2;
            case Axis.Direction.Bottom:
                return root.height - height / 2;
            }
        }

        transform: [
            Translate {
                x: -labelText.width / 2
                y: -labelText.height / 2
            },
            Rotation {
                angle: {
                    switch (root.direction) {
                    case Axis.Direction.Left:
                        return -90;
                    case Axis.Direction.Right:
                        return 90;
                    case Axis.Direction.Top:
                    case Axis.Direction.Bottom:
                        return 0;
                    }
                }
            }
        ]
    }

    // Helper function to convert data value to pixel position
    function getTickPosition(value) {
        if (root.isHorizontal) {
            var dataWidth = root.viewRect.width;
            var relativePos = (value - root.viewRect.x) / dataWidth;
            return relativePos * root.width;
        } else {
            var dataHeight = root.viewRect.height;
            var relativePos = (value - root.viewRect.y) / dataHeight;
            // Flip for vertical axes (data coords have Y pointing up)
            return root.height - (relativePos * root.height);
        }
    }
}
