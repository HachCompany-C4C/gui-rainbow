/****************************************************************************
** systime.h - Interfaces to get and set system time
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

#ifndef SYSTIME_H
#define SYSTIME_H
#include <QObject>
#include <QQmlContext>

class SysTime: public QObject
{
    Q_OBJECT
public:
    SysTime(QQmlContext *context);

#ifndef __WIN32
    Q_INVOKABLE int getSystemTime(struct tm* t_tm);
#endif
    Q_INVOKABLE int setSystemTime(int year, int mon, int mday, int hour, int min, int sec);

    Q_INVOKABLE int setYear(int year);
    Q_INVOKABLE int setMon(int mon);
    Q_INVOKABLE int setMday(int mday);
    Q_INVOKABLE int setHour(int hour);
    Q_INVOKABLE int setMin(int min);
    Q_INVOKABLE int setSec(int sec);

    Q_INVOKABLE void setSync(bool b);
    Q_INVOKABLE bool isSync();

private:
    bool mSync;
};

#endif // SYSTIME_H
