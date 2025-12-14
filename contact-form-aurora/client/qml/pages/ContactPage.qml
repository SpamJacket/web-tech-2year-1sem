import QtQuick 2.6
import Sailfish.Silica 1.0
import ContactForm 1.0
import "../components"

Page {
    id: contactPage
    
    // Ошибки валидации
    property string nameError: ""
    property string emailError: ""
    property string messageError: ""
    
    // Статус
    property bool isSubmitting: false
    property string submitStatus: "" // "success", "error", ""
    property string successMessage: ""
    
    WebSocketClient {
        id: wsClient
        serverUrl: serverUrlField.text || "ws://192.168.1.100:8080"
        
        onWelcomeReceived: function(msg) {
            console.log("Welcome:", msg)
        }
        
        onContactFormSuccess: function(msg) {
            console.log("Success:", msg)
            isSubmitting = false
            submitStatus = "success"
            successMessage = msg
            // Очищаем форму после успешной отправки
            nameField.text = ""
            emailField.text = ""
            messageField.text = ""
            nameError = ""
            emailError = ""
            messageError = ""
        }
        
        onContactFormError: function(nameErr, emailErr, messageErr) {
            console.log("Error:", nameErr, emailErr, messageErr)
            isSubmitting = false
            submitStatus = "error"
            nameError = nameErr
            emailError = emailErr
            messageError = messageErr
        }
        
        onConnectionError: function(err) {
            console.log("Connection error:", err)
            isSubmitting = false
            submitStatus = "error"
            connectionErrorLabel.text = err
            connectionErrorLabel.visible = true
        }
        
        onConnectedChanged: {
            if (connected) {
                connectionErrorLabel.visible = false
            }
        }
    }
    
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge
        
        VerticalScrollDecorator {}
        
        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium
            
            PageHeader {
                title: "Контактная форма"
            }
            
            // Настройки подключения
            SectionHeader {
                text: "Подключение к серверу"
            }
            
            TextField {
                id: serverUrlField
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                label: "Адрес сервера (WebSocket)"
                placeholderText: "ws://192.168.1.100:8080"
                text: "ws://192.168.1.100:8080"
                inputMethodHints: Qt.ImhUrlCharactersOnly
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
            
            Row {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium
                
                Button {
                    text: wsClient.connected ? "Отключиться" : 
                          wsClient.connecting ? "Подключение..." : "Подключиться"
                    enabled: !wsClient.connecting
                    onClicked: {
                        if (wsClient.connected) {
                            wsClient.disconnectFromServer()
                        } else {
                            wsClient.connectToServer()
                        }
                    }
                }
                
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: wsClient.connected ? "● Подключено" : "○ Не подключено"
                    color: wsClient.connected ? "green" : Theme.secondaryColor
                }
            }
            
            Label {
                id: connectionErrorLabel
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                visible: false
                color: "red"
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }
            
            // Форма контакта
            SectionHeader {
                text: "Данные формы"
            }
            
            // Сообщение об успехе
            Alert {
                visible: submitStatus === "success"
                message: successMessage
                isSuccess: true
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
            }
            
            // Поле Имя
            InputField {
                id: nameField
                label: "Имя"
                placeholder: "Введите ваше имя"
                errorText: nameError
                enabled: !isSubmitting && wsClient.connected
                
                onTextChanged: {
                    if (nameError) nameError = ""
                }
            }
            
            // Поле Email
            InputField {
                id: emailField
                label: "Email"
                placeholder: "your@email.com"
                errorText: emailError
                inputMethodHints: Qt.ImhEmailCharactersOnly
                enabled: !isSubmitting && wsClient.connected
                
                onTextChanged: {
                    if (emailError) emailError = ""
                }
            }
            
            // Поле Сообщение
            TextAreaField {
                id: messageField
                label: "Сообщение"
                placeholder: "Введите ваше сообщение..."
                errorText: messageError
                enabled: !isSubmitting && wsClient.connected
                
                onTextChanged: {
                    if (messageError) messageError = ""
                }
            }
            
            // Кнопка отправки
            SubmitButton {
                text: isSubmitting ? "Отправка..." : "Отправить"
                enabled: !isSubmitting && wsClient.connected && 
                         nameField.text.length > 0 && 
                         emailField.text.length > 0 && 
                         messageField.text.length > 0
                loading: isSubmitting
                
                onClicked: {
                    isSubmitting = true
                    submitStatus = ""
                    nameError = ""
                    emailError = ""
                    messageError = ""
                    
                    wsClient.submitContactForm(nameField.text, emailField.text, messageField.text)
                }
            }
            
            // Подсказка
            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                x: Theme.horizontalPageMargin
                visible: !wsClient.connected
                text: "Подключитесь к серверу для отправки формы"
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignHCenter
            }
            
            Item {
                width: 1
                height: Theme.paddingLarge
            }
        }
    }
}
