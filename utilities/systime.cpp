/****************************************************************************
** systime.cpp - Interfaces to get and set system time
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

#include <QDebug>
#include "systime.h"

#ifndef Q_OS_WIN
#include <time.h>
#include <sys/time.h>
#endif

SysTime::SysTime(QQmlContext *context)
{
    Q_ASSERT(context);
    context->setContextProperty("system_time", this);
    mSync = false;
}

// set synchronization of system time
void SysTime::setSync(bool b)
{
    mSync = b;
}

bool SysTime::isSync()
{
    return mSync;
}

#ifndef __WIN32
int SysTime::getSystemTime(struct tm* datetime)
{
    time_t timer;
    struct tm* t_tm;
    time(&timer);
    t_tm = localtime(&timer);

    memcpy(datetime, t_tm, sizeof(struct tm));

    return 0;
}
#endif

int SysTime::setSystemTime(int year, int mon, int mday, int hour, int min, int sec)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;

    _tm.tm_sec = sec;
    _tm.tm_min = min;
    _tm.tm_hour = hour;
    _tm.tm_mday = mday;
    _tm.tm_mon = mon;
    _tm.tm_year = year - 1900;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif

    return 0;
}

int SysTime::setYear(int year)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_year = year - 1900;

    //qDebug() << "SysTime::setYear year " << year;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif

    return 0;
}

int SysTime::setMon(int mon)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_mon = mon;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif
    return 0;
}

int SysTime::setMday(int mday)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_mday = mday;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif
    return 0;
}

int SysTime::setHour(int hour)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_hour = hour;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif
    return 0;
}

int SysTime::setMin(int min)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_min = min;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif
    return 0;
}

int SysTime::setSec(int sec)
{
#ifndef Q_OS_WIN
    struct tm _tm;
    struct timeval tv;
    time_t timep;
    getSystemTime(&_tm);
    _tm.tm_sec = sec;

    timep = mktime(&_tm);
    tv.tv_sec = timep;
    tv.tv_usec = 0;
    if(settimeofday (&tv, (struct timezone *) 0) < 0)
    {
        qDebug() << "SysTime::SetSystemTime Set system datatime error!";
        return -1;
    }

    system("hwclock -w --localtime");
#endif
    return 0;
}

