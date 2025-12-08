// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#pragma once

#include <QtGlobal>

#if defined(QPL_LIBRARY)
#define QPL_EXPORT Q_DECL_EXPORT
#else
#define QPL_EXPORT Q_DECL_IMPORT
#endif

