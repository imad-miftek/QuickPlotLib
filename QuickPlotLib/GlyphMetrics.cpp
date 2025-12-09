// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#include "GlyphMetrics.hpp"

#include <QFont>
#include <QFontMetricsF>
#include <QtMath>

// Helper to calculate total width including bearing compensation
// This matches the Glyph component's width calculation exactly
static qreal calculateGlyphWidth(const QFontMetricsF &fm, const QString &text)
{
    if (text.isEmpty()) {
        return 0;
    }

    qreal advanceWidth = fm.horizontalAdvance(text);

    // Calculate bearing compensation (same as Glyph::updateMetrics)
    int leftPadding = 0;
    int rightPadding = 0;

    qreal leftBearing = fm.leftBearing(text.at(0));
    if (leftBearing < 0) {
        leftPadding = qCeil(-leftBearing);
    }

    qreal rightBearing = fm.rightBearing(text.at(text.length() - 1));
    if (rightBearing < 0) {
        rightPadding = qCeil(-rightBearing);
    }

    return qCeil(advanceWidth) + leftPadding + rightPadding;
}

GlyphMetrics::GlyphMetrics(QObject *parent)
    : QObject(parent)
{
}

qreal GlyphMetrics::textWidth(const QString &text, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    // Use helper that includes bearing compensation
    return calculateGlyphWidth(fm, text);
}

qreal GlyphMetrics::textHeight(const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    // Ceil to match Glyph component's qCeil(m_ascent + m_descent)
    return qCeil(fm.ascent() + fm.descent());
}

qreal GlyphMetrics::ascent(const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    return fm.ascent();
}

qreal GlyphMetrics::descent(const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    return fm.descent();
}

qreal GlyphMetrics::maxTextWidth(const QVariantList &texts, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxWidth = 0;
    for (const QVariant &v : texts) {
        // Use helper that includes bearing compensation
        qreal w = calculateGlyphWidth(fm, v.toString());
        if (w > maxWidth) {
            maxWidth = w;
        }
    }
    return maxWidth;
}

qreal GlyphMetrics::numberWidth(qreal value, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QString text = QString::number(value, 'f', decimalPoints);
    // textWidth already uses bearing compensation
    return textWidth(text, fontFamily, pixelSize);
}

qreal GlyphMetrics::maxNumberWidth(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxWidth = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        // Use helper that includes bearing compensation
        qreal w = calculateGlyphWidth(fm, text);
        if (w > maxWidth) {
            maxWidth = w;
        }
    }
    return maxWidth;
}

qreal GlyphMetrics::maxLeftPadding(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxPad = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        if (!text.isEmpty()) {
            qreal leftBearing = fm.leftBearing(text.at(0));
            if (leftBearing < 0) {
                qreal pad = qCeil(-leftBearing);
                if (pad > maxPad) {
                    maxPad = pad;
                }
            }
        }
    }
    return maxPad;
}

qreal GlyphMetrics::maxRightPadding(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxPad = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        if (!text.isEmpty()) {
            qreal rightBearing = fm.rightBearing(text.at(text.length() - 1));
            if (rightBearing < 0) {
                qreal pad = qCeil(-rightBearing);
                if (pad > maxPad) {
                    maxPad = pad;
                }
            }
        }
    }
    return maxPad;
}

// ========== INK METRICS (boundingRect-based) ==========

qreal GlyphMetrics::inkLeft(const QString &text, const QString &fontFamily, int pixelSize) const
{
    if (text.isEmpty()) {
        return 0;
    }
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    QRectF ink = fm.boundingRect(text);
    return ink.left();
}

qreal GlyphMetrics::inkRight(const QString &text, const QString &fontFamily, int pixelSize) const
{
    if (text.isEmpty()) {
        return 0;
    }
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    QRectF ink = fm.boundingRect(text);
    return ink.left() + ink.width();
}

qreal GlyphMetrics::maxInkRight(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxRight = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        if (!text.isEmpty()) {
            QRectF ink = fm.boundingRect(text);
            qreal right = ink.left() + ink.width();
            if (right > maxRight) {
                maxRight = right;
            }
        }
    }
    return qCeil(maxRight);
}

qreal GlyphMetrics::minInkLeft(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal minLeft = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        if (!text.isEmpty()) {
            QRectF ink = fm.boundingRect(text);
            if (ink.left() < minLeft) {
                minLeft = ink.left();
            }
        }
    }
    // Return as positive value (how far ink extends left of origin)
    return qCeil(-minLeft);
}

qreal GlyphMetrics::inkWidth(const QString &text, const QString &fontFamily, int pixelSize) const
{
    if (text.isEmpty()) {
        return 0;
    }
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);
    QRectF ink = fm.boundingRect(text);
    return ink.width();
}

qreal GlyphMetrics::maxInkWidth(const QVariantList &values, int decimalPoints, const QString &fontFamily, int pixelSize) const
{
    QFont font(fontFamily);
    font.setPixelSize(pixelSize);
    QFontMetricsF fm(font);

    qreal maxWidth = 0;
    for (const QVariant &v : values) {
        QString text = QString::number(v.toDouble(), 'f', decimalPoints);
        if (!text.isEmpty()) {
            QRectF ink = fm.boundingRect(text);
            if (ink.width() > maxWidth) {
                maxWidth = ink.width();
            }
        }
    }
    return qCeil(maxWidth);
}
