#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <auroraapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QtQml>

#include "websocketclient.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // Регистрируем WebSocketClient как тип QML до создания приложения
    qmlRegisterType<WebSocketClient>("ContactForm", 1, 0, "WebSocketClient");

    // Используем стандартный запуск Aurora/Sailfish приложения
    // Автоматически загружает qml/ru.aurora.contactform.qml (по имени TARGET)
    return Aurora::Application::main(argc, argv);
}
