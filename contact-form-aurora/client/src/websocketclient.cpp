#include "websocketclient.h"
#include <QDebug>
#include <QJsonArray>

WebSocketClient::WebSocketClient(QObject *parent)
    : QObject(parent)
    , m_connected(false)
    , m_connecting(false)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocketClient::onDisconnected);
    connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
}

WebSocketClient::~WebSocketClient()
{
    m_webSocket.close();
}

QString WebSocketClient::serverUrl() const
{
    return m_serverUrl;
}

void WebSocketClient::setServerUrl(const QString &url)
{
    if (m_serverUrl != url) {
        m_serverUrl = url;
        emit serverUrlChanged();
    }
}

bool WebSocketClient::isConnected() const
{
    return m_connected;
}

bool WebSocketClient::isConnecting() const
{
    return m_connecting;
}

void WebSocketClient::connectToServer()
{
    if (m_connected || m_connecting) {
        return;
    }

    qDebug() << "Connecting to server:" << m_serverUrl;
    
    m_connecting = true;
    emit connectingChanged();
    
    m_webSocket.open(QUrl(m_serverUrl));
}

void WebSocketClient::disconnectFromServer()
{
    m_webSocket.close();
}

void WebSocketClient::submitContactForm(const QString &name, const QString &email, const QString &message)
{
    if (!m_connected) {
        emit connectionError("Нет подключения к серверу");
        return;
    }

    QJsonObject data;
    data["name"] = name;
    data["email"] = email;
    data["message"] = message;

    QJsonObject messageObj;
    messageObj["type"] = "contact_submit";
    messageObj["data"] = data;

    QJsonDocument doc(messageObj);
    QString jsonString = doc.toJson(QJsonDocument::Compact);

    qDebug() << "Sending contact form:" << jsonString;
    m_webSocket.sendTextMessage(jsonString);
}

void WebSocketClient::onConnected()
{
    qDebug() << "Connected to server";
    m_connecting = false;
    m_connected = true;
    emit connectingChanged();
    emit connectedChanged();
}

void WebSocketClient::onDisconnected()
{
    qDebug() << "Disconnected from server";
    m_connecting = false;
    m_connected = false;
    emit connectingChanged();
    emit connectedChanged();
}

void WebSocketClient::onTextMessageReceived(const QString &message)
{
    qDebug() << "Message received:" << message;

    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    if (!doc.isObject()) {
        qWarning() << "Invalid JSON received";
        return;
    }

    QJsonObject obj = doc.object();
    QString type = obj["type"].toString();

    if (type == "welcome") {
        QString welcomeMessage = obj["message"].toString();
        emit welcomeReceived(welcomeMessage);
    }
    else if (type == "contact_response") {
        bool success = obj["success"].toBool();
        
        if (success) {
            QString successMessage = obj["message"].toString();
            emit contactFormSuccess(successMessage);
        } else {
            QJsonObject errors = obj["errors"].toObject();
            QString nameError = errors["name"].toString();
            QString emailError = errors["email"].toString();
            QString messageError = errors["message"].toString();
            emit contactFormError(nameError, emailError, messageError);
        }
    }
    else if (type == "error") {
        QString errorMessage = obj["message"].toString();
        emit connectionError(errorMessage);
    }
}

void WebSocketClient::onError(QAbstractSocket::SocketError error)
{
    Q_UNUSED(error)
    qDebug() << "WebSocket error:" << m_webSocket.errorString();
    
    m_connecting = false;
    emit connectingChanged();
    emit connectionError(m_webSocket.errorString());
}

