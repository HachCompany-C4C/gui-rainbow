/****************************************************************************
** panelleds.cpp - Handle the status of leds in panel
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

#include <QFile>
#include <QTextStream>
#include <QDebug>
#include "panelleds.h"

PanelLeds::PanelLeds(QQmlContext *context, QObject *parent) : QObject(parent)
{
    Q_ASSERT(context);
    context->setContextProperty("panelleds_setting", this);
    setValue(1); //initialize green status
}

// 0 - all off; 1 - green; 2 - yellow; 3-red
bool PanelLeds::setValue(int value)
{
    QFile redLed("/sys/class/leds/panel_red/brightness");
    QFile greenLed("/sys/class/leds/panel_green/brightness");

    QString red, green;

    switch(value)
    {
    case 0:
        red = "0";
        green = "0";
        break;
    case 1:
        red = "0";
        green = "1";
        break;
    case 2:
        red = "1";
        green = "1";
        break;
    case 3:
        red = "1";
        green = "0";
        break;
    default:
        red = "0";
        green = "0";
    }

    if(redLed.exists())
    {
        if(redLed.open(QIODevice::ReadWrite))
        {
            QTextStream out(&redLed);
            out << red;
        } else {
            qDebug() << "PanelLeds::setValue redLed open fail";
        }

        redLed.close();
    }
    else
    {
        qDebug() << "PanelLeds::setValue redLed not exist";
        return false;
    }

    if(greenLed.exists())
    {
        if(greenLed.open(QIODevice::ReadWrite))
        {
            QTextStream out(&greenLed);
            out << green;
        } else {
            qDebug() << "PanelLeds::setValue greenLed open fail";
        }

        greenLed.close();
    }
    else
    {
        qDebug() << "PanelLeds::setValue greenLed not exist";
        return false;
    }

    return true;
}
