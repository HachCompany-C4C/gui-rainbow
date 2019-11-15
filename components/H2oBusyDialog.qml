/****************************************************************************
** H2oBusyDialog.qml - Busy dialog
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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

Item
{
    id: busyDialog
    width: 800
    height: 480
    z: 1
    visible: true
    property alias text: messgae.text

    function open(msg) {
        if(msg === undefined) {
            busyDialog.text = "";
        } else {
            busyDialog.text = msg;
        }
        visible = true;
    }

    function close() {
        visible = false;
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.5
        color: "black"
    }

    BusyIndicator {
        anchors.centerIn: parent
        width: 100
        height: 100
        running: busyDialog.visible
    }

    Text {
        id: messgae
        x: 341
        y: 309
        text: qsTr("Initializing ...")+translator.tr
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 16
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
    }
}
