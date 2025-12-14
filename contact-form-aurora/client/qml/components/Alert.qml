import QtQuick 2.6
import Sailfish.Silica 1.0

Rectangle {
    id: root
    
    property string message: ""
    property bool isSuccess: true
    
    visible: message.length > 0
    height: visible ? label.height + Theme.paddingMedium * 2 : 0
    radius: Theme.paddingSmall
    color: isSuccess ? Qt.rgba(0.2, 0.8, 0.4, 0.2) : Qt.rgba(0.9, 0.3, 0.3, 0.2)
    border.color: isSuccess ? Qt.rgba(0.2, 0.8, 0.4, 0.6) : Qt.rgba(0.9, 0.3, 0.3, 0.6)
    border.width: 1
    
    Behavior on height {
        NumberAnimation { duration: 200 }
    }
    
    Label {
        id: label
        anchors.centerIn: parent
        width: parent.width - Theme.paddingMedium * 2
        text: root.message
        color: isSuccess ? Qt.rgba(0.1, 0.6, 0.3, 1.0) : Qt.rgba(0.8, 0.2, 0.2, 1.0)
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeSmall
    }
}

