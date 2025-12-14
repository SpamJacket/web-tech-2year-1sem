import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property var clients: []
    
    radius: 12
    color: "#1a1a2e"
    border.color: "#2d3561"
    border.width: 1
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 12
        
        // Заголовок
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Text {
                text: "👥"
                font.pixelSize: 16
            }
            
            Text {
                text: "Подключенные клиенты"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "#e2e8f0"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            Item { Layout.fillWidth: true }
            
            Rectangle {
                width: 28
                height: 20
                radius: 10
                color: "#8b5cf620"
                
                Text {
                    anchors.centerIn: parent
                    text: clients.length.toString()
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: "#8b5cf6"
                    font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                }
            }
        }
        
        // Список клиентов
        ListView {
            id: clientListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: clients
            spacing: 6
            clip: true
            
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AsNeeded
            }
            
            delegate: Rectangle {
                width: clientListView.width
                height: 44
                radius: 8
                color: mouseArea.containsMouse ? "#0f172a" : "transparent"
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10
                    
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#10b981"
                        
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.4; duration: 1000 }
                            NumberAnimation { to: 1.0; duration: 1000 }
                        }
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: modelData
                        font.pixelSize: 13
                        color: "#e2e8f0"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        text: "🔗"
                        font.pixelSize: 12
                        opacity: mouseArea.containsMouse ? 1.0 : 0.5
                    }
                }
            }
            
            // Плейсхолдер
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 20
                height: 80
                radius: 8
                color: "#0f172a"
                visible: clients.length === 0
                
                Column {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "📭"
                        font.pixelSize: 24
                        opacity: 0.5
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Нет подключений"
                        font.pixelSize: 12
                        color: "#64748b"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
        }
    }
}


