# Contact Form WebSocket Server for Aurora
# Admin Panel with GUI for managing client connections
#
# Если имя TARGET изменено, нужно также изменить:
#   - соответствующий QML файл (qml/ru.aurora.contactform.server.qml)
#   - имена файлов иконок
#   - имена файлов в rpm/

# Имя пакета в формате reverse domain notation (как у клиента)
TARGET = ru.aurora.contactform.server

# Используем auroraapp для Aurora OS 5.x
CONFIG += auroraapp

QT += websockets network

SOURCES += \
    src/main.cpp \
    src/contactserver.cpp \
    src/contactvalidator.cpp

HEADERS += \
    src/contactserver.h \
    src/contactvalidator.h

DISTFILES += \
    qml/ru.aurora.contactform.server.qml \
    qml/pages/AdminPage.qml \
    rpm/ru.aurora.contactform.server.spec \
    rpm/ru.aurora.contactform.server.yaml \
    icons/ru.aurora.contactform.server.svg

# Иконки приложения для разных разрешений экрана
AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

