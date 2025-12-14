import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property bool serverRunning: false
    property string serverAddress: ""
    property int clientCount: 0
    property int messageCount: 0
    
    height: 80
    radius: 12
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#1a1a2e" }
        GradientStop { position: 1.0; color: "#16213e" }
    }
    
    border.color: "#2d3561"
    border.width: 1
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 30
        
        // Лого и название
        RowLayout {
            spacing: 15
            
            Rectangle {
                width: 50
                height: 50
                radius: 12
                color: serverRunning ? "#10b981" : "#6b7280"
                
                Text {
                    anchors.centerIn: parent
                    text: "📧"
                    font.pixelSize: 24
                }
                
                SequentialAnimation on opacity {
                    running: serverRunning
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.6; duration: 1000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                }
            }
            
            ColumnLayout {
                spacing: 2
                
                Text {
                    text: "Contact Form Admin"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: "#e2e8f0"
                    font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                }
                
                Text {
                    text: serverRunning ? serverAddress : "Сервер остановлен"
                    font.pixelSize: 12
                    color: serverRunning ? "#10b981" : "#6b7280"
                    font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                }
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Статистика
        RowLayout {
            spacing: 25
            
            StatBadge {
                icon: "👥"
                value: clientCount
                label: "Клиентов"
                color: "#8b5cf6"
            }
            
            StatBadge {
                icon: "📨"
                value: messageCount
                label: "Сообщений"
                color: "#06b6d4"
            }
            
            // Статус индикатор
            Rectangle {
                width: 100
                height: 40
                radius: 20
                color: serverRunning ? "#10b98120" : "#ef444420"
                border.color: serverRunning ? "#10b981" : "#ef4444"
                border.width: 1
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Rectangle {
                        width: 10
                        height: 10
                        radius: 5
                        color: serverRunning ? "#10b981" : "#ef4444"
                        
                        SequentialAnimation on opacity {
                            running: serverRunning
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.3; duration: 800 }
                            NumberAnimation { to: 1.0; duration: 800 }
                        }
                    }
                    
                    Text {
                        text: serverRunning ? "Online" : "Offline"
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: serverRunning ? "#10b981" : "#ef4444"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
        }
    }
}


