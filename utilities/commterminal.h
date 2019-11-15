/****************************************************************************
** commterminal.h - Socket service for terminal
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

#ifndef COMMTERMINAL_H
#define COMMTERMINAL_H

#define COMM_SOCKET_SERVICE     0

#include <QObject>
#include <QQmlContext>
#include "connection.h"

class CommTerminal : public QObject
{
    Q_OBJECT
public:
    explicit CommTerminal(QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE void respond(QString msg);
    Q_INVOKABLE void maskMessage(QString msg);
    Q_INVOKABLE void unmaskMessage(QString msg);
    Q_INVOKABLE QString printmaskMessage();
    Q_INVOKABLE bool checkParams(QStringList params, int num);
    Q_INVOKABLE void createConnection();
signals:
    void recieveCommand(QString cmd, QStringList params);

public slots:
    void parseComm(QStringList);
private:
    Connection* mConnection;
};

#endif // COMMTERMINAL_H
