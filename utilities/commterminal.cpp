/****************************************************************************
** commterminal.cpp - Socket service for terminal
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

#include "common.h"
#include "commterminal.h"

CommTerminal::CommTerminal(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    context->setContextProperty("comm_terminal", this);

}

void CommTerminal::createConnection()
{
    mConnection = new Connection();
    connect(mConnection, SIGNAL(received(QStringList)), this, SLOT(parseComm(QStringList)));
}

void CommTerminal::parseComm(QStringList list)
{
    QString command = list[0];
    QStringList params;

    // get parameter list
    for(int i = 1; i < list.length(); ++i) {
        params << list.at(i);
    }

    if(command.length() > 0)
    {
        qDebug() << "CommTerminal::parseComm: " << command << params;
        emit recieveCommand(command, params);
    } else {
        mConnection->send("illege command");
    }
}

void CommTerminal::respond(QString msg)
{
    if(mConnection) {
        mConnection->send(msg);
    }
}

bool CommTerminal::checkParams(QStringList params, int num)
{
    if(params.length() != num) {
        respond("parameters error");
        return false;
    } else {
        return true;
    }
}

void CommTerminal::maskMessage(QString msg)
{
    Common::addIgnoredString(msg);
}

void CommTerminal::unmaskMessage(QString msg)
{
    Common::delIgnoredString(msg);
}

QString CommTerminal::printmaskMessage()
{
    QString retStr;
    QStringList list = Common::ignoredString();
    foreach (const QString &str, list) {
        retStr += str;// + " ";
    }

    return retStr;
}
