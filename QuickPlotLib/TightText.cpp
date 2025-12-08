// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#include "TightText.hpp"

#include <QPainter>
#include <QFontMetricsF>

TightText::TightText(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    updateMetrics();
}

void TightText::paint(QPainter *painter)
{
    if (m_text.isEmpty()) {
        return;
    }

    QFont font(m_fontFamily, m_pixelSize);
    font.setPixelSize(m_pixelSize);
    font.setWeight(static_cast<QFont::Weight>(m_fontWeight));

    painter->setFont(font);
    painter->setPen(m_color);

    // Draw text at baseline position
    // The baseline is at y = m_ascent (since we start from top of bounding box)
    painter->drawText(QPointF(0, m_ascent), m_text);
}

void TightText::setText(const QString &text)
{
    if (m_text == text) {
        return;
    }
    m_text = text;
    updateMetrics();
    emit textChanged();
    update();
}

void TightText::setColor(const QColor &color)
{
    if (m_color == color) {
        return;
    }
    m_color = color;
    emit colorChanged();
    update();
}

void TightText::setFontFamily(const QString &family)
{
    if (m_fontFamily == family) {
        return;
    }
    m_fontFamily = family;
    updateMetrics();
    emit fontChanged();
    update();
}

void TightText::setPixelSize(int size)
{
    if (m_pixelSize == size) {
        return;
    }
    m_pixelSize = size;
    updateMetrics();
    emit fontChanged();
    update();
}

void TightText::setFontWeight(int weight)
{
    if (m_fontWeight == weight) {
        return;
    }
    m_fontWeight = weight;
    updateMetrics();
    emit fontChanged();
    update();
}

void TightText::updateMetrics()
{
    QFont font(m_fontFamily, m_pixelSize);
    font.setPixelSize(m_pixelSize);
    font.setWeight(static_cast<QFont::Weight>(m_fontWeight));

    QFontMetricsF fm(font);

    // Get exact font metrics
    m_ascent = fm.ascent();
    m_descent = fm.descent();

    // Calculate text width using horizontal advance (more accurate than boundingRect)
    m_textWidth = fm.horizontalAdvance(m_text);

    // Set item size to exact glyph bounds
    // Height = ascent + descent (no leading, no extra padding)
    // Width = horizontal advance of the text
    setImplicitWidth(m_textWidth);
    setImplicitHeight(m_ascent + m_descent);
}
