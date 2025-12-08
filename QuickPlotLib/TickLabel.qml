// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

import QtQuick

/*!
    \qmltype TickLabel
    \inqmlmodule QuickPlotLib
    \inherits Item
    \brief A tick label with pixel-perfect glyph-tight positioning.

    This component uses Glyph for GPU-accelerated text rendering with
    exact glyph bounds. The bounding box matches the rendered glyphs precisely,
    enabling pixel-perfect alignment of tick labels to tick marks.

    Positioning is based on the relevant edge for each axis direction:
    - Bottom axis: TOP edge of text is 'gap' pixels below tick
    - Top axis: BOTTOM edge of text is 'gap' pixels above tick
    - Left axis: RIGHT edge of text is 'gap' pixels left of tick
    - Right axis: LEFT edge of text is 'gap' pixels right of tick

    \sa Axis, Glyph
*/

Item {
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
        This gap is visually consistent across all axis orientations.
    */
    property int gap: 4

    /*!
        Color of the label text.
    */
    property color textColor: "#333333"

    /*!
        Font family of the label text.
    */
    property string fontFamily: "sans-serif"

    /*!
        Font pixel size of the label text.
    */
    property int fontSize: 12

    // Size matches the Glyph exactly (pixel-perfect glyph bounds)
    width: labelText.width
    height: labelText.height

    // Position so the relevant EDGE is 'gap' pixels from tickEnd
    x: {
        switch (direction) {
        case Axis.Direction.Left:
            // RIGHT edge is 'gap' pixels from tick endpoint
            return Math.floor(tickEnd.x - width - gap);
        case Axis.Direction.Right:
            // LEFT edge is 'gap' pixels from tick endpoint
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
            // BOTTOM edge is 'gap' pixels from tick endpoint
            return Math.floor(tickEnd.y - height - gap);
        case Axis.Direction.Bottom:
            // TOP edge is 'gap' pixels from tick endpoint
            return Math.round(tickEnd.y + gap);
        default:
            return 0;
        }
    }

    // Glyph provides GPU-accelerated rendering with exact glyph bounds
    Glyph {
        id: labelText
        text: Number(root.value).toFixed(root.decimalPoints)
        color: root.textColor
        fontFamily: root.fontFamily
        pixelSize: root.fontSize
    }

    // DEBUG: Uncomment to visualize the glyph bounding box
    // Rectangle {
    //     anchors.fill: parent
    //     color: "transparent"
    //     border.color: "red"
    //     border.width: 1
    // }
}
