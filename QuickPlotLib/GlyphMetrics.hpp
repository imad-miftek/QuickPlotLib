// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QtQml/qqmlregistration.h>

/*!
    \qmltype GlyphMetrics
    \inqmlmodule QuickPlotLib
    \inherits QObject
    \brief Singleton utility for measuring text dimensions without rendering.

    GlyphMetrics provides fast, accurate text measurement using QFontMetricsF.
    This enables automatic axis sizing based on tick label content.

    Example usage:
    \qml
    var width = GlyphMetrics.textWidth("10.00", "sans-serif", 12);
    var maxWidth = GlyphMetrics.maxTextWidth(["0.00", "5.00", "10.00"], "sans-serif", 12);
    \endqml

    \sa Axis, Glyph
*/
class GlyphMetrics : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit GlyphMetrics(QObject *parent = nullptr);

    /*!
        Returns the width in pixels of the given text when rendered with the specified font.
        Uses QFontMetricsF::horizontalAdvance() for accurate measurement.
    */
    Q_INVOKABLE qreal textWidth(const QString &text, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the height in pixels (ascent + descent) for the specified font.
        This is the tight glyph height without leading.
    */
    Q_INVOKABLE qreal textHeight(const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the ascent (baseline to top) for the specified font.
    */
    Q_INVOKABLE qreal ascent(const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the descent (baseline to bottom) for the specified font.
    */
    Q_INVOKABLE qreal descent(const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum width among all texts in the list.
        Useful for determining axis size based on tick labels.
    */
    Q_INVOKABLE qreal maxTextWidth(const QVariantList &texts, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the width of a number formatted with the given decimal points.
        Measures the widest possible digit (usually '0' or '8') to ensure consistent sizing.
    */
    Q_INVOKABLE qreal numberWidth(qreal value, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum width for a list of numbers with the given decimal points.
    */
    Q_INVOKABLE qreal maxNumberWidth(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum left padding needed across all formatted numbers.
        Left padding compensates for negative left-bearing on first characters.
        Used by Axis to ensure tick labels don't extend outside the axis band.
    */
    Q_INVOKABLE qreal maxLeftPadding(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum right padding needed across all formatted numbers.
        Right padding compensates for negative right-bearing on last characters.
    */
    Q_INVOKABLE qreal maxRightPadding(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    // ========== INK METRICS (boundingRect-based) ==========
    // These measure actual rendered pixel bounds, not logical advance widths.
    // Use these for pixel-perfect positioning where the gap from tick to
    // closest ink pixel must be exact.

    /*!
        Returns the ink left edge for a single text string.
        This is boundingRect().left() - can be negative if ink extends left of origin.
    */
    Q_INVOKABLE qreal inkLeft(const QString &text, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the ink right edge for a single text string.
        This is boundingRect().left() + boundingRect().width().
    */
    Q_INVOKABLE qreal inkRight(const QString &text, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum inkRight across all formatted numbers.
        Used by LEFT axis to compute requiredThickness.
    */
    Q_INVOKABLE qreal maxInkRight(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the minimum inkLeft (most negative) across all formatted numbers.
        Used by RIGHT axis to compute requiredThickness.
        Note: inkLeft is typically negative, so "max" extent means most negative value.
    */
    Q_INVOKABLE qreal minInkLeft(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the ink width (actual visible pixel width) for a single text string.
        This is boundingRect().width().
    */
    Q_INVOKABLE qreal inkWidth(const QString &text, const QString &fontFamily, int pixelSize) const;

    /*!
        Returns the maximum ink width across all formatted numbers.
        Since Glyph normalizes ink to start at x=0, this is what you need for axis sizing.
        Used by both LEFT and RIGHT axes to compute requiredThickness.
    */
    Q_INVOKABLE qreal maxInkWidth(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const;
};
