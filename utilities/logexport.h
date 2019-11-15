/****************************************************************************
** logexport.h - Export log
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

#ifndef LOGEXPORT_H
#define LOGEXPORT_H

#include <QObject>
#include <QThread>
#include <QQmlContext>
#include <QFile>
#include "jsonparse.h"
#include "logstring.h"
#include "file.h"

class LogExport : public QThread
{
    Q_OBJECT

public:
    LogExport(LogString *logString, JsonParse *jsonParse, QQmlContext *context, File *file);
    Q_INVOKABLE bool startProcess();
    Q_INVOKABLE bool isIdle();
    Q_INVOKABLE QString getDrivePath();
    Q_INVOKABLE int countData(QString type = "mcudata");
    Q_INVOKABLE void setTypeList(const QStringList &list);
    Q_INVOKABLE void setSNBuff(QString sn);
    Q_INVOKABLE QString translate(const QString &str);
    Q_INVOKABLE QString trs(const QString &str);
    Q_INVOKABLE QString error();
protected:
    void run();

signals:

private:
    QString exportLog2File(QString type, QString time);
    int getDriveAvailableSize();
    QStringList mExportLogTypeList;
    JsonParse *mJsonParse;
    File *mFile;
    QString mSNBuff;
    LogString *mLogString;
    QString mError;
};

#endif // LOGEXPORT_H
