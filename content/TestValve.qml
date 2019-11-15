/****************************************************************************
** TestValve.qml - test valve
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

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../components"
Rectangle{
    id: valveDelegate
    property alias  vCheck: valveSwith.checked
    property string name: qsTr("valve")
    signal statusChanged(var checkValue)
    Text {
        id: valveText
        x: 2
        y: 2
        text: name
        font: mainTheme.titleFont
    }

    H2oSwitch {
        id: valveSwith
        anchors.left: valveText.left
        anchors.leftMargin: 40
        anchors.verticalCenter: valveText.verticalCenter
        width: 75
        height: 40

        onClicked:  {
            valveDelegate.statusChanged(valveSwith.checked)
        }
    }
    TestOnOff {
        id: valveState
        anchors.verticalCenter: valveText.verticalCenter
        anchors.left: valveSwith.right
        anchors.leftMargin: 8
        onOff: vCheck
        dioameter: 40
    }
}

