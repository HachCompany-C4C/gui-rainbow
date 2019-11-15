/****************************************************************************
** H2oHelpButton.qml
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

import QtQuick 2.0

Rectangle {
    id: root
    width: 40
    height: 40
    signal clicked()

    Rectangle {
        width: 20
        height: 20
        anchors.centerIn: parent
        radius: 10
        color: "#0098db"
        Text {
            anchors.centerIn: parent
            text: "?"
            color: "white"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
