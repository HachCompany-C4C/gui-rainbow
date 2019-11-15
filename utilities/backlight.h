/****************************************************************************
** backlight.h - Handle the backlight on/off for lcd
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

#ifndef BACKLIGHT_H
#define BACKLIGHT_H

#include <QObject>
#include <QQmlContext>
#include <QFile>
#include <QTextStream>
#include <QApplication>
#include <QTimer>

class Backlight : public QObject
{
    Q_OBJECT
public:
    explicit Backlight(QApplication *app, QQmlContext *context);
    ~Backlight();

    Q_INVOKABLE void setTime(int second);
    Q_INVOKABLE void setOnOff(bool b);
    Q_INVOKABLE int time();
    Q_INVOKABLE bool status();
    Q_INVOKABLE bool switchState();
protected:
    //bool eventFilter(QObject *obj, QEvent *event);
    //void run();
signals:

public slots:
    void setOn();
    void setOff();
private:
    bool set(bool b);

    QFile *mTouchEvent;
    QTimer *mTimer; //milliseconds
    int mTime;
    bool mStatus;
    bool mSwitch;
};

#endif // BACKLIGHT_H
