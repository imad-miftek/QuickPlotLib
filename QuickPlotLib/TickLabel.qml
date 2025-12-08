// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickPlotLib
    \inherits Rectangle
    \brief A tick label placeholder for debugging positioning.

    This component renders a colored rectangle to visually verify
    the positioning math for tick labels. Once positioning is confirmed,
    it will be replaced with actual text rendering.

    Positioning is based on the relevant edge for each axis direction:
    - Bottom axis: TOP edge is 'gap' pixels below tick
    - Top axis: BOTTOM edge is 'gap' pixels above tick
    - Left axis: RIGHT edge is 'gap' pixels left of tick
    - Right axis: LEFT edge is 'gap' pixels right of tick

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
        The data value to display (unused for now, kept for API compatibility).
    */
    required property real value

    /*!
        Number of decimal points to show (unused for now).
    */
    property int decimalPoints: 2

    /*!
        Gap in pixels between the tick endpoint and the nearest edge of the label.
        This gap should be visually consistent across all axis orientations.
    */
    property int gap: 4

    /*!
        Color of the label text (unused for now).
    */
    property color textColor: "#333333"

    /*!
        Font family (unused for now).
    */
    property string fontFamily: "sans-serif"

    /*!
        Font pixel size (unused for now).
    */
    property int fontSize: 12

    // Fixed size rectangle for debugging - represents approximate text bounds
    width: 30
    height: 12

    // Visible debug color
    color: "#FF6B6B"

    // Position so the relevant EDGE is 'gap' pixels from tickEnd
    x: {
        switch (direction) {
        case Axis.Direction.Left:
            // RIGHT edge of rectangle is 'gap' pixels from tick endpoint
            return Math.floor(tickEnd.x - width - gap); // instead of Math.round
        case Axis.Direction.Right:
            // LEFT edge of rectangle is 'gap' pixels from tick endpoint
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
            // BOTTOM edge of rectangle is 'gap' pixels from tick endpoint
            return Math.floor(tickEnd.y - height - gap);
        case Axis.Direction.Bottom:
            // TOP edge of rectangle is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.y + gap);
        default:
            return 0;
        }
    }
}
