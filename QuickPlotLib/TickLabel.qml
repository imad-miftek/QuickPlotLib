// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief A tick label with pixel-perfect positioning using normalized ink bounds.

    The Glyph component normalizes ink so it always starts at (0,0).
    This means:
    - Item width = inkWidth (exact visible pixel width)
    - Item height = inkHeight (exact visible pixel height, excludes empty descender space)

    Positioning becomes trivially simple:
    - Left axis: Right edge of item at tickEnd.x - gap
    - Right axis: Left edge of item at tickEnd.x + gap
    - Top/Bottom: Center of item at tick x position
    - Vertical centering uses actual ink height, not font metrics

    \sa Axis, Glyph
*/

Item {
    id: root

    required property int direction
    required property point tickEnd
    required property real value

    property int decimalPoints: 2
    property int gap: 4
    property color textColor: "#333333"
    property string fontFamily: "sans-serif"
    property int fontSize: 12

    width: labelText.width
    height: labelText.height

    // SIMPLIFIED positioning - ink is normalized (inkLeft=0, width=inkWidth)
    // Item bounds now exactly equal the visible ink pixels
    x: {
        switch (direction) {
        case Axis.Direction.Left:
            // Right edge of item at tickEnd.x - gap
            return Math.round(tickEnd.x - gap - width);
        case Axis.Direction.Right:
            // Left edge of item at tickEnd.x + gap
            return Math.round(tickEnd.x + gap);
        case Axis.Direction.Top:
        case Axis.Direction.Bottom:
            // Center of item at tick x position
            return Math.round(tickEnd.x - width / 2);
        default:
            return 0;
        }
    }

    y: {
        switch (direction) {
        case Axis.Direction.Left:
        case Axis.Direction.Right:
            return Math.round(tickEnd.y - height / 2);
        case Axis.Direction.Top:
            return Math.round(tickEnd.y - height - gap);
        case Axis.Direction.Bottom:
            return Math.round(tickEnd.y + gap);
        default:
            return 0;
        }
    }

    Glyph {
        id: labelText
        text: Number(root.value).toFixed(root.decimalPoints)
        color: root.textColor
        fontFamily: root.fontFamily
        pixelSize: root.fontSize
    }

    // DEBUG: Visualize bounding box (comment out for production)
    // Rectangle {
    //     anchors.fill: parent
    //     color: "transparent"
    //     border.color: "red"
    //     border.width: 1
    // }
}
