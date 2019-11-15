/****************************************************************************
** messageoutput.h - Message output by dbus
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

#ifndef MESSAGEOUTPUT_H
#define MESSAGEOUTPUT_H

#include <QObject>
#include <QQmlContext>
#include "messageoutput_interface.h"

class MessageOutput : public QObject
{
    Q_OBJECT
public:
    explicit MessageOutput(QQmlContext *context, QObject *parent = 0);

    Q_INVOKABLE void debug(QString message);
    static void output(QString message );

    /*static MessageOutput *getInstance()
    {
        if(mInstance == NULL)
        {
            mInstance = new MessageOutput;
        }

        return mInstance;
    }*/

signals:

public slots:

private:
    h2o::probe::messageservice *mIfMessage;

    //static MessageOutput *mInstance;
};

#endif // MESSAGEOUTPUT_H
