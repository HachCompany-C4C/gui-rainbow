/****************************************************************************
** H2oNotifyDialog.qml
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

    function open(msg) {
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

    MouseArea {
        anchors.fill: parent
    }
}
