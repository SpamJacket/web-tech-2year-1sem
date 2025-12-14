import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property bool serverRunning: false
    property var localAddresses: []
    
    signal startServer(string host, int port)
    signal stopServer()
    
    height: contentColumn.height + 30
    radius: 12
    color: "#1a1a2e"
    border.color: "#2d3561"
    border.width: 1
    
    ColumnLayout {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        spacing: 12
        
        // Заголовок
        RowLayout {
            spacing: 8
            
            Text {
                text: "⚙️"
                font.pixelSize: 16
            }
            
            Text {
                text: "Управление сервером"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "#e2e8f0"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
        }
        
        // Хост
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Text {
                text: "Адрес"
                font.pixelSize: 11
                color: "#64748b"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            TextField {
                id: hostField
                Layout.fillWidth: true
                text: "0.0.0.0"
                enabled: !serverRunning
                
                background: Rectangle {
                    radius: 8
                    color: hostField.enabled ? "#0f172a" : "#1e293b"
                    border.color: hostField.activeFocus ? "#8b5cf6" : "#334155"
                    border.width: 1
                }
                
                color: "#e2e8f0"
                font.pixelSize: 13
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                placeholderText: "0.0.0.0"
                placeholderTextColor: "#475569"
            }
        }
        
        // Порт
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Text {
                text: "Порт"
                font.pixelSize: 11
                color: "#64748b"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            TextField {
                id: portField
                Layout.fillWidth: true
                text: "8080"
                enabled: !serverRunning
                validator: IntValidator { bottom: 1; top: 65535 }
                
                background: Rectangle {
                    radius: 8
                    color: portField.enabled ? "#0f172a" : "#1e293b"
                    border.color: portField.activeFocus ? "#8b5cf6" : "#334155"
                    border.width: 1
                }
                
                color: "#e2e8f0"
                font.pixelSize: 13
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                placeholderText: "8080"
                placeholderTextColor: "#475569"
            }
        }
        
        // Кнопка
        Button {
            id: controlButton
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            
            text: serverRunning ? "⏹ Остановить сервер" : "▶ Запустить сервер"
            
            background: Rectangle {
                radius: 10
                color: {
                    if (controlButton.pressed) {
                        return serverRunning ? "#991b1b" : "#4c1d95"
                    }
                    if (controlButton.hovered) {
                        return serverRunning ? "#b91c1c" : "#5b21b6"
                    }
                    return serverRunning ? "#dc2626" : "#7c3aed"
                }
                
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
            
            contentItem: Text {
                text: controlButton.text
                font.pixelSize: 13
                font.weight: Font.Medium
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            onClicked: {
                if (serverRunning) {
                    root.stopServer()
                } else {
                    root.startServer(hostField.text, parseInt(portField.text))
                }
            }
        }
        
        // Локальные адреса
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: localAddresses.length > 0
            
            Text {
                text: "Доступные адреса:"
                font.pixelSize: 11
                color: "#64748b"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            Repeater {
                model: localAddresses
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    radius: 6
                    color: "#0f172a"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "ws://" + modelData + ":" + portField.text
                        font.pixelSize: 11
                        color: "#06b6d4"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
        }
    }
}


