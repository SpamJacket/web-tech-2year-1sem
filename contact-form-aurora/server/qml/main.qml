import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ContactFormServer 1.0
import "components"

Window {
    id: mainWindow
    width: 1000
    height: 700
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: "Contact Form Admin Panel"
    color: "#0f0f23"
    
    // Шрифты
    FontLoader {
        id: mainFont
        source: "https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;600&display=swap"
    }
    
    ContactServer {
        id: server
        
        onLogMessage: function(message, level) {
            logModel.insert(0, {
                "text": message,
                "level": level,
                "time": new Date().toLocaleTimeString()
            })
            // Ограничиваем размер лога
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
        
        onClientConnected: function(address) {
            // Обновление происходит автоматически через connectedClients
        }
        
        onClientDisconnected: function(address) {
            // Обновление происходит автоматически через connectedClients
        }
    }
    
    ListModel {
        id: logModel
    }
    
    ListModel {
        id: messagesModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Заголовок
        Header {
            Layout.fillWidth: true
            serverRunning: server.running
            serverAddress: server.serverAddress
            clientCount: server.clientCount
            messageCount: server.messageCount
        }
        
        // Основной контент
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20
            
            // Левая панель - управление и клиенты
            ColumnLayout {
                Layout.preferredWidth: 320
                Layout.fillHeight: true
                spacing: 15
                
                // Управление сервером
                ServerControl {
                    Layout.fillWidth: true
                    serverRunning: server.running
                    localAddresses: server.getLocalIpAddresses()
                    
                    onStartServer: function(host, port) {
                        server.start(host, port)
                    }
                    
                    onStopServer: {
                        server.stop()
                    }
                }
                
                // Список клиентов
                ClientList {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clients: server.connectedClients
                }
            }
            
            // Центральная панель - сообщения
            MessageList {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 400
                model: messagesModel
            }
            
            // Правая панель - логи
            LogPanel {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                model: logModel
            }
        }
    }
}


