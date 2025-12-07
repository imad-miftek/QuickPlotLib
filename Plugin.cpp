// SPDX-FileCopyrightText: Copyright (c) 2025 QuickPlotLib contributors
// SPDX-License-Identifier: MIT

#include <QtQml/qqmlextensionplugin.h>

extern void qml_register_types_QuickPlotLib();
Q_GHS_KEEP_REFERENCE(qml_register_types_QuickPlotLib)

class QuickPlotLibPlugin : public QQmlEngineExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

   public:
    QuickPlotLibPlugin(QObject *parent = nullptr) : QQmlEngineExtensionPlugin(parent) {
        volatile auto registration = &qml_register_types_QuickPlotLib;
        Q_UNUSED(registration)
    }
};

#include "Plugin.moc"

