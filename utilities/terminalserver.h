/****************************************************************************
** terminalserver.h - Dbus adapter for terminal server
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

#ifndef TERMINALSERVER_H
#define TERMINALSERVER_H

#include <QObject>
#include <QThread>
#include <QQmlContext>
#include <QtDBus/QtDBus>
//#include "termserver_adaptor.h"
class TermserverInterfaceAdaptor;

class TerminalServer : public QObject
{
    Q_OBJECT
public:
    explicit TerminalServer(QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE void respond(QString res);
    void createAdapter();
signals:
    void received(const QString cmd, const QStringList params);

public Q_SLOTS:
    QStringList write(const QStringList cmds);

public slots:

private:
    QString mRespond;
    TermserverInterfaceAdaptor *mAdaptor;
};

#endif // TERMINALSERVER_H
