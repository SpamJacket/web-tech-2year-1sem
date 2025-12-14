import QtQuick 2.6
import Sailfish.Silica 1.0

Item {
    id: root
    
    property string text: "Отправить"
    property bool enabled: true
    property bool loading: false
    
    signal clicked()
    
    width: parent.width - Theme.horizontalPageMargin * 2
    x: Theme.horizontalPageMargin
    height: button.height + Theme.paddingMedium * 2
    
    Button {
        id: button
        anchors.centerIn: parent
        text: root.loading ? "" : root.text
        enabled: root.enabled && !root.loading
        preferredWidth: Theme.buttonWidthLarge
        
        onClicked: root.clicked()
        
        BusyIndicator {
            anchors.centerIn: parent
            running: root.loading
            visible: root.loading
            size: BusyIndicatorSize.Small
        }
    }
}

