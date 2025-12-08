// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick
import QtQuick.Shapes

/*!
    \qmltype GraphArea
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief The central plotting area for graphs with coordinate transforms.
*/

Item {
    id: root

    /*!
        The view rectangle defining the data coordinate bounds.
        Format: Qt.rect(left, top, width, height)
    */
    property rect viewRect: Qt.rect(0, 0, 100, 100)

    /*!
        Transform from data coordinates to pixel coordinates inside the GraphArea.
    */
    readonly property matrix4x4 dataTransform: {
        let mat = Qt.matrix4x4();
        // Flip coordinate system so that Y points upwards
        mat.translate(Qt.vector3d(0, root.height, 0));
        mat.scale(root.width / viewRect.width, -root.height / viewRect.height, 1);
        mat.translate(Qt.vector3d(-viewRect.x, -viewRect.y, 0));
        return mat;
    }

    /*!
        Background color of the graph area.
    */
    property color backgroundColor: "#FFFFFF"

    /*!
        Grid line color.
    */
    property color gridColor: "#E0E0E0"

    /*!
        Number of grid lines in X direction.
    */
    property int gridLinesX: 10

    /*!
        Number of grid lines in Y direction.
    */
    property int gridLinesY: 10

    /*!
        Whether to show the grid.
    */
    property bool showGrid: true

    /*!
        Default property - children added here will be graph items.
    */
    default property alias data: contentItem.data

    // Background
    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        border.color: "#CCCCCC"
        border.width: 1
    }

    // Grid lines
    Shape {
        id: gridShape
        anchors.fill: parent
        visible: root.showGrid

        ShapePath {
            strokeColor: root.gridColor
            strokeWidth: 1
            fillColor: "transparent"

            // Vertical grid lines
            PathMultiline {
                paths: {
                    var lines = [];
                    for (var i = 0; i <= root.gridLinesX; i++) {
                        var x = (i / root.gridLinesX) * root.width;
                        lines.push([Qt.point(x, 0), Qt.point(x, root.height)]);
                    }
                    return lines;
                }
            }
        }

        ShapePath {
            strokeColor: root.gridColor
            strokeWidth: 1
            fillColor: "transparent"

            // Horizontal grid lines
            PathMultiline {
                paths: {
                    var lines = [];
                    for (var i = 0; i <= root.gridLinesY; i++) {
                        var y = (i / root.gridLinesY) * root.height;
                        lines.push([Qt.point(0, y), Qt.point(root.width, y)]);
                    }
                    return lines;
                }
            }
        }
    }

    // Content item for graph children
    Item {
        id: contentItem
        anchors.fill: parent
        clip: true
    }
}
