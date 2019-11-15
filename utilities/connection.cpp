/****************************************************************************
** connection.cpp - Network connection
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

#include <QtNetwork>
#include <QDebug>
#include <QQmlContext>
#include <stdlib.h>

#include "connection.h"

Connection::Connection()
    : tcpServer(Q_NULLPTR)
    , networkSession(0)
{
    networkConfig();
}

void Connection::networkConfig()
{
    QNetworkConfigurationManager manager;
    if (manager.capabilities() & QNetworkConfigurationManager::NetworkSessionRequired) {
        // Get saved network configuration
        QSettings settings(QSettings::UserScope, QLatin1String("QtProject"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        const QString id = settings.value(QLatin1String("DefaultNetworkConfiguration")).toString();
        settings.endGroup();

        // If the saved network configuration is not currently discovered use the system default
        QNetworkConfiguration config = manager.configurationFromIdentifier(id);
        if ((config.state() & QNetworkConfiguration::Discovered) !=
            QNetworkConfiguration::Discovered) {
            config = manager.defaultConfiguration();
        }

        networkSession = new QNetworkSession(config, this);
        connect(networkSession, &QNetworkSession::opened, this, &Connection::sessionOpened);

        qDebug() << "Opening network session.";
        networkSession->open();
    } else {
        sessionOpened();
    }

    connect(tcpServer, SIGNAL(newConnection(qintptr)), this, SLOT(createNewConnection(qintptr)));
}

void Connection::sessionOpened()
{
    // Save the used configuration
    if (networkSession) {
        QNetworkConfiguration config = networkSession->configuration();
        QString id;
        if (config.type() == QNetworkConfiguration::UserChoice)
            id = networkSession->sessionProperty(QLatin1String("UserChoiceConfiguration")).toString();
        else
            id = config.identifier();

        QSettings settings(QSettings::UserScope, QLatin1String("QtProject"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        settings.setValue(QLatin1String("DefaultNetworkConfiguration"), id);
        settings.endGroup();
    }

    tcpServer = new Server(this); //QTcpServer(this);
    //QHostAddress hostAddress;
    //hostAddress.setAddress("10.131.136.123");
    if (!tcpServer->listen(QHostAddress::Any, 8888)) {
        qDebug() << "Unable to start the server: "
                 << tcpServer->errorString();
        return;
    }

    qDebug() << "The server is running on\n\nIP: "
             <<tcpServer->serverAddress().toString()
            << "\nport: "
            << tcpServer->serverPort();

    /*QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // use the first non-localhost IPv4 address
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
            ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // if we did not find one, use IPv4 localhost
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
    */
}

void Connection::createNewConnection(qintptr socketDescriptor)
{
    qDebug() << "Server::createNewConnection";
    clientConnection = new QTcpSocket; //tcpServer->nextPendingConnection();
    clientConnection->setSocketDescriptor(socketDescriptor);

    connect(clientConnection, SIGNAL(readyRead()),
            this, SLOT(readData()));
}

void Connection::readData()
{
    QByteArray blockIn;
    QDataStream in(&blockIn, QIODevice::ReadOnly);
    in.setVersion(QDataStream::Qt_4_0);

    blockIn = clientConnection->readAll();
    QString inData = QString(blockIn);
    QStringList list = inData.split(' ');
    emit received(list);
}

void Connection::send(QString data)
{
    QByteArray blockOut;
    QDataStream out(&blockOut, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);
    out << data;
    clientConnection->write(blockOut);
}
