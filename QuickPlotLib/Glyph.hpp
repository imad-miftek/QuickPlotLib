// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QQuickItem>
#include <QColor>
#include <QFont>
#include <QImage>
#include <QtQml/qqmlregistration.h>

class QSGTexture;

/*!
    \qmltype Glyph
    \inqmlmodule QuickPlotLib
    \inherits QQuickItem
    \brief Renders text with pixel-perfect glyph-tight bounding box using GPU acceleration.

    Unlike QML Text, Glyph renders text without any internal padding.
    The item's width and height exactly match the rendered glyph bounds,
    enabling pixel-perfect alignment for tick labels and other precision text.

    The bounding box is computed using QFontMetricsF:
    - Width: horizontal advance of the text
    - Height: ascent + descent (no leading/padding)

    Rendering uses the Qt Quick Scene Graph with cached textures for GPU acceleration.

    \sa TickLabel, Axis
*/
class Glyph : public QQuickItem {
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
    explicit Glyph(QQuickItem *parent = nullptr);
    ~Glyph() override;

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

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *updatePaintNodeData) override;

private:
    void updateMetrics();
    void renderToImage();

    QString m_text;
    QColor m_color = Qt::black;
    QString m_fontFamily = "sans-serif";
    int m_pixelSize = 12;
    int m_fontWeight = QFont::Normal;

    // Cached metrics
    qreal m_ascent = 0;
    qreal m_descent = 0;
    qreal m_textWidth = 0;

    // Cached rendered image
    QImage m_renderedImage;
    bool m_imageDirty = true;
    bool m_textureDirty = true;
};
