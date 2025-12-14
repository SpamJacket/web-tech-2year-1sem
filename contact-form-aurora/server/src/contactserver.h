#ifndef CONTACTSERVER_H
#define CONTACTSERVER_H

#include <QObject>
#include <QWebSocketServer>
#include <QWebSocket>
#include <QList>
#include <QHostAddress>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStringList>
#include <QDateTime>

// Структура для хранения информации о сообщении
struct ContactMessage {
    Q_GADGET
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QString email MEMBER email)
    Q_PROPERTY(QString message MEMBER message)
    Q_PROPERTY(QString clientAddress MEMBER clientAddress)
    Q_PROPERTY(QString timestamp MEMBER timestamp)
    Q_PROPERTY(bool isValid MEMBER isValid)
    Q_PROPERTY(QString validationErrors MEMBER validationErrors)
public:
    QString name;
    QString email;
    QString message;
    QString clientAddress;
    QString timestamp;
    bool isValid;
    QString validationErrors;
};

class ContactServer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int clientCount READ clientCount NOTIFY clientCountChanged)
    Q_PROPERTY(QStringList connectedClients READ connectedClients NOTIFY clientCountChanged)
    Q_PROPERTY(int messageCount READ messageCount NOTIFY messageCountChanged)
    Q_PROPERTY(QString serverAddress READ serverAddress NOTIFY runningChanged)

public:
    explicit ContactServer(QObject *parent = nullptr);
    ~ContactServer();

    Q_INVOKABLE bool start(const QString &address = "0.0.0.0", int port = 8080);
    Q_INVOKABLE void stop();
    
    bool isRunning() const;
    int clientCount() const;
    QStringList connectedClients() const;
    int messageCount() const;
    QString serverAddress() const;
    
    Q_INVOKABLE QStringList getLocalIpAddresses() const;

signals:
    void runningChanged();
    void clientCountChanged();
    void messageCountChanged();
    void clientConnected(const QString &address);
    void clientDisconnected(const QString &address);
    void messageReceived(const QString &name, const QString &email, 
                         const QString &message, const QString &clientAddress,
                         bool isValid, const QString &errors);
    void logMessage(const QString &message, const QString &level);

private slots:
    void onNewConnection();
    void processMessage(const QString &message);
    void socketDisconnected();

private:
    void handleContactSubmit(QWebSocket *client, const QJsonObject &data);
    void sendResponse(QWebSocket *client, const QJsonObject &response);
    void sendWelcome(QWebSocket *client);
    void log(const QString &message, const QString &level = "info");

    QWebSocketServer *m_server;
    QList<QWebSocket *> m_clients;
    int m_messageCount;
    QString m_serverAddress;
};

#endif // CONTACTSERVER_H

