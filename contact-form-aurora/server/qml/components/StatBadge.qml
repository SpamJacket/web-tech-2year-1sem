import QtQuick 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: root
    
    property string icon: ""
    property int value: 0
    property string label: ""
    property color color: "#8b5cf6"
    
    spacing: 10
    
    Rectangle {
        width: 36
        height: 36
        radius: 8
        color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.15)
        
        Text {
            anchors.centerIn: parent
            text: root.icon
            font.pixelSize: 16
        }
    }
    
    Column {
        spacing: 0
        
        Text {
            text: root.value.toString()
            font.pixelSize: 18
            font.weight: Font.Bold
            color: "#e2e8f0"
            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
        }
        
        Text {
            text: root.label
            font.pixelSize: 11
            color: "#64748b"
            font.family: "JetBrains Mono, SF Mono, Menlo, monospace"
        }
    }
}


