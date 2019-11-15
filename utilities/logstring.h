/****************************************************************************
** logstring.h - Log string definition
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

#ifndef LOGSTRING_H
#define LOGSTRING_H

#include <QObject>
#include <QQmlContext>

class LogString : public QObject
{
    Q_OBJECT

public:
    explicit LogString(QQmlContext *context, QObject *parent = 0);

    Q_INVOKABLE QString translate(const QString &string);
    Q_INVOKABLE QString translateEx(const QString &string, int begin, int end);
    Q_INVOKABLE QString trs(const QString &str);
    Q_INVOKABLE QStringList title(const QString &type);
    ~LogString();

    QStringList titleExp(const QString &type);
};

#endif // LOGSTRING_H
