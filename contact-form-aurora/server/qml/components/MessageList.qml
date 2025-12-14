import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property alias model: messageListView.model
    
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
                text: "📨"
                font.pixelSize: 16
            }
            
            Text {
                text: "Полученные сообщения"
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
                color: "#06b6d420"
                
                Text {
                    anchors.centerIn: parent
                    text: messageListView.count.toString()
                    font.pixelSize: 11
                    font.weight: Font.Bold
                    color: "#06b6d4"
                    font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                }
            }
        }
        
        // Список сообщений
        ListView {
            id: messageListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true
            
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AsNeeded
            }
            
            delegate: Rectangle {
                width: messageListView.width
                height: contentColumn.height + 20
                radius: 10
                color: model.isValid ? "#0f172a" : "#1c0a0a"
                border.color: model.isValid ? "#334155" : "#7f1d1d"
                border.width: 1
                
                ColumnLayout {
                    id: contentColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 10
                    spacing: 8
                    
                    // Заголовок карточки
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Rectangle {
                            width: 22
                            height: 22
                            radius: 11
                            color: model.isValid ? "#10b98120" : "#ef444420"
                            
                            Text {
                                anchors.centerIn: parent
                                text: model.isValid ? "✓" : "✗"
                                font.pixelSize: 12
                                font.weight: Font.Bold
                                color: model.isValid ? "#10b981" : "#ef4444"
                            }
                        }
                        
                        Text {
                            Layout.fillWidth: true
                            text: model.name || "Без имени"
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            color: "#e2e8f0"
                            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                            elide: Text.ElideRight
                        }
                        
                        Text {
                            text: model.clientAddress || ""
                            font.pixelSize: 10
                            color: "#64748b"
                            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                        }
                    }
                    
                    // Email
                    RowLayout {
                        spacing: 6
                        
                        Text {
                            text: "📧"
                            font.pixelSize: 11
                        }
                        
                        Text {
                            text: model.email || ""
                            font.pixelSize: 12
                            color: "#06b6d4"
                            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                        }
                    }
                    
                    // Сообщение
                    Rectangle {
                        Layout.fillWidth: true
                        height: messageText.height + 16
                        radius: 6
                        color: "#0a0a0f"
                        
                        Text {
                            id: messageText
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 8
                            text: model.message || ""
                            font.pixelSize: 12
                            color: "#cbd5e1"
                            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }
                    }
                    
                    // Ошибки (если есть)
                    Rectangle {
                        Layout.fillWidth: true
                        height: errorText.height + 12
                        radius: 6
                        color: "#7f1d1d20"
                        border.color: "#7f1d1d"
                        border.width: 1
                        visible: !model.isValid && model.errors && model.errors.length > 0
                        
                        Text {
                            id: errorText
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 6
                            text: "⚠️ " + (model.errors || "")
                            font.pixelSize: 11
                            color: "#fca5a5"
                            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                            wrapMode: Text.WordWrap
                        }
                    }
                    
                    // Время
                    Text {
                        text: model.timestamp || ""
                        font.pixelSize: 10
                        color: "#475569"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
            
            // Плейсхолдер
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 40
                height: 120
                radius: 12
                color: "#0f172a"
                visible: messageListView.count === 0
                
                Column {
                    anchors.centerIn: parent
                    spacing: 12
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "📭"
                        font.pixelSize: 36
                        opacity: 0.4
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Сообщений пока нет"
                        font.pixelSize: 14
                        color: "#64748b"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Ожидаем данные от клиентов Aurora..."
                        font.pixelSize: 11
                        color: "#475569"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
        }
    }
}


