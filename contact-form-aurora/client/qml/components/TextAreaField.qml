import QtQuick 2.6
import Sailfish.Silica 1.0

Column {
    id: root
    
    property string label: ""
    property string placeholder: ""
    property string value: ""
    property string errorText: ""
    property bool enabled: true
    
    width: parent.width - Theme.horizontalPageMargin * 2
    x: Theme.horizontalPageMargin
    spacing: Theme.paddingSmall
    
    // Синхронизация value -> text (когда value меняется снаружи)
    onValueChanged: {
        if (textArea.text !== value) {
            textArea.text = value
        }
    }
    
    Label {
        text: root.label
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
    }
    
    TextArea {
        id: textArea
        width: parent.width
        height: Math.max(Theme.itemSizeLarge * 2, implicitHeight)
        placeholderText: root.placeholder
        text: root.value
        enabled: root.enabled
        
        // Подсветка ошибки
        color: root.errorText ? "red" : Theme.primaryColor
        
        background: Rectangle {
            color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)
            radius: Theme.paddingSmall
            border.color: root.errorText ? "red" : 
                         textArea.activeFocus ? Theme.highlightColor : 
                         Theme.rgba(Theme.primaryColor, 0.3)
            border.width: 1
        }
        
        // Синхронизация text -> value (когда пользователь вводит)
        onTextChanged: {
            if (root.value !== text) {
                root.value = text
            }
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
