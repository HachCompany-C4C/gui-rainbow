/****************************************************************************
** application.h
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

#ifndef APPLICATION_H
#define APPLICATION_H

#include <QApplication>
#include <QDebug>
#include <QTimer>

class Application : public QApplication
{
    Q_OBJECT
public:
    Application(int &argc, char ** argv);
    bool notify(QObject *, QEvent *);
signals:
    void touchEventOccurred();
    void touchEventPressed();
    void touchEventReleased();
    void touchHoldTimeout();
public slots:
    //void initTimeout();

private:
    bool mTouchPressed;
    //int mTimeoutCount;
    //int mTouchPressedCount;
    //QTimer *mTimer;
};

#endif // APPLICATION_H
