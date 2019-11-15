/****************************************************************************
** backlight.cpp - Handle the backlight on/off for lcd
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
#include <QTouchEvent>
#include <QFile>
#include "backlight.h"

#define PER_MINUTE 60000

Backlight::Backlight(QApplication *app, QQmlContext *context)
{
    Q_ASSERT(context);
    Q_ASSERT(app);
    context->setContextProperty("backlight_setting", this);

    mTime = PER_MINUTE * 2;
    mSwitch = false;

    mTimer = new QTimer();
    connect(mTimer, SIGNAL(timeout()), this, SLOT(setOff()));
    mTimer->setSingleShot(true);
    mTimer->stop();
    setOn();
    if(mSwitch)
    {
        mTimer->start(mTime);
    }
}

int Backlight::time()
{
    return mTime/PER_MINUTE;
}

bool Backlight::switchState()
{
    return mSwitch;
}

bool Backlight::status()
{
    return mStatus;
}

void Backlight::setTime(int minutes)
{
    if(minutes > 0) {
        mTime = PER_MINUTE * minutes;
        //qDebug() << "Backlight::setTime " << mTime;
        if(mSwitch) {
            mTimer->stop();
            mTimer->start(mTime);
        }
    }
}

void Backlight::setOnOff(bool b)
{
    mSwitch = b;
    if(mSwitch)
    {
        mTimer->stop();
        mTimer->start(mTime);
    } else {
        mTimer->stop();
    }
    //qDebug() << "Backlight::setOnOff " << mSwitch;
}

/*void Backlight::run()
{
    qDebug() << "Backlight::run start";
    if(mTouchEvent->exists())
    {
        if(mTouchEvent->open(QIODevice::ReadOnly))
        {
            qDebug() << "Backlight::run open done";
            while (1) {
                QByteArray ba = mTouchEvent->read(256);
                qDebug() << "Backlight::run readAll" << ba;
                sleep(1);
            }
        } else {
            qDebug() << "Backlight::run open failed";
        }
    }
    else
    {
        qDebug() << "Backlight::run not exist";
    }

}*/

/*bool Backlight::eventFilter(QObject *obj, QEvent *event)
{
    Q_UNUSED(obj);
    switch (event->type()) {
    case QEvent::KeyPress:
    case QEvent::KeyRelease:
    case QEvent::MouseButtonPress:
    case QEvent::MouseButtonRelease:
    case QEvent::MouseMove:
        //qDebug() << "Backlight::eventFilter eventOccurred";
        break;
    default:
        break;
    }
}*/

void Backlight::setOn()
{
    set(true);
    if(mSwitch)
    {
        mTimer->stop();
        mTimer->start(mTime);
    }
    //qDebug() << "Backlight::setOn";
}

void Backlight::setOff()
{
    set(false);
    //qDebug() << "Backlight::setOff";
}

bool Backlight::set(bool b)
{
    QFile bl("/sys/class/backlight/backlight/bl_power");
    mStatus = b;
    if(bl.exists())
    {
        if(bl.open(QIODevice::ReadWrite))
        {
            QTextStream out(&bl);
            out << (b ? "0" : "1");
        } else {
            qDebug() << "Backlight::set open fail";
        }

        bl.close();
    }
    else
    {
        //qDebug() << "Backlight::set not exist";
        return false;
    }

    return true;
}

Backlight::~Backlight()
{
    if(mTimer) {
        delete mTimer;
    }
}
