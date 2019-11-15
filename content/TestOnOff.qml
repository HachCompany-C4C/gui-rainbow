/****************************************************************************
** TestOnOff.qml - test on off
**
** Created on: 2017-10-31
**
** Author:
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
    id: onOffCircle
    property real dioameter: 25
    property bool onOff: true
    property color onColor: "#0098db"
    property color offColor: "gray"
    //property color borderColor: "black"
    property color txtColor: "white"
    property string txt: ""

    width: dioameter
    height: dioameter
    radius: 90
    //border.color: borderColor
    color: onOff?onColor:offColor

    Text {
        anchors.horizontalCenter: onOffCircle.horizontalCenter
        anchors.verticalCenter: onOffCircle.verticalCenter
        font.pixelSize: dioameter/2
        color: txtColor
        text:txt
    }
}
