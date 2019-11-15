/****************************************************************************
** networkinterface.h - Network inteface to get ip and mac
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

#ifndef NETWORKINTERFACE_H
#define NETWORKINTERFACE_H
#include <QQmlContext>
#include <QObject>

class NetworkInterface : public QObject
{
    Q_OBJECT
public:
    explicit NetworkInterface(QQmlContext *context, QObject *parent = 0);

    Q_INVOKABLE QString getHostIpAddress();
    Q_INVOKABLE QString getHostMacAddress();
signals:

public slots:
};

#endif // NETWORKINTERFACE_H
