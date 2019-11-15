/****************************************************************************
** H2oNavigationSubItem.qml
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
    height: 60
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

    /*Text {
        id: image
        x: 14
        width: 24
        height: 24
        font.family: theme.bigIcon
        font.pixelSize: 24
        color: "#3ebdf2"
        text: imageSource
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
    }*/

    Text {
        id: textitem
        color: "black"
        text: modelData
        anchors.verticalCenterOffset: 0
        font: mainTheme.font22
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 50
    }

    Rectangle {
        width: parent.width-50
        height: Flat.FlatStyle.onePixel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.margins: 15
        color: Flat.FlatStyle.mediumFrameColor
    }

    /*Text {
        id: arrow
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        font.family: theme.mediumIcon
        color: "#9e9e9e"
        text: "\uf054"
        verticalAlignment: Text.AlignVCenter
    }*/

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
}
