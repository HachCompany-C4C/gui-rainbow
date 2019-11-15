/****************************************************************************
** common.h - Common interfaces include message output, version
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

#ifndef COMMON_H
#define COMMON_H
#include <QFile>
#include "config.h"

class Common
{

public:
    Common()
    {
        //ignoredList << "IfProbe::1" << "ProbePage::" << "ProbeObject::" << "ProbeClass::" << "IfModbus::1" << "IfDebug::" << "QML::UpdatePage";
    }

    static QString mainVersion();
    static QString appVersion();
    static void messageOutputNull(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    static void messageOutputStd(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    static void messageOutputFile(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    static void messageOutputIPC(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    static void messageOutputIPCFile(QtMsgType type, const QMessageLogContext &context, const QString &msg);
    static void addIgnoredString(QString str);
    static void delIgnoredString(QString str);
    static void addIgnoredString(QStringList list);
    static QStringList ignoredString();
private:
    static void outputFile(const QString &txt);
};

#endif // COMMON_H
