/****************************************************************************
** SignalDataDelegate.qml - Signal data delegate
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles.Flat 1.0 as Flat

Rectangle {
    id: root
    width: parent.width
    height: 64

    property alias text: textitem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#9e9e9e"
        visible: mouse.pressed
    }

    Text {
        id: textitem
        color: "black"
        font: theme.smallFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
    }

    // line
    Rectangle {
        width: parent.width
        height: Flat.FlatStyle.onePixel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        //anchors.margins: 15
        color: Flat.FlatStyle.lightFrameColor
    }

    Image {
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:///resources/images/navigation_next_item-hach.png"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
