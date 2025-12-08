// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#include "Glyph.hpp"

#include <QPainter>
#include <QFontMetricsF>
#include <QSGSimpleTextureNode>
#include <QQuickWindow>

Glyph::Glyph(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    updateMetrics();
}

Glyph::~Glyph() = default;

void Glyph::setText(const QString &text)
{
    if (m_text == text) {
        return;
    }
    m_text = text;
    updateMetrics();
    m_imageDirty = true;
    m_textureDirty = true;
    emit textChanged();
    update();
}

void Glyph::setColor(const QColor &color)
{
    if (m_color == color) {
        return;
    }
    m_color = color;
    m_imageDirty = true;
    m_textureDirty = true;
    emit colorChanged();
    update();
}

void Glyph::setFontFamily(const QString &family)
{
    if (m_fontFamily == family) {
        return;
    }
    m_fontFamily = family;
    updateMetrics();
    m_imageDirty = true;
    m_textureDirty = true;
    emit fontChanged();
    update();
}

void Glyph::setPixelSize(int size)
{
    if (m_pixelSize == size) {
        return;
    }
    m_pixelSize = size;
    updateMetrics();
    m_imageDirty = true;
    m_textureDirty = true;
    emit fontChanged();
    update();
}

void Glyph::setFontWeight(int weight)
{
    if (m_fontWeight == weight) {
        return;
    }
    m_fontWeight = weight;
    updateMetrics();
    m_imageDirty = true;
    m_textureDirty = true;
    emit fontChanged();
    update();
}

void Glyph::updateMetrics()
{
    QFont font(m_fontFamily);
    font.setPixelSize(m_pixelSize);
    font.setWeight(static_cast<QFont::Weight>(m_fontWeight));

    QFontMetricsF fm(font);

    // Get exact font metrics
    m_ascent = fm.ascent();
    m_descent = fm.descent();

    // Calculate text width using horizontal advance
    m_textWidth = fm.horizontalAdvance(m_text);

    // Set item size to exact glyph bounds
    // Height = ascent + descent (no leading, no extra padding)
    // Width = horizontal advance of the text
    setImplicitWidth(qCeil(m_textWidth));
    setImplicitHeight(qCeil(m_ascent + m_descent));
}

void Glyph::renderToImage()
{
    if (!m_imageDirty) {
        return;
    }

    int imgWidth = qCeil(m_textWidth);
    int imgHeight = qCeil(m_ascent + m_descent);

    if (imgWidth <= 0 || imgHeight <= 0 || m_text.isEmpty()) {
        m_renderedImage = QImage();
        m_imageDirty = false;
        return;
    }

    // Create image with transparent background
    m_renderedImage = QImage(imgWidth, imgHeight, QImage::Format_ARGB32_Premultiplied);
    m_renderedImage.fill(Qt::transparent);

    QPainter painter(&m_renderedImage);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setRenderHint(QPainter::TextAntialiasing, true);

    QFont font(m_fontFamily);
    font.setPixelSize(m_pixelSize);
    font.setWeight(static_cast<QFont::Weight>(m_fontWeight));

    painter.setFont(font);
    painter.setPen(m_color);

    // Draw text at baseline position (y = ascent)
    painter.drawText(QPointF(0, m_ascent), m_text);

    painter.end();

    m_imageDirty = false;
}

QSGNode *Glyph::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    if (m_text.isEmpty() || width() <= 0 || height() <= 0) {
        delete oldNode;
        return nullptr;
    }

    // Render text to image if dirty
    renderToImage();

    if (m_renderedImage.isNull()) {
        delete oldNode;
        return nullptr;
    }

    QSGSimpleTextureNode *node = static_cast<QSGSimpleTextureNode *>(oldNode);

    if (!node) {
        node = new QSGSimpleTextureNode();
        node->setFiltering(QSGTexture::Linear);
        m_textureDirty = true;
    }

    if (m_textureDirty && window()) {
        // Delete old texture if exists
        if (node->texture()) {
            delete node->texture();
        }

        // Create new texture from rendered image
        QSGTexture *texture = window()->createTextureFromImage(m_renderedImage);
        node->setTexture(texture);
        node->setOwnsTexture(true);
        m_textureDirty = false;
    }

    node->setRect(boundingRect());

    return node;
}
