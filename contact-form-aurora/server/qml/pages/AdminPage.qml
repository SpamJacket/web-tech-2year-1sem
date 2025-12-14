import QtQuick 2.6
import Sailfish.Silica 1.0
import ContactFormServer 1.0

Page {
    id: adminPage
    
    ContactServer {
        id: server
        
        onLogMessage: function(message, level) {
            logModel.insert(0, {
                "text": message,
                "level": level,
                "time": new Date().toLocaleTimeString()
            })
            if (logModel.count > 100) {
                logModel.remove(100)
            }
        }
        
        onMessageReceived: function(name, email, message, clientAddress, isValid, errors) {
            messagesModel.insert(0, {
                "name": name,
                "email": email,
                "message": message,
                "clientAddress": clientAddress,
                "isValid": isValid,
                "errors": errors,
                "timestamp": new Date().toLocaleString()
            })
        }
    }
    
    ListModel { id: logModel }
    ListModel { id: messagesModel }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge
        
        VerticalScrollDecorator {}
        
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium
            
            PageHeader {
                title: "Admin Panel"
            }
            
            // Статус сервера
            SectionHeader {
                text: "Статус сервера"
            }
            
            Row {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium
                
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: server.running ? "#10b981" : "#ef4444"
                    anchors.verticalCenter: parent.verticalCenter
                    
                    SequentialAnimation on opacity {
                        running: server.running
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.4; duration: 800 }
                        NumberAnimation { to: 1.0; duration: 800 }
                    }
                }
                
                Label {
                    text: server.running ? "Online: " + server.serverAddress : "Offline"
                    color: server.running ? "#10b981" : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            
            // Статистика
            Row {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingLarge
                
                Label {
                    text: "👥 Клиентов: " + server.clientCount
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.highlightColor
                }
                
                Label {
                    text: "📨 Сообщений: " + server.messageCount
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.highlightColor
                }
            }
            
            // Управление сервером
            SectionHeader {
                text: "Управление"
            }
            
            TextField {
                id: hostField
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                label: "Адрес"
                text: "0.0.0.0"
                enabled: !server.running
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: portField.focus = true
            }
            
            TextField {
                id: portField
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                label: "Порт"
                text: "8080"
                enabled: !server.running
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
            
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: server.running ? "⏹ Остановить" : "▶ Запустить"
                onClicked: {
                    if (server.running) {
                        server.stop()
                    } else {
                        server.start(hostField.text, parseInt(portField.text))
                    }
                }
            }
            
            // Доступные адреса
            SectionHeader {
                text: "Доступные адреса"
                visible: server.running
            }
            
            Repeater {
                model: server.getLocalIpAddresses()
                
                Label {
                    width: parent.width - Theme.horizontalPageMargin * 2
                    x: Theme.horizontalPageMargin
                    text: "ws://" + modelData + ":" + portField.text
                    font.pixelSize: Theme.fontSizeSmall
                    color: "#06b6d4"
                }
            }
            
            // Подключенные клиенты
            SectionHeader {
                text: "Подключенные клиенты (" + server.clientCount + ")"
            }
            
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                text: server.clientCount === 0 ? "Нет подключений" : ""
                visible: server.clientCount === 0
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }
            
            Repeater {
                model: server.connectedClients
                
                Row {
                    width: parent.width - Theme.horizontalPageMargin * 2
                    x: Theme.horizontalPageMargin
                    spacing: Theme.paddingSmall
                    
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#10b981"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Label {
                        text: modelData
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }
            
            // Полученные сообщения
            SectionHeader {
                text: "Сообщения (" + messagesModel.count + ")"
            }
            
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                text: messagesModel.count === 0 ? "Сообщений пока нет" : ""
                visible: messagesModel.count === 0
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }
            
            Repeater {
                model: messagesModel
                
                Rectangle {
                    width: parent.width - Theme.horizontalPageMargin * 2
                    x: Theme.horizontalPageMargin
                    height: msgColumn.height + Theme.paddingMedium * 2
                    radius: 8
                    color: model.isValid ? "#0f172a" : "#1c0a0a"
                    border.color: model.isValid ? "#334155" : "#7f1d1d"
                    border.width: 1
                    
                    Column {
                        id: msgColumn
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Theme.paddingMedium
                        spacing: Theme.paddingSmall
                        
                        Row {
                            spacing: Theme.paddingSmall
                            
                            Label {
                                text: model.isValid ? "✓" : "✗"
                                color: model.isValid ? "#10b981" : "#ef4444"
                                font.bold: true
                            }
                            
                            Label {
                                text: model.name
                                font.bold: true
                            }
                            
                            Label {
                                text: "<" + model.email + ">"
                                color: "#06b6d4"
                                font.pixelSize: Theme.fontSizeExtraSmall
                            }
                        }
                        
                        Label {
                            width: parent.width
                            text: model.message
                            wrapMode: Text.WordWrap
                            font.pixelSize: Theme.fontSizeSmall
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                        
                        Label {
                            text: model.errors
                            visible: !model.isValid && model.errors.length > 0
                            color: "#fca5a5"
                            font.pixelSize: Theme.fontSizeExtraSmall
                            wrapMode: Text.WordWrap
                            width: parent.width
                        }
                        
                        Label {
                            text: model.timestamp + " • " + model.clientAddress
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                        }
                    }
                }
            }
            
            // Журнал событий
            SectionHeader {
                text: "Журнал (" + logModel.count + ")"
            }
            
            Repeater {
                model: logModel
                
                Label {
                    width: parent.width - Theme.horizontalPageMargin * 2
                    x: Theme.horizontalPageMargin
                    text: model.text
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: Text.WordWrap
                    color: {
                        switch (model.level) {
                            case "error": return "#fca5a5"
                            case "warning": return "#fcd34d"
                            case "success": return "#86efac"
                            default: return Theme.secondaryColor
                        }
                    }
                }
            }
            
            Item {
                width: 1
                height: Theme.paddingLarge
            }
        }
    }
}

