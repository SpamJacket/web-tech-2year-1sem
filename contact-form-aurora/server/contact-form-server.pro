# Contact Form WebSocket Server for Aurora
# Admin Panel with GUI for managing client connections

# Имя пакета в формате reverse domain notation (как у клиента)
TARGET = ru.aurora.contactform.server

QT += core websockets network quick qml svg

CONFIG += c++17

SOURCES += \
    src/main.cpp \
    src/contactserver.cpp \
    src/contactvalidator.cpp

HEADERS += \
    src/contactserver.h \
    src/contactvalidator.h

RESOURCES += \
    qml/qml.qrc

DISTFILES += \
    icons/ru.aurora.contactform.server.svg

# Иконки приложения для разных разрешений экрана
# icons/86x86/ru.aurora.contactform.server.png   - для устройств с низким разрешением
# icons/108x108/ru.aurora.contactform.server.png - стандартное разрешение
# icons/128x128/ru.aurora.contactform.server.png - высокое разрешение
# icons/172x172/ru.aurora.contactform.server.png - для планшетов и высокого DPI

# Default rules for deployment
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

