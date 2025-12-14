import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property alias model: logListView.model
    
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
                text: "📋"
                font.pixelSize: 16
            }
            
            Text {
                text: "Журнал событий"
                font.pixelSize: 14
                font.weight: Font.Bold
                color: "#e2e8f0"
                font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
            }
            
            Item { Layout.fillWidth: true }
            
            // Кнопка очистки
            Rectangle {
                width: 24
                height: 24
                radius: 6
                color: clearMouseArea.containsMouse ? "#374151" : "transparent"
                visible: logListView.count > 0
                
                Text {
                    anchors.centerIn: parent
                    text: "🗑"
                    font.pixelSize: 12
                    opacity: clearMouseArea.containsMouse ? 1.0 : 0.6
                }
                
                MouseArea {
                    id: clearMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        model.clear()
                    }
                }
            }
        }
        
        // Список логов
        ListView {
            id: logListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            clip: true
            
            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AsNeeded
            }
            
            delegate: Rectangle {
                width: logListView.width
                height: logText.height + 8
                radius: 4
                color: {
                    switch (model.level) {
                        case "error": return "#7f1d1d20"
                        case "warning": return "#78350f20"
                        case "success": return "#14532d20"
                        default: return "transparent"
                    }
                }
                
                Text {
                    id: logText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 4
                    text: model.text || ""
                    font.pixelSize: 11
                    color: {
                        switch (model.level) {
                            case "error": return "#fca5a5"
                            case "warning": return "#fcd34d"
                            case "success": return "#86efac"
                            default: return "#94a3b8"
                        }
                    }
                    font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    wrapMode: Text.WordWrap
                }
            }
            
            // Плейсхолдер
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 20
                height: 60
                radius: 8
                color: "#0f172a"
                visible: logListView.count === 0
                
                Column {
                    anchors.centerIn: parent
                    spacing: 6
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "📋"
                        font.pixelSize: 20
                        opacity: 0.4
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Журнал пуст"
                        font.pixelSize: 11
                        color: "#64748b"
                        font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
                    }
                }
            }
        }
    }
}


