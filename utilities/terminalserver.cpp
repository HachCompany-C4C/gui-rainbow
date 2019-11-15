/****************************************************************************
** terminalserver.cpp - Dbus adapter for terminal server
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

#include "terminalserver.h"
#include <QtDBus/QtDBus>
#include "termserver_adaptor.h"

TerminalServer::TerminalServer(QQmlContext *context, QObject *parent) : QObject(parent)
{
    // qDebug() << "TerminalServer::TerminalServer";

    Q_ASSERT(context);
    context->setContextProperty("terminal_server", this);
}

void TerminalServer::createAdapter()
{
    mAdaptor = new TermserverInterfaceAdaptor(this);
    QDBusConnection connection = QDBusConnection::sessionBus();
    connection.registerObject("/Termserver", this);
    connection.registerService("h2o.probe.Termserver");
}

QStringList TerminalServer::write(const QStringList cmds)
{
    QStringList paras;
    for(int i = 1; i < cmds.length(); i++) {
        paras << cmds[i];
    }
    mRespond = "";
    emit received(cmds[0], paras);
    QStringList list;
    list << mRespond;
    return list;
}

void TerminalServer::respond(QString res)
{
    mRespond = res;
}

