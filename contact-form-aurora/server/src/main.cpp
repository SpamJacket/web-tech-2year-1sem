#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <auroraapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <QtQml>

#include "contactserver.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // Регистрируем ContactServer как тип QML до создания приложения
    qmlRegisterType<ContactServer>("ContactFormServer", 1, 0, "ContactServer");

    // Используем стандартный запуск Aurora/Sailfish приложения
    // Автоматически загружает qml/ru.aurora.contactform.server.qml (по имени TARGET)
    return Aurora::Application::main(argc, argv);
}
