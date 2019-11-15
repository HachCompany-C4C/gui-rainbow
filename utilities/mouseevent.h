/****************************************************************************
** mouseevent.h - Mouse event
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

#ifndef MOUSEEVENT_H
#define MOUSEEVENT_H

#include <QObject>
#include <QQmlContext>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QThread>
#include <QTimer>
#include "application.h"

class MouseEvent : public QThread
{
    Q_OBJECT
public:
    explicit MouseEvent(QQmlApplicationEngine *engine, Application *app);

protected:
    //void run();
    //void mouseMoveEvent(QMouseEvent *eventMove);
    //void mousePressEvent(QMouseEvent *eventPress);
    //void mouseReleaseEvent(QMouseEvent *releaseEvent);
signals:
    void pressed();
public slots:

private:
    QApplication *mApp;
    QQmlApplicationEngine *mEngine;
};

#endif // MOUSEEVENT_H
