/****************************************************************************
** TestPump.qml - test on off
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
    id: root
    property string name: qsTr("pump")+translator.tr
    property bool operated: false
    signal clicked()

    Text {
        id: pump_text
        x: 2
        y: 2
        text: qsTr(name)+translator.tr
        font: mainTheme.titleFont
    }

    /*Button {
        id: go
        anchors.left: pump_text.right
        anchors.top: pump_text.top
        anchors.leftMargin: 10
        width: 65
        height: 40
        style: {
            radius: 15

        }

        text: "Go"
        onClicked: {
            clicked()
        }
    }*/
    H2oButton {
        id: go
        anchors.verticalCenter: pump_text.verticalCenter
        anchors.left: pump_text.right
        anchors.leftMargin: 5
        width: 110
        height: 40
        text: qsTr("START")+translator.tr
        //buttonRadius: 15

        onClicked: {
            root.clicked()
        }
    }
}


