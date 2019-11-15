/****************************************************************************
** udiskdectect.cpp - To detect usb disk exist
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

#include "udiskdectect.h"
#include <QStorageInfo>
#include <QDir>
#include <QDirIterator>
#include <QFileInfoList>
#include <QFileInfo>
#include <QDebug>

QString busName = "UDisks2";

UDiskDectect::UDiskDectect(QQmlContext *context, File * file, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    Q_ASSERT(file);

    context->setContextProperty("udisk_dectect", this);

    /*QDBusConnection::systemBus().connect("org.freedesktop."+busName,
                                         "/org/freedesktop/"+busName,
                                         "org.freedesktop.DBus.ObjectManager",
                                         "InterfacesAdded",
                                         this,
                                         SLOT(slotDeviceAdded(QString)));

    QDBusConnection::systemBus().connect("org.freedesktop."+busName,
                                         "/org/freedesktop/"+busName,
                                         "org.freedesktop.DBus.ObjectManager",
                                         "InterfacesRemoved",
                                         this,
                                         SLOT(slotDeviceRemoved(QString)));*/
    // qDebug() << "UDiskDectect::UDiskDectect";

    mIsExist = false;
    mFileTool = file;
}

void UDiskDectect::slotDeviceAdded(QString str)
{
    qDebug() << "UDiskDectect::slotDeviceAdded" << str;
}

void UDiskDectect::slotDeviceRemoved(QString str)
{
    qDebug() << "UDiskDectect::slotDeviceRemoved" << str;
}

QString UDiskDectect::findFile(QString strFilePath)
{
    QDir dir;

    dir.setPath(strFilePath);
    QFileInfoList list = dir.entryInfoList();
    QString findName = "";

    for(int i = 0; i < list.size(); i++) {
        QFileInfo fileInfo = list.at(i);
        QString baseName = fileInfo.baseName();
        if(baseName != "")
        {
            // qDebug() << "File::findFile" << baseName;
            findName = baseName;
        }
    }

    bool exist = (findName != "") ? true : false;
    if(mIsExist != exist) {

        if(mIsExist == false) {
            QString drive = mFileTool->getDrivePath();
            qDebug() << "UDiskDectect::findFile driver" << drive;
            if(drive != "") {
                mIsExist = exist;

            }
        } else {
            mIsExist = exist;
        }
        emit sigUDiskDectect(mIsExist);
    }

    return findName;
}

bool UDiskDectect::isExist()
{
    return mIsExist;
}
