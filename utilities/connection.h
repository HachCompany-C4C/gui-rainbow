/****************************************************************************
** connection.h - Network connection
**
** Created on: 2017-10-31
**
** Author: BW
**
** Copyright (C) 2016 Hach DDC
**              All Rights Reserved
**
**
** Notes:
**
****************************************************************************/

#ifndef SERVER_H
#define SERVER_H

#include <QStringList>
#include <QTcpServer>
#include <QNetworkSession>

class Server : public QTcpServer
{
    Q_OBJECT

public:
    Server(QObject *parent = 0)
    {
        Q_UNUSED(parent);
    }

signals:
    void newConnection(qintptr socketDescriptor);

protected:
    void incomingConnection(qintptr socketDescriptor) override
    {
        emit newConnection(socketDescriptor);
    }
};

class Connection : public QObject
{
    Q_OBJECT

public:
    explicit Connection();
    void send(QString data);
    void networkConfig();

private slots:
    void sessionOpened();
    void createNewConnection(qintptr socketDescriptor);
    void readData();
signals:
    void received(QStringList);
private:
    Server *tcpServer;
    QNetworkSession *networkSession;
    QTcpSocket *clientConnection;

};

#endif
