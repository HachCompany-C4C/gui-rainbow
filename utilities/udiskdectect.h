/****************************************************************************
** udiskdectect.h - To detect usb disk exist
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

#ifndef UDISKDECTECT_H
#define UDISKDECTECT_H

#include <QObject>
#include <QtDBus/QDBusConnection>
#include <QQmlContext>
#include "file.h"

class UDiskDectect : public QObject
{
    Q_OBJECT
public:
    explicit UDiskDectect(QQmlContext *context, File *file, QObject *parent = 0);

    Q_INVOKABLE QString findFile(QString strFilePath);
    Q_INVOKABLE bool isExist();
signals:
    void sigUDiskDectect(bool exist);
public slots:
    void slotDeviceAdded(QString str);
    void slotDeviceRemoved(QString str);

private:
    bool mIsExist;
    File* mFileTool;
};

#endif // UDISKDECTECT_H
