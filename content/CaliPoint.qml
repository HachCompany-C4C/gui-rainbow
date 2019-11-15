/****************************************************************************
** CaliPoint.qml - Point for touch calibration
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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: caliPoint
    x: 0
    y: 0
    width: 60
    height: width
    color: "white"
    radius: width/2

    Rectangle {
        x: 18
        y: 18
        width: 24
        height: width
        color: "red"
        radius: width/2
    }
}
