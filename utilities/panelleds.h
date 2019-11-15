/****************************************************************************
** panelleds.h - Handle the status of leds in panel
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

#ifndef PANELLEDS_H
#define PANELLEDS_H

#include <QObject>
#include <QQmlContext>

class PanelLeds : public QObject
{
    Q_OBJECT
public:
    explicit PanelLeds(QQmlContext *context, QObject *parent = 0);
    Q_INVOKABLE bool setValue(int value);
signals:

public slots:
};

#endif // PANELLEDS_H
