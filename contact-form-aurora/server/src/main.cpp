#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QIcon>
#include <QDir>

#include "contactserver.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Contact Form Admin Panel");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("Aurora Contact Form");
    
    // Загружаем иконку из папки icons рядом с исполняемым файлом
    QString appDir = QCoreApplication::applicationDirPath();
    QString iconPath = appDir + "/../icons/172x172/ru.aurora.contactform.server.png";
    
    // Если PNG не найден, пробуем SVG
    if (!QFile::exists(iconPath)) {
        iconPath = appDir + "/../icons/ru.aurora.contactform.server.svg";
    }
    
    // Если иконка в папке сборки не найдена, ищем в исходниках
    if (!QFile::exists(iconPath)) {
        iconPath = "icons/ru.aurora.contactform.server.svg";
    }
    
    app.setWindowIcon(QIcon(iconPath));

    // Регистрируем ContactServer как тип QML
    qmlRegisterType<ContactServer>("ContactFormServer", 1, 0, "ContactServer");

    QQmlApplicationEngine engine;
    
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);

    return app.exec();
}

