// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickPlotLib
    \inherits Rectangle
    \brief A tick label container with pixel-perfect edge-based positioning.

    This component uses a Rectangle as a container, making edge-based positioning
    explicit and easy to reason about. The relevant edge of the Rectangle is
    positioned at a consistent gap from the tick endpoint:

    - Bottom axis: Rectangle's TOP edge is 'gap' pixels below tick
    - Top axis: Rectangle's BOTTOM edge is 'gap' pixels above tick
    - Left axis: Rectangle's RIGHT edge is 'gap' pixels left of tick
    - Right axis: Rectangle's LEFT edge is 'gap' pixels right of tick

    Set color to a visible value (e.g., "#20FF0000") for debugging positioning.

    \sa Axis
*/

Rectangle {
    id: root

    /*!
        The direction of the axis this tick label belongs to.
        \sa Axis::direction
    */
    required property int direction

    /*!
        The endpoint of the tick mark (the end away from the spine).
        The label's relevant edge will be positioned relative to this point.
    */
    required property point tickEnd

    /*!
        The data value to display.
    */
    required property real value

    /*!
        Number of decimal points to show.
    */
    property int decimalPoints: 2

    /*!
        Gap in pixels between the tick endpoint and the nearest edge of the label.
        This gap is consistent across all axis orientations.
    */
    property int gap: 4

    /*!
        Color of the label text.
    */
    property alias textColor: labelText.color

    /*!
        Font of the label text.
    */
    property alias font: labelText.font

    // Size adapts to text content
    width: labelText.width
    height: labelText.height

    // Transparent by default - set to a color for debugging
    color: "#FF6B6B"

    // Position the Rectangle so its relevant EDGE is 'gap' pixels from tickEnd
    x: {
        switch (direction) {
        case Axis.Direction.Left:
            // RIGHT edge of Rectangle is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.x - width - gap);
        case Axis.Direction.Right:
            // LEFT edge of Rectangle is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.x + gap);
        case Axis.Direction.Top:
        case Axis.Direction.Bottom:
            // Horizontally centered on tick
            return Math.round(tickEnd.x - width / 2);
        default:
            return 0;
        }
    }

    y: {
        switch (direction) {
        case Axis.Direction.Left:
        case Axis.Direction.Right:
            // Vertically centered on tick
            return Math.round(tickEnd.y - height / 2);
        case Axis.Direction.Top:
            // BOTTOM edge of Rectangle is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.y - height - gap);
        case Axis.Direction.Bottom:
            // TOP edge of Rectangle is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.y + gap);
        default:
            return 0;
        }
    }

    Text {
        id: labelText
        text: Number(root.value).toFixed(root.decimalPoints)
        color: "#333333"
    }
}
