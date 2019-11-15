/****************************************************************************
** AndroidDelegate.qml - Item for listview
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

Item {
    id: root
    width: parent.width
    height: 64
    opacity: enabled ? 1.0 : 0.4
    property string imageSource: ""
    property alias text: textitem.text
    signal clicked

    Rectangle {
        anchors.fill: parent
        color: "#9e9e9e"
        visible: mouse.pressed
    }

    /*Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        source: imageSource
    }*/

    Text {
        id: image
        x: 14
        width: 24
        height: 24
        font: mainTheme.mediumIcon
        color: "#3ebdf2"
        text: imageSource
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: textitem
        color: "black"
        text: modelData
        anchors.verticalCenterOffset: 0
        font: theme.smallFont
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 35
    }

    Rectangle {
        width: parent.width - 40
        height: Flat.FlatStyle.onePixel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: Flat.FlatStyle.lightFrameColor
    }

    Text {
        id: arrow
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        font: mainTheme.mediumIcon
        color: "#9e9e9e"
        text: "\uf054"
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
