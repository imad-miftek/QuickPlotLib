// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QQuickPaintedItem>
#include <QColor>
#include <QFont>
#include <QRawFont>
#include <QtQml/qqmlregistration.h>

/*!
    \qmltype TightText
    \inqmlmodule QuickPlotLib
    \inherits QQuickPaintedItem
    \brief Renders text with pixel-perfect glyph-tight bounding box.

    Unlike QML Text, TightText renders text without any internal padding.
    The item's width and height exactly match the rendered glyph bounds,
    enabling pixel-perfect alignment for tick labels and other precision text.

    The bounding box is computed using QRawFont glyph metrics:
    - Width: sum of glyph advances
    - Height: ascent + descent (no leading/padding)

    \sa TickLabel, Axis
*/
class TightText : public QQuickPaintedItem {
    Q_OBJECT
    QML_ELEMENT

    /*!
        The text to display.
    */
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

    /*!
        The text color.
    */
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)

    /*!
        The font family name.
    */
    Q_PROPERTY(QString fontFamily READ fontFamily WRITE setFontFamily NOTIFY fontChanged)

    /*!
        The font pixel size.
    */
    Q_PROPERTY(int pixelSize READ pixelSize WRITE setPixelSize NOTIFY fontChanged)

    /*!
        The font weight (e.g., QFont::Normal, QFont::Bold).
    */
    Q_PROPERTY(int fontWeight READ fontWeight WRITE setFontWeight NOTIFY fontChanged)

    /*!
        The exact ascent of the font (distance from baseline to top of glyphs).
        Read-only, computed from font metrics.
    */
    Q_PROPERTY(qreal ascent READ ascent NOTIFY fontChanged)

    /*!
        The exact descent of the font (distance from baseline to bottom of glyphs).
        Read-only, computed from font metrics.
    */
    Q_PROPERTY(qreal descent READ descent NOTIFY fontChanged)

public:
    explicit TightText(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    QString text() const { return m_text; }
    void setText(const QString &text);

    QColor color() const { return m_color; }
    void setColor(const QColor &color);

    QString fontFamily() const { return m_fontFamily; }
    void setFontFamily(const QString &family);

    int pixelSize() const { return m_pixelSize; }
    void setPixelSize(int size);

    int fontWeight() const { return m_fontWeight; }
    void setFontWeight(int weight);

    qreal ascent() const { return m_ascent; }
    qreal descent() const { return m_descent; }

signals:
    void textChanged();
    void colorChanged();
    void fontChanged();

private:
    void updateMetrics();

    QString m_text;
    QColor m_color = Qt::black;
    QString m_fontFamily = "sans-serif";
    int m_pixelSize = 12;
    int m_fontWeight = QFont::Normal;

    // Cached metrics
    qreal m_ascent = 0;
    qreal m_descent = 0;
    qreal m_textWidth = 0;
};
