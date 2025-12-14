import QtQuick 2.6
import Sailfish.Silica 1.0

Column {
    id: root
    
    property string label: ""
    property string placeholder: ""
    property string value: ""
    property string errorText: ""
    property bool enabled: true
    property int inputMethodHints: Qt.ImhNone
    
    width: parent.width - Theme.horizontalPageMargin * 2
    x: Theme.horizontalPageMargin
    spacing: Theme.paddingSmall
    
    TextField {
        id: textField
        width: parent.width
        label: root.label
        placeholderText: root.placeholder
        text: root.value
        enabled: root.enabled
        inputMethodHints: root.inputMethodHints
        
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        EnterKey.onClicked: focus = false
        
        // Подсветка ошибки
        color: root.errorText ? "red" : Theme.primaryColor
        
        onTextChanged: {
            root.value = text
        }
    }
    
    Label {
        visible: root.errorText.length > 0
        text: root.errorText
        color: "red"
        font.pixelSize: Theme.fontSizeExtraSmall
        width: parent.width
        wrapMode: Text.WordWrap
    }
}

