/****************************************************************************
** file.h - File tool
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

#ifndef FILE_H
#define FILE_H

#include <QObject>
#include <QFile>
#include <QQmlContext>
#include "settings.h"

class File : public QObject
{
    Q_OBJECT
public:
    explicit File(Settings *settings, QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE QString getDrivePath();
    Q_INVOKABLE QString getDrivePathW();
    Q_INVOKABLE bool openFile(QString name);
    Q_INVOKABLE bool closeFile(QString name);
    Q_INVOKABLE bool writeFile(QString name, QString data);
    Q_INVOKABLE QString readFile(QString name);

    Q_INVOKABLE QString findFile(QString strFilePath);
    Q_INVOKABLE bool findFileByName(QString strFilePath, QString strFileName);
    Q_INVOKABLE bool copyFileToPath(QString sourceDir ,QString toDir, bool coverFileIfExist);
    Q_INVOKABLE bool copyDirectoryFiles(const QString &fromDir, const QString &toDir, bool coverFileIfExist);
    Q_INVOKABLE bool exportLogFile();

    void updateTime(QString path);
private:
    bool isDriveValid(QString path);

    Settings *mSettings;
signals:

public slots:
};

#endif // FILE_H
