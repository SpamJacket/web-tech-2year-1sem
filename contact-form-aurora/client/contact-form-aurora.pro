# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in rpm/contact-form-aurora.spec must be changed
#   - translation filenames have to be changed

# Имя пакета в формате reverse domain notation (требование Aurora OS)
TARGET = ru.aurora.contactform

# Используем auroraapp для Aurora OS 5.x
CONFIG += auroraapp

QT += websockets

SOURCES += src/main.cpp \
    src/websocketclient.cpp

HEADERS += src/websocketclient.h

DISTFILES += qml/ru.aurora.contactform.qml \
    qml/pages/ContactPage.qml \
    qml/components/InputField.qml \
    qml/components/TextAreaField.qml \
    qml/components/SubmitButton.qml \
    qml/components/Alert.qml \
    rpm/ru.aurora.contactform.spec \
    rpm/ru.aurora.contactform.yaml \
    ru.aurora.contactform.desktop \
    icons/ru.aurora.contactform.svg

# Иконки приложения для разных разрешений экрана
AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

# Пути к иконкам (sailfishapp автоматически ищет в icons/<size>/ru.aurora.contactform.png)
# icons/86x86/ru.aurora.contactform.png   - для устройств с низким разрешением
# icons/108x108/ru.aurora.contactform.png - стандартное разрешение
# icons/128x128/ru.aurora.contactform.png - высокое разрешение
# icons/172x172/ru.aurora.contactform.png - для планшетов и высокого DPI

# to disable building translations every time, comment out the
# temporary comment out TRANSLATIONS line and uncomment the next line
# TRANSLATIONS_DISABLED = YES
#TRANSLATIONS += translations/contact-form-aurora.ts

