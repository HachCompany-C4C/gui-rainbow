/****************************************************************************
** application.cpp
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

#include "application.h"

Application::Application(int &argc, char ** argv) : QApplication(argc, argv)
{

}

bool Application::notify(QObject *obj, QEvent *e)
{
    Q_UNUSED(obj);
    QPoint gPos = QCursor::pos();

    switch (e->type())
    {
    //case QEvent::KeyPress:
    //case QEvent::KeyRelease:
    //case QEvent::MouseMove:
        //mTouchPressed = true;
        //qDebug() << "Application::notify MouseMove";
        //break;
    case QEvent::MouseButtonPress:
        // qDebug() << "Application::notify MouseButtonPress";
        mTouchPressed = true;
        emit touchEventPressed();

        break;
    case QEvent::MouseButtonRelease:
        if(mTouchPressed) {
            mTouchPressed = false;
            qDebug() << "Application::notify MOUSE_CLICK, " << gPos.x() << "," << gPos.y();
            emit touchEventReleased();
        }
        break;
    default:
        break;
    }
    return QApplication::notify(obj, e);
}

/*void Application::initTimeout()
{
    qDebug() << "Application::initTimeout";


    if(mTouchPressed) {
        qDebug() << "Application::initTimeout pressed";
        mTouchPressedCount++;
        if(mTouchPressedCount > 2) {
            mTimer->stop();
            delete mTimer;
            //emit touchHoldTimeout();
            qDebug() << "Application::initTimeout goto calibrate";
        }
    }

    mTimeoutCount ++;
    if(mTimeoutCount > 16) {
        mTimer->stop();
        delete mTimer;
    }
}*/
