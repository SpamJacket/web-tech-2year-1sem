#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QString>
#include <QUrl>
#include <QJsonObject>
#include <QJsonDocument>

class WebSocketClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString serverUrl READ serverUrl WRITE setServerUrl NOTIFY serverUrlChanged)
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(bool connecting READ isConnecting NOTIFY connectingChanged)

public:
    explicit WebSocketClient(QObject *parent = nullptr);
    ~WebSocketClient();

    QString serverUrl() const;
    void setServerUrl(const QString &url);

    bool isConnected() const;
    bool isConnecting() const;

public slots:
    void connectToServer();
    void disconnectFromServer();
    void submitContactForm(const QString &name, const QString &email, const QString &message);

signals:
    void serverUrlChanged();
    void connectedChanged();
    void connectingChanged();
    void welcomeReceived(const QString &message);
    void contactFormSuccess(const QString &message);
    void contactFormError(const QString &nameError, const QString &emailError, const QString &messageError);
    void connectionError(const QString &error);

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(const QString &message);
    void onError(QAbstractSocket::SocketError error);

private:
    QWebSocket m_webSocket;
    QString m_serverUrl;
    bool m_connected;
    bool m_connecting;
};

#endif // WEBSOCKETCLIENT_H

