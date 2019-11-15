/****************************************************************************
** messageoutput.cpp - Message output by dbus
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

#include "messageoutput.h"

static h2o::probe::messageservice ifMessage("h2o.probe.messageservice",
                                            "/h2o/probe/messageservice",
                                            QDBusConnection::sessionBus());

MessageOutput::MessageOutput(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);

    context->setContextProperty("message_output", this);

    mIfMessage = &ifMessage;
    qDebug() << "MessageOutput::MessageOutput" << "interface valid: " << mIfMessage->isValid();
}

void MessageOutput::debug(QString message)
{
    if(mIfMessage->isValid()) {
        mIfMessage->output(message);
    }
}

void MessageOutput::output(QString message)
{
    if(ifMessage.isValid()) {
        ifMessage.output(message);
    }
}
