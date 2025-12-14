#include "contactserver.h"
#include "contactvalidator.h"
#include <QJsonArray>
#include <QDateTime>
#include <QNetworkInterface>

ContactServer::ContactServer(QObject *parent)
    : QObject(parent)
    , m_server(new QWebSocketServer(QStringLiteral("Contact Form Server"),
                                     QWebSocketServer::NonSecureMode,
                                     this))
    , m_messageCount(0)
{
    connect(m_server, &QWebSocketServer::newConnection, 
            this, &ContactServer::onNewConnection);
}

ContactServer::~ContactServer()
{
    stop();
}

bool ContactServer::start(const QString &address, int port)
{
    if (m_server->isListening()) {
        log("Сервер уже запущен", "warning");
        return true;
    }
    
    QHostAddress hostAddress(address);
    
    if (!m_server->listen(hostAddress, static_cast<quint16>(port))) {
        log(QString("Ошибка запуска сервера: %1").arg(m_server->errorString()), "error");
        return false;
    }
    
    m_serverAddress = QString("ws://%1:%2").arg(address).arg(port);
    log(QString("🚀 Сервер запущен на %1").arg(m_serverAddress), "success");
    
    emit runningChanged();
    return true;
}

void ContactServer::stop()
{
    if (!m_server->isListening()) {
        return;
    }
    
    log("Остановка сервера...", "info");
    
    m_server->close();
    qDeleteAll(m_clients);
    m_clients.clear();
    m_serverAddress.clear();
    
    log("Сервер остановлен", "info");
    emit runningChanged();
    emit clientCountChanged();
}

bool ContactServer::isRunning() const
{
    return m_server->isListening();
}

int ContactServer::clientCount() const
{
    return m_clients.size();
}

QStringList ContactServer::connectedClients() const
{
    QStringList clients;
    for (QWebSocket *client : m_clients) {
        clients.append(client->peerAddress().toString());
    }
    return clients;
}

int ContactServer::messageCount() const
{
    return m_messageCount;
}

QString ContactServer::serverAddress() const
{
    return m_serverAddress;
}

QStringList ContactServer::getLocalIpAddresses() const
{
    QStringList addresses;
    
    const QList<QHostAddress> allAddresses = QNetworkInterface::allAddresses();
    for (const QHostAddress &address : allAddresses) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && 
            !address.isLoopback()) {
            addresses.append(address.toString());
        }
    }
    
    return addresses;
}

void ContactServer::log(const QString &message, const QString &level)
{
    QString timestamp = QDateTime::currentDateTime().toString("hh:mm:ss");
    QString formattedMessage = QString("[%1] %2").arg(timestamp, message);
    
    if (level == "error") {
        qCritical().noquote() << formattedMessage;
    } else if (level == "warning") {
        qWarning().noquote() << formattedMessage;
    } else {
        qInfo().noquote() << formattedMessage;
    }
    
    emit logMessage(formattedMessage, level);
}

void ContactServer::onNewConnection()
{
    QWebSocket *client = m_server->nextPendingConnection();
    
    QString clientAddress = client->peerAddress().toString();
    log(QString("✅ Клиент подключен: %1").arg(clientAddress), "success");

    connect(client, &QWebSocket::textMessageReceived, 
            this, &ContactServer::processMessage);
    connect(client, &QWebSocket::disconnected, 
            this, &ContactServer::socketDisconnected);

    m_clients.append(client);
    
    emit clientConnected(clientAddress);
    emit clientCountChanged();
    
    sendWelcome(client);
}

void ContactServer::processMessage(const QString &message)
{
    QWebSocket *client = qobject_cast<QWebSocket *>(sender());
    if (!client) {
        return;
    }

    QString clientAddress = client->peerAddress().toString();
    log(QString("📨 Сообщение от %1").arg(clientAddress), "info");

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);
    
    if (parseError.error != QJsonParseError::NoError) {
        log(QString("❌ Ошибка парсинга JSON: %1").arg(parseError.errorString()), "error");
        
        QJsonObject errorResponse;
        errorResponse["type"] = "error";
        errorResponse["message"] = "Некорректный формат JSON";
        sendResponse(client, errorResponse);
        return;
    }

    QJsonObject obj = doc.object();
    QString type = obj["type"].toString();

    if (type == "contact_submit") {
        QJsonObject data = obj["data"].toObject();
        handleContactSubmit(client, data);
    } else {
        QJsonObject errorResponse;
        errorResponse["type"] = "error";
        errorResponse["message"] = QString("Неизвестный тип сообщения: %1").arg(type);
        sendResponse(client, errorResponse);
    }
}

void ContactServer::handleContactSubmit(QWebSocket *client, const QJsonObject &data)
{
    QString name = data["name"].toString().trimmed();
    QString email = data["email"].toString().trimmed();
    QString message = data["message"].toString().trimmed();

    QString clientAddress = client->peerAddress().toString();
    
    log(QString("📝 Форма от %1: %2 <%3>").arg(clientAddress, name, email), "info");

    ContactValidator validator;
    ValidationResult result = validator.validate(name, email, message);

    QJsonObject response;
    response["type"] = "contact_response";

    QString errors;
    
    if (result.isValid()) {
        log("✅ Валидация успешна", "success");
        
        response["success"] = true;
        response["message"] = "Сообщение успешно проверено и принято";
    } else {
        QJsonObject errorsObj;
        QStringList errorList;
        
        if (!result.nameError.isEmpty()) {
            errorsObj["name"] = result.nameError;
            errorList.append(QString("Имя: %1").arg(result.nameError));
        }
        if (!result.emailError.isEmpty()) {
            errorsObj["email"] = result.emailError;
            errorList.append(QString("Email: %1").arg(result.emailError));
        }
        if (!result.messageError.isEmpty()) {
            errorsObj["message"] = result.messageError;
            errorList.append(QString("Сообщение: %1").arg(result.messageError));
        }
        
        errors = errorList.join("; ");
        log(QString("❌ Ошибки валидации: %1").arg(errors), "warning");
        
        response["success"] = false;
        response["errors"] = errorsObj;
    }

    m_messageCount++;
    emit messageCountChanged();
    emit messageReceived(name, email, message, clientAddress, result.isValid(), errors);
    
    sendResponse(client, response);
}

void ContactServer::sendResponse(QWebSocket *client, const QJsonObject &response)
{
    if (client && client->isValid()) {
        QJsonDocument doc(response);
        client->sendTextMessage(doc.toJson(QJsonDocument::Compact));
    }
}

void ContactServer::sendWelcome(QWebSocket *client)
{
    QJsonObject welcome;
    welcome["type"] = "welcome";
    welcome["message"] = "Добро пожаловать! Сервер готов принимать данные формы.";
    welcome["timestamp"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODate);
    
    sendResponse(client, welcome);
}

void ContactServer::socketDisconnected()
{
    QWebSocket *client = qobject_cast<QWebSocket *>(sender());
    if (client) {
        QString clientAddress = client->peerAddress().toString();
        log(QString("👋 Клиент отключен: %1").arg(clientAddress), "info");
        
        m_clients.removeAll(client);
        client->deleteLater();
        
        emit clientDisconnected(clientAddress);
        emit clientCountChanged();
    }
}

