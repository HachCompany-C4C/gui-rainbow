/****************************************************************************
** mouseevent.cpp - Mouse event
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

#include "mouseevent.h"
#include <QApplication>
#include <QMouseEvent>
#include <QWidget>
#include <QDebug>

MouseEvent::MouseEvent(QQmlApplicationEngine *engine, Application *app)
{
    Q_ASSERT(app);
    Q_ASSERT(engine);
    QQmlContext *context = engine->rootContext();
    context->setContextProperty("mouse_event", this);
    mApp = app;
    mEngine = engine;
    connect(app, SIGNAL(touchEventPressed()), this, SIGNAL(pressed()));
}

