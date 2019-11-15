/****************************************************************************
** H2oCircleProgressDialog.qml -
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
    visible: false
    property alias text: messgae.text
    property alias value: processCircle.value

    function open(msg) {
        busyDialog.text = msg;
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

    H2oProgressCircle {
        id: processCircle
        x: 300
        y: 84
        width: 200
        height: 200
        lineWidth:16
    }

    Text {
        id: messgae
        x: 341
        y: 309
        text: "Initializing ..."
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
